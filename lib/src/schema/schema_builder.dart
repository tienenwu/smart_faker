import '../annotations/faker_field.dart';
import '../core/smart_faker.dart';
import 'importers/json_schema_importer.dart';
import 'importers/openapi_schema_importer.dart';
import 'importers/prisma_schema_importer.dart';
import 'importers/schema_importer.dart';

export 'field_validators.dart';

/// Schema definition for generating structured data.
class Schema {
  final String name;
  final Map<String, FieldDefinition> fields;
  final bool timestamps;
  final List<Relationship>? relationships;

  Schema({
    required this.name,
    required this.fields,
    this.timestamps = false,
    this.relationships,
  });
}

/// Field definition for schema.
class FieldDefinition {
  /// The type of the field.
  final FakerFieldType type;

  /// Whether the field is required.
  final bool required;

  /// Default value for the field.
  final dynamic defaultValue;

  /// Minimum value for numeric fields.
  final dynamic min;

  /// Maximum value for numeric fields.
  final dynamic max;

  /// Pattern for string generation.
  final String? pattern;

  /// Reference to another field or schema.
  final String? reference;

  /// Additional options for field generation.
  final Map<String, dynamic>? options;

  /// Custom validator function.
  final bool Function(dynamic)? validator;

  /// Validation error message.
  final String? validationMessage;

  FieldDefinition({
    required this.type,
    this.required = true,
    this.defaultValue,
    this.min,
    this.max,
    this.pattern,
    this.reference,
    this.options,
    this.validator,
    this.validationMessage,
  });
}

/// Relationship between schemas.
class Relationship {
  final String field;
  final String targetSchema;
  final RelationshipType type;
  final String? foreignKey;
  final int? minItems;
  final int? maxItems;

  Relationship({
    required this.field,
    required this.targetSchema,
    required this.type,
    this.foreignKey,
    this.minItems,
    this.maxItems,
  });
}

enum RelationshipType { hasOne, hasMany, belongsTo }

/// Builder for generating data from schemas.
class SchemaBuilder {
  final SmartFaker faker;
  final Map<String, Schema> _schemas = {};
  final Map<String, dynamic> _cache = {};
  final Map<String, List<Map<String, dynamic>>> _generatedData = {};

  SchemaBuilder(this.faker);

  /// Registers a schema.
  void registerSchema(Schema schema) {
    _schemas[schema.name] = schema;
  }

  /// Checks whether a schema with the given [name] is registered.
  bool hasSchema(String name) => _schemas.containsKey(name);

  /// Registers multiple schemas.
  void registerSchemas(Iterable<Schema> schemas) {
    for (final schema in schemas) {
      registerSchema(schema);
    }
  }

  /// Imports schemas from a JSON Schema document.
  SchemaImportResult importFromJsonSchema(
    Map<String, dynamic> document, {
    Iterable<String>? schemaNames,
    String? rootSchemaName,
    SchemaImportConfig? config,
  }) {
    final importer = JsonSchemaImporter(config: config);
    final result = importer.importFromDocument(
      document,
      schemaNames: schemaNames,
      rootSchemaName: rootSchemaName,
    );
    registerSchemas(result.schemas);
    return result;
  }

  /// Imports schemas from an OpenAPI document (v3+).
  SchemaImportResult importFromOpenApi(
    Map<String, dynamic> document, {
    Iterable<String>? componentNames,
    SchemaImportConfig? config,
  }) {
    final importer = OpenApiSchemaImporter(config: config);
    final result = importer.importFromDocument(
      document,
      componentNames: componentNames,
    );
    registerSchemas(result.schemas);
    return result;
  }

  /// Imports models from a Prisma schema file.
  SchemaImportResult importFromPrisma(
    String source, {
    Iterable<String>? modelNames,
    SchemaImportConfig? config,
  }) {
    final importer = PrismaSchemaImporter(config: config);
    final result = importer.importFromSource(
      source,
      modelNames: modelNames,
    );
    registerSchemas(result.schemas);
    return result;
  }

  /// Generates data for a schema.
  Map<String, dynamic> generate(String schemaName) {
    final schema = _schemas[schemaName];
    if (schema == null) {
      throw Exception('Schema $schemaName not found');
    }

    final result = <String, dynamic>{};

    // Generate fields
    schema.fields.forEach((fieldName, fieldDef) {
      if (fieldDef.required || faker.random.boolean()) {
        result[fieldName] = _generateFieldValue(fieldName, fieldDef);
      }
    });

    // Add timestamps if needed
    if (schema.timestamps) {
      result['createdAt'] = faker.dateTime.past();
      result['updatedAt'] = faker.dateTime.recent();
    }

    // Handle relationships
    if (schema.relationships != null) {
      for (final relationship in schema.relationships!) {
        result[relationship.field] = _generateRelationship(relationship);
      }
    }

    // Cache the generated data
    _generatedData.putIfAbsent(schemaName, () => []).add(result);

    return result;
  }

  /// Generates a list of data for a schema.
  List<Map<String, dynamic>> generateList(String schemaName,
      {required int count}) {
    final results = <Map<String, dynamic>>[];
    for (int i = 0; i < count; i++) {
      results.add(generate(schemaName));
    }
    return results;
  }

  /// Creates a schema builder with fluent API.
  static SchemaDefinitionBuilder defineSchema(String name) {
    return SchemaDefinitionBuilder(name);
  }

  dynamic _generateFieldValue(String fieldName, FieldDefinition fieldDef) {
    // Check for reference
    if (fieldDef.reference != null && _cache.containsKey(fieldDef.reference)) {
      return _cache[fieldDef.reference];
    }

    // Check for default value
    if (fieldDef.defaultValue != null) {
      return fieldDef.defaultValue;
    }

    // Generate based on pattern if provided
    dynamic value;
    if (fieldDef.pattern != null && fieldDef.pattern!.isNotEmpty) {
      // Use pattern module to generate from regex
      value = faker.pattern.fromRegex(fieldDef.pattern!);
    } else {
      // Generate based on type
      value = _generateByType(fieldDef);
    }

    // Validate if validator is provided
    if (fieldDef.validator != null) {
      int attempts = 0;
      while (!fieldDef.validator!(value) && attempts < 100) {
        if (fieldDef.pattern != null) {
          value = faker.pattern.fromRegex(fieldDef.pattern!);
        } else {
          value = _generateByType(fieldDef);
        }
        attempts++;
      }
      if (attempts >= 100) {
        throw Exception(
            'Could not generate valid value for field $fieldName: ${fieldDef.validationMessage ?? "validation failed"}');
      }
    }

    // Cache if needed
    if (fieldDef.reference != null) {
      _cache[fieldName] = value;
    }

    return value;
  }

  dynamic _generateByType(FieldDefinition fieldDef) {
    final enums = fieldDef.options?['enum'];
    if (enums is List && enums.isNotEmpty) {
      return faker.random.element(enums);
    }

    final examples = fieldDef.options?['examples'];
    if (examples is List && examples.isNotEmpty) {
      return faker.random.element(examples);
    }

    switch (fieldDef.type) {
      // Person types
      case FakerFieldType.firstName:
        return faker.person.firstName();
      case FakerFieldType.lastName:
        return faker.person.lastName();
      case FakerFieldType.fullName:
        return faker.person.fullName();
      case FakerFieldType.email:
        return faker.internet.email();
      case FakerFieldType.username:
        return faker.internet.username();
      case FakerFieldType.password:
        return faker.internet.password();
      case FakerFieldType.phone:
        return faker.phone.number();
      case FakerFieldType.avatar:
        return faker.image.avatar();
      case FakerFieldType.jobTitle:
        return faker.person.jobTitle();

      // Location types
      case FakerFieldType.address:
        return faker.location.streetAddress();
      case FakerFieldType.city:
        return faker.location.city();
      case FakerFieldType.country:
        return faker.location.country();
      case FakerFieldType.zipCode:
        return faker.location.zipCode();
      case FakerFieldType.latitude:
        return faker.location.latitude();
      case FakerFieldType.longitude:
        return faker.location.longitude();

      // DateTime types
      case FakerFieldType.date:
        return faker.dateTime.past().toIso8601String().split('T')[0];
      case FakerFieldType.time:
        return faker.dateTime.past().toIso8601String().split('T')[1];
      case FakerFieldType.dateTime:
        return faker.dateTime.past();
      case FakerFieldType.timestamp:
        return faker.dateTime.past().millisecondsSinceEpoch;

      // Commerce types
      case FakerFieldType.productName:
        return faker.commerce.productName();
      case FakerFieldType.price:
        final min = fieldDef.min as double? ?? 0.99;
        final max = fieldDef.max as double? ?? 999.99;
        return faker.commerce.price(min: min, max: max);
      case FakerFieldType.sku:
        return faker.commerce.sku();
      case FakerFieldType.barcode:
        return faker.commerce.barcode();

      // Company types
      case FakerFieldType.companyName:
        return faker.company.name();
      case FakerFieldType.industry:
        return faker.company.industry();
      case FakerFieldType.catchPhrase:
        return faker.company.catchphrase();

      // Finance types
      case FakerFieldType.creditCard:
        return faker.finance.creditCardNumber();
      case FakerFieldType.iban:
        return faker.finance.iban();
      case FakerFieldType.currency:
        return faker.finance.currencyCode();
      case FakerFieldType.amount:
        final min = fieldDef.min as double? ?? 0.0;
        final max = fieldDef.max as double? ?? 10000.0;
        return faker.finance.amount(min: min, max: max);
      case FakerFieldType.bitcoinAddress:
        return faker.crypto.bitcoinAddress();

      // Internet types
      case FakerFieldType.url:
        return faker.internet.url();
      case FakerFieldType.ipAddress:
        return faker.internet.ipv4();
      case FakerFieldType.macAddress:
        return faker.internet.macAddress();
      case FakerFieldType.userAgent:
        return faker.internet.userAgent();

      // Lorem types
      case FakerFieldType.word:
        return faker.lorem.word();
      case FakerFieldType.sentence:
        return faker.lorem.sentence();
      case FakerFieldType.paragraph:
        return faker.lorem.paragraph();
      case FakerFieldType.text:
        final wordCount = fieldDef.options?['wordCount'] as int? ?? 50;
        final words = <String>[];
        for (int i = 0; i < wordCount; i++) {
          words.add(faker.lorem.word());
        }
        return words.join(' ');

      // Number types
      case FakerFieldType.integer:
        final min = fieldDef.min as int? ?? 0;
        final max = fieldDef.max as int? ?? 100;
        return faker.random.integer(min: min, max: max);
      case FakerFieldType.double:
        final min = (fieldDef.min as num?)?.toDouble() ?? 0.0;
        final max = (fieldDef.max as num?)?.toDouble() ?? 100.0;
        return min + (faker.random.nextDouble() * (max - min));
      case FakerFieldType.boolean:
        return faker.random.boolean();

      // Special types
      case FakerFieldType.uuid:
        return faker.random.uuid();
      case FakerFieldType.json:
        return _generateJson(fieldDef.options ?? {});
      case FakerFieldType.list:
        return _generateList(fieldDef);
      case FakerFieldType.map:
        return _generateMap(fieldDef.options ?? {});
      case FakerFieldType.custom:
        return fieldDef.options?['value'] ?? 'custom_value';

      // Default
      case FakerFieldType.auto:
        return faker.lorem.word();
    }
  }

  dynamic _generateRelationship(Relationship relationship) {
    switch (relationship.type) {
      case RelationshipType.hasOne:
        return generate(relationship.targetSchema);
      case RelationshipType.hasMany:
        final min = relationship.minItems ?? 1;
        final rawMax = relationship.maxItems ?? (min + 3);
        final max = rawMax < min ? min : rawMax;
        final count = faker.random.integer(min: min, max: max);
        return generateList(relationship.targetSchema, count: count);
      case RelationshipType.belongsTo:
        // Return a reference ID
        final existingData = _generatedData[relationship.targetSchema];
        if (existingData != null && existingData.isNotEmpty) {
          final item = faker.random.element(existingData);
          if (relationship.foreignKey != null &&
              item.containsKey(relationship.foreignKey)) {
            return item[relationship.foreignKey];
          }
          return item['id'] ?? faker.random.uuid();
        }
        return faker.random.uuid();
    }
  }

  List<dynamic> _generateList(FieldDefinition fieldDef) {
    final count = fieldDef.options?['count'] as int? ?? 5;
    final itemType =
        fieldDef.options?['itemType'] as FakerFieldType? ?? FakerFieldType.word;

    final list = [];
    for (int i = 0; i < count; i++) {
      list.add(_generateByType(FieldDefinition(type: itemType)));
    }
    return list;
  }

  Map<String, dynamic> _generateMap(Map<String, dynamic> options) {
    final map = <String, dynamic>{};

    options.forEach((key, value) {
      if (value is FakerFieldType) {
        map[key] = _generateByType(FieldDefinition(type: value));
      } else {
        map[key] = value;
      }
    });

    return map;
  }

  Map<String, dynamic> _generateJson(Map<String, dynamic> options) {
    return _generateMap(options);
  }
}

/// Fluent API for defining schemas.
class SchemaDefinitionBuilder {
  final String name;
  final Map<String, FieldDefinition> fields = {};
  final List<Relationship> relationships = [];
  bool timestamps = false;

  SchemaDefinitionBuilder(this.name);

  /// Adds a field to the schema.
  SchemaDefinitionBuilder field(
    String name,
    FakerFieldType type, {
    bool required = true,
    dynamic defaultValue,
    dynamic min,
    dynamic max,
    String? pattern,
    String? reference,
    Map<String, dynamic>? options,
    bool Function(dynamic)? validator,
    String? validationMessage,
  }) {
    fields[name] = FieldDefinition(
      type: type,
      required: required,
      defaultValue: defaultValue,
      min: min,
      max: max,
      pattern: pattern,
      reference: reference,
      options: options,
      validator: validator,
      validationMessage: validationMessage,
    );
    return this;
  }

  /// Adds an ID field.
  SchemaDefinitionBuilder id() {
    return field('id', FakerFieldType.uuid);
  }

  /// Adds name fields.
  SchemaDefinitionBuilder withName() {
    field('firstName', FakerFieldType.firstName);
    field('lastName', FakerFieldType.lastName);
    return this;
  }

  /// Adds contact fields.
  SchemaDefinitionBuilder withContact() {
    field('email', FakerFieldType.email);
    field('phone', FakerFieldType.phone);
    return this;
  }

  /// Adds address fields.
  SchemaDefinitionBuilder withAddress() {
    field('address', FakerFieldType.address);
    field('city', FakerFieldType.city);
    field('zipCode', FakerFieldType.zipCode);
    field('country', FakerFieldType.country);
    return this;
  }

  /// Enables timestamps.
  SchemaDefinitionBuilder withTimestamps() {
    timestamps = true;
    return this;
  }

  /// Adds a relationship.
  SchemaDefinitionBuilder hasOne(String field, String targetSchema,
      {String? foreignKey}) {
    relationships.add(Relationship(
      field: field,
      targetSchema: targetSchema,
      type: RelationshipType.hasOne,
      foreignKey: foreignKey,
    ));
    return this;
  }

  /// Adds a has-many relationship.
  SchemaDefinitionBuilder hasMany(String field, String targetSchema,
      {String? foreignKey, int? minItems, int? maxItems}) {
    relationships.add(Relationship(
      field: field,
      targetSchema: targetSchema,
      type: RelationshipType.hasMany,
      foreignKey: foreignKey,
      minItems: minItems,
      maxItems: maxItems,
    ));
    return this;
  }

  /// Adds a belongs-to relationship.
  SchemaDefinitionBuilder belongsTo(String field, String targetSchema,
      {String? foreignKey}) {
    relationships.add(Relationship(
      field: field,
      targetSchema: targetSchema,
      type: RelationshipType.belongsTo,
      foreignKey: foreignKey,
    ));
    return this;
  }

  /// Builds the schema.
  Schema build() {
    return Schema(
      name: name,
      fields: fields,
      timestamps: timestamps,
      relationships: relationships.isNotEmpty ? relationships : null,
    );
  }
}
