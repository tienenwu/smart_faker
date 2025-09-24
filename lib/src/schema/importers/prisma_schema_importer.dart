import '../../annotations/faker_field.dart';
import '../schema_builder.dart';
import 'schema_importer.dart';

/// Imports Prisma schema models by parsing model definitions.
class PrismaSchemaImporter {
  PrismaSchemaImporter({SchemaImportConfig? config})
      : config = config ?? const SchemaImportConfig();

  final SchemaImportConfig config;

  SchemaImportResult importFromSource(
    String source, {
    Iterable<String>? modelNames,
  }) {
    final models = _parseModels(source);
    final targetNames = modelNames?.map(config.transformName).toSet();

    final schemas = <Schema>[];
    final warnings = <String>[];

    for (final model in models) {
      if (targetNames != null && !targetNames.contains(model.name)) {
        continue;
      }
      schemas.add(_buildSchema(model, models, warnings));
    }

    if (schemas.isEmpty) {
      warnings.add('No Prisma models were discovered in provided source.');
    }

    return SchemaImportResult(schemas: schemas, warnings: warnings);
  }

  Schema _buildSchema(
    _PrismaModel model,
    List<_PrismaModel> allModels,
    List<String> warnings,
  ) {
    final fields = <String, FieldDefinition>{};
    final relationships = <Relationship>[];

    for (final field in model.fields) {
      if (field.isRelation) {
        final targetExists = allModels.any((m) => m.name == field.baseType);
        if (!targetExists) {
          warnings.add('Relation target ${field.baseType} not found for field '
              '${model.name}.${field.name}.');
          continue;
        }

        final relationshipType = field.isList
            ? RelationshipType.hasMany
            : (field.isBelongsTo
                ? RelationshipType.belongsTo
                : RelationshipType.hasOne);

        relationships.add(Relationship(
          field: field.name,
          targetSchema: field.baseType,
          type: relationshipType,
          foreignKey: field.foreignKey,
          minItems: field.isList ? 1 : null,
          maxItems: field.isList ? field.listLength : null,
        ));

        fields[field.name] = _relationFieldDefinition(field);
        continue;
      }

      fields[field.name] = _scalarFieldDefinition(field);
    }

    return Schema(
      name: model.name,
      fields: fields,
      timestamps: model.hasTimestamps,
      relationships: relationships.isEmpty ? null : relationships,
    );
  }

  FieldDefinition _relationFieldDefinition(_PrismaField field) {
    if (field.isList) {
      return FieldDefinition(
        type: FakerFieldType.list,
        required: !field.isOptional,
        options: {
          'itemType': FakerFieldType.map,
          'count': field.listLength ?? 3,
        },
      );
    }

    if (field.isBelongsTo) {
      return FieldDefinition(
        type: FakerFieldType.uuid,
        required: !field.isOptional,
        reference: field.foreignKey,
      );
    }

    return FieldDefinition(
      type: FakerFieldType.map,
      required: !field.isOptional,
    );
  }

  FieldDefinition _scalarFieldDefinition(_PrismaField field) {
    final fakerType =
        _mapScalarType(field.baseType, field.name, field.attributes);
    final options = <String, dynamic>{};

    if (field.enumValues != null) {
      options['enum'] = field.enumValues;
    }

    return FieldDefinition(
      type: fakerType,
      required: !field.isOptional,
      min: field.min,
      max: field.max,
      options: options.isEmpty ? null : options,
    );
  }

  FakerFieldType _mapScalarType(
    String prismaType,
    String fieldName,
    List<String> attributes,
  ) {
    final lowerName = fieldName.toLowerCase();
    final hasDefaultUuid = attributes.any((attr) => attr.contains('uuid()'));

    switch (prismaType) {
      case 'String':
        if (lowerName.contains('email')) {
          return FakerFieldType.email;
        }
        if (lowerName.contains('phone')) {
          return FakerFieldType.phone;
        }
        if (lowerName.contains('name')) {
          return FakerFieldType.fullName;
        }
        if (hasDefaultUuid || lowerName.endsWith('id')) {
          return FakerFieldType.uuid;
        }
        return FakerFieldType.word;
      case 'Int':
      case 'BigInt':
        return FakerFieldType.integer;
      case 'Float':
      case 'Decimal':
        return FakerFieldType.double;
      case 'Boolean':
        return FakerFieldType.boolean;
      case 'DateTime':
        return FakerFieldType.dateTime;
      case 'Json':
        return FakerFieldType.json;
      case 'Bytes':
        return FakerFieldType.word;
      default:
        return FakerFieldType.auto;
    }
  }

  List<_PrismaModel> _parseModels(String source) {
    final modelRegex =
        RegExp(r'model\s+(\w+)\s*\{([^}]*)\}', multiLine: true, dotAll: true);
    final matches = modelRegex.allMatches(source);

    final models = <_PrismaModel>[];
    for (final match in matches) {
      final name = config.transformName(match.group(1)!);
      final body = match.group(2) ?? '';
      models.add(_parseModel(name, body));
    }
    return models;
  }

  _PrismaModel _parseModel(String name, String body) {
    final fields = <_PrismaField>[];
    var hasTimestamps = false;

    for (final rawLine in body.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('//') || line.startsWith('@@')) {
        continue;
      }
      if (line == '}') {
        continue;
      }

      final parts = line.split(RegExp(r'\s+'));
      if (parts.length < 2) {
        continue;
      }

      final fieldName = parts.first;
      final typeSegment = parts[1];
      final attrIndex = line.indexOf(typeSegment) + typeSegment.length;
      final attrSegment =
          attrIndex < line.length ? line.substring(attrIndex).trim() : '';

      final field = _parseField(fieldName, typeSegment, attrSegment);
      fields.add(field);

      if (fieldName == 'createdAt' || fieldName == 'updatedAt') {
        hasTimestamps = true;
      }
    }

    return _PrismaModel(
        name: name, fields: fields, hasTimestamps: hasTimestamps);
  }

  _PrismaField _parseField(
    String name,
    String typeSegment,
    String attrSegment,
  ) {
    var type = typeSegment;
    final attributes = _parseAttributes(attrSegment);

    bool isOptional = false;
    bool isList = false;

    if (type.endsWith('?')) {
      isOptional = true;
      type = type.substring(0, type.length - 1);
    }

    if (type.endsWith('[]')) {
      isList = true;
      type = type.substring(0, type.length - 2);
    }

    final isRelation = _isRelationType(type);

    String? foreignKey;
    bool isBelongsTo = false;
    int? listLength;

    if (isRelation) {
      final relationAttr = attributes.firstWhere(
        (attr) => attr.startsWith('@relation'),
        orElse: () => '',
      );

      if (relationAttr.isNotEmpty) {
        final fieldsMatch =
            RegExp(r'fields:\s*\[(.*?)\]').firstMatch(relationAttr);
        if (fieldsMatch != null) {
          final fieldToken = fieldsMatch.group(1);
          if (fieldToken != null) {
            final tokens = fieldToken.split(',').map((e) => e.trim()).toList();
            if (tokens.isNotEmpty) {
              foreignKey = tokens.first;
              isBelongsTo = true;
            }
          }
        }
      }

      final lengthMatch =
          RegExp(r'@length\((min:\s*(\d+))?,?\s*(max:\s*(\d+))?\)')
              .firstMatch(attrSegment);
      if (lengthMatch != null) {
        final max = lengthMatch.group(4);
        if (max != null) {
          listLength = int.tryParse(max);
        }
      }
    }

    List<String>? enumValues;
    final enumMatch = RegExp(r'@enum\(([^)]*)\)').firstMatch(attrSegment);
    if (enumMatch != null) {
      enumValues = enumMatch
          .group(1)
          ?.split(',')
          .map((e) => e.trim().replaceAll('"', '').replaceAll("'", ''))
          .where((element) => element.isNotEmpty)
          .toList();
    }

    final minMatch = RegExp(r'@min\((\d+)\)').firstMatch(attrSegment);
    final maxMatch = RegExp(r'@max\((\d+)\)').firstMatch(attrSegment);

    // ignore: avoid_print
    return _PrismaField(
      name: name,
      baseType: type,
      isOptional: isOptional,
      isList: isList,
      isRelation: isRelation,
      foreignKey: foreignKey,
      attributes: attributes,
      enumValues: enumValues,
      min: minMatch != null ? int.tryParse(minMatch.group(1)!) : null,
      max: maxMatch != null ? int.tryParse(maxMatch.group(1)!) : null,
      isBelongsTo: isBelongsTo,
      listLength: listLength,
    );
  }

  List<String> _parseAttributes(String attributeSegment) {
    if (attributeSegment.isEmpty) {
      return const [];
    }

    final attrs = <String>[];
    final buffer = StringBuffer();
    for (int i = 0; i < attributeSegment.length; i++) {
      final char = attributeSegment[i];

      if (char == '@' && buffer.isNotEmpty) {
        attrs.add(buffer.toString().trim());
        buffer.clear();
      }

      buffer.write(char);
    }

    if (buffer.isNotEmpty) {
      attrs.add(buffer.toString().trim());
    }

    return attrs.where((attr) => attr.startsWith('@')).toList();
  }

  bool _isRelationType(String type) {
    switch (type) {
      case 'String':
      case 'Int':
      case 'Float':
      case 'Decimal':
      case 'Boolean':
      case 'DateTime':
      case 'Json':
      case 'Bytes':
      case 'BigInt':
        return false;
      default:
        return true;
    }
  }
}

class _PrismaModel {
  _PrismaModel({
    required this.name,
    required this.fields,
    required this.hasTimestamps,
  });

  final String name;
  final List<_PrismaField> fields;
  final bool hasTimestamps;
}

class _PrismaField {
  _PrismaField({
    required this.name,
    required this.baseType,
    required this.isOptional,
    required this.isList,
    required this.isRelation,
    required this.attributes,
    this.foreignKey,
    this.enumValues,
    this.min,
    this.max,
    this.isBelongsTo = false,
    this.listLength,
  });

  final String name;
  final String baseType;
  final bool isOptional;
  final bool isList;
  final bool isRelation;
  final List<String> attributes;
  final String? foreignKey;
  final List<String>? enumValues;
  final int? min;
  final int? max;
  final bool isBelongsTo;
  final int? listLength;
}
