import 'dart:collection';

import '../../annotations/faker_field.dart';
import '../schema_builder.dart';
import 'schema_importer.dart';

/// Imports schemas from JSON Schema documents (Draft 7+).
class JsonSchemaImporter {
  JsonSchemaImporter({SchemaImportConfig? config})
      : config = config ?? const SchemaImportConfig();

  /// Import configuration.
  final SchemaImportConfig config;

  /// Creates schema definitions from the provided JSON schema [document].
  ///
  /// Optionally limit the import to a set of [schemaNames]. If omitted all
  /// definitions found in the document will be converted. When the top-level
  /// document describes a schema directly (has `properties`), it will be
  /// imported as [config.defaultSchemaName] unless a [rootSchemaName] is
  /// provided.
  SchemaImportResult importFromDocument(
    Map<String, dynamic> document, {
    Iterable<String>? schemaNames,
    String? rootSchemaName,
  }) {
    final context = _JsonSchemaContext(
      document: document,
      config: config,
    );

    final targets = _determineTargets(context, schemaNames, rootSchemaName);
    for (final name in targets) {
      context.buildSchema(name);
    }

    return SchemaImportResult(
      schemas: context.schemas.values.toList(),
      warnings: context.warnings,
    );
  }

  Set<String> _determineTargets(
    _JsonSchemaContext context,
    Iterable<String>? schemaNames,
    String? rootSchemaName,
  ) {
    final targets = <String>{};

    if (schemaNames != null && schemaNames.isNotEmpty) {
      targets.addAll(schemaNames.map(config.transformName));
      return targets;
    }

    if (rootSchemaName != null) {
      targets.add(config.transformName(rootSchemaName));
    } else if (context.rootHasProperties) {
      final rootName = context.documentTitle ?? config.defaultSchemaName;
      targets.add(config.transformName(rootName));
    }

    targets.addAll(context.definitionNames);

    if (targets.isEmpty) {
      context.warnings.add('No JSON schema definitions were discovered.');
    }

    return targets;
  }
}

class _JsonSchemaContext {
  _JsonSchemaContext({
    required this.document,
    required this.config,
  }) {
    _collectDefinitions();
  }

  final Map<String, dynamic> document;
  final SchemaImportConfig config;

  final Map<String, Map<String, dynamic>> _definitions = {};
  final Map<String, Schema> schemas = LinkedHashMap();
  final List<String> warnings = [];
  final Set<String> _processing = {};

  Iterable<String> get definitionNames => _definitions.keys;
  bool get rootHasProperties =>
      (document['properties'] as Map<String, dynamic>?)?.isNotEmpty ?? false;
  String? get documentTitle => document['title'] as String?;

  void _collectDefinitions() {
    final defs = document[r'$defs'];
    if (defs is Map<String, dynamic>) {
      defs.forEach(_registerDefinition);
    }

    final definitions = document['definitions'];
    if (definitions is Map<String, dynamic>) {
      definitions.forEach(_registerDefinition);
    }

    final components = document['components'];
    if (components is Map<String, dynamic>) {
      final schemas = components['schemas'];
      if (schemas is Map<String, dynamic>) {
        schemas.forEach(_registerDefinition);
      }
    }
  }

  void _registerDefinition(String name, dynamic value) {
    if (value is Map<String, dynamic>) {
      _definitions[config.transformName(name)] = value;
    }
  }

  Schema buildSchema(String name) {
    if (schemas.containsKey(name)) {
      return schemas[name]!;
    }

    if (_processing.contains(name)) {
      warnings.add('Detected circular reference for schema "$name".');
      return schemas[name] ??
          Schema(
            name: name,
            fields: const <String, FieldDefinition>{},
            relationships: const <Relationship>[],
          );
    }

    Map<String, dynamic>? definition;
    if (_definitions.containsKey(name)) {
      definition = _definitions[name];
    } else if (name == config.defaultSchemaName && rootHasProperties) {
      definition = document;
    } else if (document['title'] == name) {
      definition = document;
    }

    if (definition == null) {
      warnings.add('Schema "$name" not found in JSON schema document.');
      final fallback = Schema(
        name: name,
        fields: const <String, FieldDefinition>{},
      );
      schemas[name] = fallback;
      return fallback;
    }

    _processing.add(name);
    final schema = _parseSchema(name, definition);
    schemas[name] = schema;
    _processing.remove(name);
    return schema;
  }

  Schema _parseSchema(String name, Map<String, dynamic> definition) {
    final properties = (definition['properties'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final requiredKeys =
        ((definition['required'] as List?)?.cast<String>())?.toSet() ?? {};

    final fields = <String, FieldDefinition>{};
    final relationships = <Relationship>[];

    properties.forEach((propName, propSchema) {
      final resolved = _resolveSchema(propSchema);
      if (resolved == null) {
        warnings.add('Failed to resolve schema for property "$propName" in '
            'schema "$name".');
        return;
      }

      final bool isRequired = requiredKeys.contains(propName);

      if (config.inferRelationships && _isObjectSchema(resolved)) {
        final originalSchema = propSchema is Map<String, dynamic>
            ? propSchema
            : <String, dynamic>{};
        final targetName = _determineTargetName(
          name,
          propName,
          originalSchema,
          resolved,
        );
        final targetSchema = buildSchema(targetName);
        relationships.add(Relationship(
          field: propName,
          targetSchema: targetSchema.name,
          type: RelationshipType.hasOne,
        ));
        fields[propName] = FieldDefinition(
          type: FakerFieldType.map,
          required: isRequired,
        );
        return;
      }

      if (config.inferRelationships && _isArraySchema(resolved)) {
        final items = resolved['items'];
        if (items is Map<String, dynamic>) {
          final resolvedItems = _resolveSchema(items) ?? items;
          if (_isObjectSchema(resolvedItems)) {
            final targetName = _determineTargetName(
              name,
              propName,
              items,
              resolvedItems,
              plural: true,
            );
            final targetSchema = buildSchema(targetName);
            final minItems = resolved['minItems'] is int
                ? resolved['minItems'] as int
                : null;
            final maxItems = resolved['maxItems'] is int
                ? resolved['maxItems'] as int
                : null;
            relationships.add(Relationship(
              field: propName,
              targetSchema: targetSchema.name,
              type: RelationshipType.hasMany,
              minItems: minItems,
              maxItems: maxItems,
            ));
            fields[propName] = FieldDefinition(
              type: FakerFieldType.list,
              required: isRequired,
              options: {
                'itemType': FakerFieldType.map,
                if (minItems != null) 'count': minItems,
              },
            );
            return;
          } else {
            fields[propName] = _buildArrayField(
              resolved,
              resolvedItems,
              isRequired,
            );
            return;
          }
        }
      }

      fields[propName] = _buildFieldDefinition(
        propName,
        resolved,
        isRequired,
      );
    });

    final timestamps = definition['timestamps'] == true;

    return Schema(
      name: name,
      fields: fields,
      timestamps: timestamps,
      relationships: relationships.isEmpty ? null : relationships,
    );
  }

  Map<String, dynamic>? _resolveSchema(dynamic schemaNode) {
    if (schemaNode is Map<String, dynamic>) {
      if (schemaNode.containsKey(r'$ref')) {
        final ref = schemaNode[r'$ref'];
        if (ref is String) {
          return _resolveRef(ref);
        }
      }
      if (schemaNode.containsKey('allOf')) {
        return _mergeAllOf(schemaNode);
      }
      return schemaNode;
    }
    return null;
  }

  Map<String, dynamic>? _resolveRef(String ref) {
    if (!ref.startsWith('#/')) {
      warnings.add('External references are not supported: $ref');
      return null;
    }

    final segments = ref.substring(2).split('/');
    dynamic current = document;
    for (final segment in segments) {
      if (current is Map<String, dynamic> && current.containsKey(segment)) {
        current = current[segment];
      } else {
        warnings.add('Unable to resolve reference $ref');
        return null;
      }
    }

    if (current is Map<String, dynamic>) {
      return current;
    }
    warnings.add('Reference $ref did not resolve to an object schema.');
    return null;
  }

  Map<String, dynamic>? _mergeAllOf(Map<String, dynamic> schemaNode) {
    final allOf = schemaNode['allOf'];
    if (allOf is! List) {
      return schemaNode;
    }

    final merged = <String, dynamic>{};
    for (final part in allOf) {
      final resolved = _resolveSchema(part) ?? {};
      merged.addAll(resolved);
    }

    schemaNode.forEach((key, value) {
      if (key != 'allOf') {
        merged[key] = value;
      }
    });

    return merged;
  }

  bool _isObjectSchema(Map<String, dynamic> schema) {
    final type = schema['type'];
    if (type is String && type == 'object') {
      return true;
    }
    if (schema.containsKey('properties')) {
      return true;
    }
    return false;
  }

  bool _isArraySchema(Map<String, dynamic> schema) {
    final type = schema['type'];
    if (type is String && type == 'array') {
      return true;
    }
    return false;
  }

  String _determineTargetName(
    String parentName,
    String propertyName,
    Map<String, dynamic> originalSchema,
    Map<String, dynamic> resolvedSchema, {
    bool plural = false,
  }) {
    if (originalSchema['title'] is String) {
      return config.transformName(originalSchema['title'] as String);
    }
    if (resolvedSchema['title'] is String) {
      return config.transformName(resolvedSchema['title'] as String);
    }

    final ref = originalSchema[r'$ref'];
    if (ref is String && ref.startsWith('#/')) {
      final segments = ref.split('/');
      return config.transformName(segments.last);
    }

    final baseName =
        config.transformName('${parentName}_${_capitalize(propertyName)}');
    if (plural && baseName.endsWith('s')) {
      return baseName.substring(0, baseName.length - 1);
    }
    return baseName;
  }

  FieldDefinition _buildArrayField(
    Map<String, dynamic> arraySchema,
    Map<String, dynamic> itemSchema,
    bool isRequired,
  ) {
    final itemType = _mapToFakerFieldType(
      itemSchema['type'],
      itemSchema['format'],
      itemSchema,
    );

    final options = <String, dynamic>{
      'itemType': itemType,
    };

    if (arraySchema['minItems'] is int) {
      options['count'] = arraySchema['minItems'];
    } else if (arraySchema['maxItems'] is int) {
      options['count'] = arraySchema['maxItems'];
    }

    if (itemSchema['enum'] is List) {
      options['enum'] = itemSchema['enum'];
    }

    return FieldDefinition(
      type: FakerFieldType.list,
      required: isRequired,
      options: options.isEmpty ? null : options,
    );
  }

  FieldDefinition _buildFieldDefinition(
    String name,
    Map<String, dynamic> schema,
    bool isRequired,
  ) {
    final type = schema['type'];
    final format = schema['format'];

    final mappedType = _mapToFakerFieldType(type, format, schema);

    final minimum = schema['minimum'] ?? schema['minLength'];
    final maximum = schema['maximum'] ?? schema['maxLength'];
    final pattern = schema['pattern'] as String?;

    Map<String, dynamic>? options;
    if (schema['enum'] is List) {
      options = {'enum': schema['enum']};
    }
    if (schema['examples'] is List && schema['examples'].isNotEmpty) {
      (options ??= {})['examples'] = schema['examples'];
    }

    return FieldDefinition(
      type: mappedType,
      required: isRequired,
      min: minimum,
      max: maximum,
      pattern: pattern,
      options: options,
    );
  }

  FakerFieldType _mapToFakerFieldType(
    dynamic type,
    dynamic format,
    Map<String, dynamic> schema,
  ) {
    final resolvedType = _resolveType(type);

    if (resolvedType == 'string') {
      final pattern = schema['pattern'];
      if (pattern is String) {
        return FakerFieldType.text;
      }
      if (format is String) {
        switch (format) {
          case 'email':
            return FakerFieldType.email;
          case 'uri':
          case 'url':
            return FakerFieldType.url;
          case 'date-time':
            return FakerFieldType.dateTime;
          case 'date':
            return FakerFieldType.date;
          case 'uuid':
            return FakerFieldType.uuid;
          case 'ipv4':
            return FakerFieldType.ipAddress;
          case 'ipv6':
            return FakerFieldType.ipAddress;
          case 'hostname':
            return FakerFieldType.username;
          case 'phone':
          case 'phone-number':
            return FakerFieldType.phone;
          default:
        }
      }
      final propertyName = schema['title'] ?? '';
      if (propertyName is String &&
          propertyName.toLowerCase().contains('name')) {
        return FakerFieldType.fullName;
      }
      return FakerFieldType.word;
    }

    if (resolvedType == 'integer') {
      return FakerFieldType.integer;
    }

    if (resolvedType == 'number') {
      return FakerFieldType.double;
    }

    if (resolvedType == 'boolean') {
      return FakerFieldType.boolean;
    }

    if (resolvedType == 'array') {
      return FakerFieldType.list;
    }

    if (resolvedType == 'object') {
      return FakerFieldType.map;
    }

    return FakerFieldType.auto;
  }

  String? _resolveType(dynamic type) {
    if (type is String) {
      return type;
    }
    if (type is List) {
      return type.cast<String?>().firstWhere(
            (value) => value != null && value != 'null',
            orElse: () => 'string',
          );
    }
    return null;
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }
}
