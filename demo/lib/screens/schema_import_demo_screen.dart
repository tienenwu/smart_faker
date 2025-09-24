import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_faker/smart_faker.dart';

enum SchemaImportSource { jsonSchema, openApi, prisma }

class SchemaImportDemoScreen extends StatefulWidget {
  const SchemaImportDemoScreen({super.key});

  @override
  State<SchemaImportDemoScreen> createState() => _SchemaImportDemoScreenState();
}

class _SchemaImportDemoScreenState extends State<SchemaImportDemoScreen> {
  late SmartFaker faker;
  late SchemaBuilder builder;

  SchemaImportSource source = SchemaImportSource.jsonSchema;
  String locale = 'en_US';
  List<String> availableSchemas = [];
  String? selectedSchema;
  Map<String, dynamic>? generatedMap;
  List<Map<String, dynamic>> generatedList = const [];
  List<String> warnings = const [];
  bool showList = false;

  @override
  void initState() {
    super.initState();
    faker = SmartFaker(locale: locale);
    builder = SchemaBuilder(faker);
    _importSource();
  }

  void _importSource() {
    builder = SchemaBuilder(faker);
    SchemaImportResult result;
    switch (source) {
      case SchemaImportSource.jsonSchema:
        result = builder.importFromJsonSchema(
          _sampleJsonSchema(),
          rootSchemaName: 'Order',
        );
        break;
      case SchemaImportSource.openApi:
        result = builder.importFromOpenApi(
          _sampleOpenApi(),
          componentNames: const ['Product', 'InventoryRecord'],
        );
        break;
      case SchemaImportSource.prisma:
        result = builder.importFromPrisma(_samplePrisma());
        break;
    }

    final schemas = result.schemas.map((schema) => schema.name).toList();
    schemas.sort();

    setState(() {
      availableSchemas = schemas;
      warnings = result.warnings;
      selectedSchema = schemas.isEmpty ? null : schemas.first;
      showList = false;
      generatedMap = selectedSchema != null
          ? builder.generate(selectedSchema!)
          : <String, dynamic>{};
      generatedList = const [];
    });
  }

  void _changeLocale(String newLocale) {
    setState(() {
      locale = newLocale;
      faker = SmartFaker(locale: locale);
    });
    _importSource();
  }

  void _changeSource(SchemaImportSource newSource) {
    setState(() {
      source = newSource;
    });
    _importSource();
  }

  void _generateSingle() {
    if (selectedSchema == null) return;
    setState(() {
      generatedMap = builder.generate(selectedSchema!);
      showList = false;
    });
  }

  void _generateList() {
    if (selectedSchema == null) return;
    setState(() {
      generatedList = builder.generateList(selectedSchema!,
          count: faker.random.integer(min: 2, max: 5));
      showList = true;
    });
  }

  String _pretty(dynamic value) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(_normalize(value));
  }

  dynamic _normalize(dynamic value) {
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is Map) {
      return value.map((key, value) => MapEntry(key, _normalize(value)));
    }
    if (value is Iterable) {
      return value.map(_normalize).toList();
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schema Imports Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<SchemaImportSource>(
                        decoration: const InputDecoration(
                          labelText: 'Source Type',
                          border: OutlineInputBorder(),
                        ),
                        value: source,
                        items: SchemaImportSource.values
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(_sourceLabel(value)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _changeSource(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Locale',
                          border: OutlineInputBorder(),
                        ),
                        value: locale,
                        items: const [
                          DropdownMenuItem(
                              value: 'en_US', child: Text('English (US)')),
                          DropdownMenuItem(value: 'zh_TW', child: Text('繁體中文')),
                          DropdownMenuItem(value: 'ja_JP', child: Text('日本語')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _changeLocale(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (warnings.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: warnings
                        .map((warning) => Chip(
                              avatar: const Icon(Icons.warning, size: 16),
                              label: Text(warning),
                            ))
                        .toList(),
                  ),
                if (availableSchemas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Schema',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedSchema,
                    items: availableSchemas
                        .map(
                          (schema) => DropdownMenuItem(
                            value: schema,
                            child: Text(schema),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSchema = value;
                        });
                        _generateSingle();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _generateSingle,
                        icon: const Icon(Icons.description),
                        label: const Text('Generate One'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _generateList,
                        icon: const Icon(Icons.library_books),
                        label: const Text('Generate List'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontFamily: 'RobotoMono', fontSize: 12),
                child: SingleChildScrollView(
                  child: SelectableText(
                    showList
                        ? _pretty(generatedList)
                        : _pretty(generatedMap ?? {}),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _sourceLabel(SchemaImportSource value) {
    switch (value) {
      case SchemaImportSource.jsonSchema:
        return 'JSON Schema';
      case SchemaImportSource.openApi:
        return 'OpenAPI';
      case SchemaImportSource.prisma:
        return 'Prisma';
    }
  }

  Map<String, dynamic> _sampleJsonSchema() {
    return {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      'definitions': {
        'Customer': {
          'type': 'object',
          'title': 'Customer',
          'properties': {
            'id': {'type': 'string', 'format': 'uuid'},
            'email': {'type': 'string', 'format': 'email'},
            'firstName': {'type': 'string'},
            'lastName': {'type': 'string'},
            'loyaltyTier': {
              'type': 'string',
              'enum': ['silver', 'gold', 'diamond'],
            },
          },
          'required': ['id', 'email'],
        },
        'OrderItem': {
          'type': 'object',
          'title': 'OrderItem',
          'properties': {
            'sku': {'type': 'string'},
            'quantity': {'type': 'integer', 'minimum': 1, 'maximum': 5},
            'unitPrice': {'type': 'number', 'minimum': 1.0, 'maximum': 999.0},
          },
          'required': ['sku', 'quantity'],
        },
      },
      'title': 'Order',
      'type': 'object',
      'properties': {
        'orderNumber': {'type': 'string', 'format': 'uuid'},
        'status': {
          'type': 'string',
          'enum': ['created', 'paid', 'fulfilled', 'cancelled'],
        },
        'customer': {
          r'$ref': '#/definitions/Customer',
        },
        'items': {
          'type': 'array',
          'items': {
            r'$ref': '#/definitions/OrderItem',
          },
          'minItems': 3,
        },
        'total': {'type': 'number', 'minimum': 10, 'maximum': 5000},
      },
      'required': ['orderNumber', 'status', 'customer', 'items'],
    };
  }

  Map<String, dynamic> _sampleOpenApi() {
    return {
      'openapi': '3.0.0',
      'info': {
        'title': 'Inventory API',
        'version': '1.0.0',
      },
      'components': {
        'schemas': {
          'Product': {
            'type': 'object',
            'properties': {
              'id': {'type': 'string', 'format': 'uuid'},
              'name': {'type': 'string'},
              'description': {'type': 'string'},
              'price': {'type': 'number', 'minimum': 5, 'maximum': 999},
            },
            'required': ['id', 'name'],
          },
          'InventoryRecord': {
            'type': 'object',
            'properties': {
              'warehouseId': {'type': 'string', 'format': 'uuid'},
              'product': {
                r'$ref': '#/components/schemas/Product',
              },
              'quantity': {'type': 'integer', 'minimum': 0, 'maximum': 500},
              'status': {
                'type': 'string',
                'enum': ['in_stock', 'backorder', 'reserved'],
              },
            },
            'required': ['warehouseId', 'product'],
          },
        },
      },
    };
  }

  String _samplePrisma() {
    return '''
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  profile   Profile?
  posts     Post[]
  locale    String   @default("en_US")
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Profile {
  id          String  @id @default(uuid())
  displayName String?
  bio         String?
  user        User    @relation(fields: [userId], references: [id])
  userId      String
}

model Post {
  id       String @id @default(uuid())
  title    String
  content  String
  category Category
  author   User   @relation(fields: [authorId], references: [id])
  authorId String
}

enum Category {
  BLOG
  NEWS
  TUTORIAL
}
''';
  }
}
