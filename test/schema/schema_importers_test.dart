import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('Schema importers', () {
    late SmartFaker faker;
    late SchemaBuilder builder;

    setUp(() {
      faker = SmartFaker(seed: 123);
      builder = SchemaBuilder(faker);
    });

    test('imports JSON schema documents with relationships', () {
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
              'loyaltyTier': {
                'type': 'string',
                'enum': ['silver', 'gold', 'diamond'],
              },
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

      final result = builder.importFromJsonSchema(
        jsonSchema,
        rootSchemaName: 'Order',
      );

      expect(result.schemas, isNotEmpty);
      final order = builder.generate('Order');
      expect(order['status'], isNotNull);
      expect(order['status'], isIn(['created', 'paid', 'shipped']));
      expect(order['customer'], isA<Map<String, dynamic>>());
      final items = order['items'] as List;
      expect(items.length, greaterThanOrEqualTo(2));
    });

    test('imports OpenAPI components', () {
      final openApi = {
        'openapi': '3.0.0',
        'components': {
          'schemas': {
            'Product': {
              'type': 'object',
              'properties': {
                'id': {'type': 'string', 'format': 'uuid'},
                'name': {'type': 'string'},
                'price': {'type': 'number', 'minimum': 10, 'maximum': 999},
              },
              'required': ['id', 'name'],
            },
          },
        },
      };

      final result = builder.importFromOpenApi(openApi);

      expect(result.schemas.any((schema) => schema.name == 'Product'), isTrue);
      final product = builder.generate('Product');
      expect(product['id'], isNotEmpty);
      expect(product['name'], isNotEmpty);
    });

    test('imports Prisma models', () {
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

      final result = builder.importFromPrisma(prisma);
      expect(result.schemas.length, 3);
      final user = builder.generate('User');
      expect(user['email'], contains('@'));
      expect(user['posts'], isA<List>());
      final profile = builder.generate('Profile');
      expect(profile['user'], isNotNull);
    });
  });
}
