import 'dart:convert';

import 'package:smart_faker/smart_faker.dart';

void main() {
  final faker = SmartFaker();
  final builder = SchemaBuilder(faker);

  final jsonSchema = {
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
        },
        'required': ['id', 'email'],
      },
      'LineItem': {
        'type': 'object',
        'title': 'LineItem',
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
        'enum': ['created', 'paid', 'shipped'],
      },
      'customer': {
        r'$ref': '#/definitions/Customer',
      },
      'items': {
        'type': 'array',
        'items': {
          r'$ref': '#/definitions/LineItem',
        },
        'minItems': 2,
      },
    },
    'required': ['orderNumber', 'status', 'customer', 'items'],
  };

  builder.importFromJsonSchema(jsonSchema, rootSchemaName: 'Order');
  final order = builder.generate('Order');
  print('JSON Schema → Order sample');
  print(_pretty(order));

  final openApi = {
    'openapi': '3.0.0',
    'components': {
      'schemas': {
        'Product': {
          'type': 'object',
          'properties': {
            'id': {'type': 'string', 'format': 'uuid'},
            'name': {'type': 'string'},
            'price': {'type': 'number', 'minimum': 10, 'maximum': 500},
          },
          'required': ['id', 'name'],
        },
      },
    },
  };

  builder.importFromOpenApi(openApi, componentNames: ['Product']);
  final product = builder.generate('Product');
  print('\nOpenAPI → Product sample');
  print(_pretty(product));

  const prisma = '''
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  profile   Profile?
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Profile {
  id        String  @id @default(uuid())
  displayName String?
  user      User    @relation(fields: [userId], references: [id])
  userId    String
}

model Post {
  id      String @id @default(uuid())
  title   String
  content String
  author  User   @relation(fields: [authorId], references: [id])
  authorId String
}
''';

  builder.importFromPrisma(prisma);
  final user = builder.generate('User');
  print('\nPrisma schema → User sample');
  print(_pretty(user));
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

String _pretty(dynamic value) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(_normalize(value));
}
