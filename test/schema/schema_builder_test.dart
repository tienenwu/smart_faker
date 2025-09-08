import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('SchemaBuilder', () {
    late SmartFaker faker;
    late SchemaBuilder schemaBuilder;

    setUp(() {
      faker = SmartFaker(seed: 42);
      schemaBuilder = SchemaBuilder(faker);
    });

    group('Schema Definition', () {
      test('should create a simple schema', () {
        final schema = SchemaBuilder.defineSchema('User')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.fullName)
          .field('email', FakerFieldType.email)
          .build();

        expect(schema.name, equals('User'));
        expect(schema.fields.length, equals(3));
        expect(schema.fields['id']!.type, equals(FakerFieldType.uuid));
        expect(schema.fields['name']!.type, equals(FakerFieldType.fullName));
        expect(schema.fields['email']!.type, equals(FakerFieldType.email));
      });

      test('should create schema with helper methods', () {
        final schema = SchemaBuilder.defineSchema('Person')
          .id()
          .withName()
          .withContact()
          .withAddress()
          .withTimestamps()
          .build();

        expect(schema.fields.containsKey('id'), isTrue);
        expect(schema.fields.containsKey('firstName'), isTrue);
        expect(schema.fields.containsKey('lastName'), isTrue);
        expect(schema.fields.containsKey('email'), isTrue);
        expect(schema.fields.containsKey('phone'), isTrue);
        expect(schema.fields.containsKey('address'), isTrue);
        expect(schema.fields.containsKey('city'), isTrue);
        expect(schema.fields.containsKey('zipCode'), isTrue);
        expect(schema.fields.containsKey('country'), isTrue);
        expect(schema.timestamps, isTrue);
      });

      test('should support optional fields', () {
        final schema = SchemaBuilder.defineSchema('Product')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.productName)
          .field('description', FakerFieldType.paragraph, required: false)
          .build();

        expect(schema.fields['description']!.required, isFalse);
      });

      test('should support field constraints', () {
        final schema = SchemaBuilder.defineSchema('Product')
          .field('price', FakerFieldType.price, min: 10.0, max: 100.0)
          .field('quantity', FakerFieldType.integer, min: 1, max: 50)
          .build();

        expect(schema.fields['price']!.min, equals(10.0));
        expect(schema.fields['price']!.max, equals(100.0));
        expect(schema.fields['quantity']!.min, equals(1));
        expect(schema.fields['quantity']!.max, equals(50));
      });
    });

    group('Data Generation', () {
      test('should generate data from schema', () {
        final schema = SchemaBuilder.defineSchema('User')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.fullName)
          .field('email', FakerFieldType.email)
          .build();

        schemaBuilder.registerSchema(schema);
        final data = schemaBuilder.generate('User');

        expect(data['id'], isNotEmpty);
        expect(data['name'], isNotEmpty);
        expect(data['email'], contains('@'));
      });

      test('should generate multiple records', () {
        final schema = SchemaBuilder.defineSchema('User')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.fullName)
          .build();

        schemaBuilder.registerSchema(schema);
        final dataList = schemaBuilder.generateList('User', count: 5);

        expect(dataList.length, equals(5));
        for (final data in dataList) {
          expect(data['id'], isNotEmpty);
          expect(data['name'], isNotEmpty);
        }
      });

      test('should add timestamps when enabled', () {
        final schema = SchemaBuilder.defineSchema('Post')
          .field('id', FakerFieldType.uuid)
          .field('title', FakerFieldType.sentence)
          .withTimestamps()
          .build();

        schemaBuilder.registerSchema(schema);
        final data = schemaBuilder.generate('Post');

        expect(data['createdAt'], isA<DateTime>());
        expect(data['updatedAt'], isA<DateTime>());
      });

      test('should respect field constraints', () {
        final schema = SchemaBuilder.defineSchema('Product')
          .field('price', FakerFieldType.price, min: 50.0, max: 100.0)
          .field('quantity', FakerFieldType.integer, min: 10, max: 20)
          .build();

        schemaBuilder.registerSchema(schema);
        final data = schemaBuilder.generate('Product');

        final price = data['price'] as double;
        final quantity = data['quantity'] as int;

        expect(price, greaterThanOrEqualTo(50.0));
        expect(price, lessThanOrEqualTo(100.0));
        expect(quantity, greaterThanOrEqualTo(10));
        expect(quantity, lessThanOrEqualTo(20));
      });

      test('should handle default values', () {
        final schema = SchemaBuilder.defineSchema('Config')
          .field('id', FakerFieldType.uuid)
          .field('enabled', FakerFieldType.boolean, defaultValue: true)
          .field('maxRetries', FakerFieldType.integer, defaultValue: 3)
          .build();

        schemaBuilder.registerSchema(schema);
        final data = schemaBuilder.generate('Config');

        expect(data['enabled'], equals(true));
        expect(data['maxRetries'], equals(3));
      });
    });

    group('Relationships', () {
      test('should handle hasOne relationship', () {
        final profileSchema = SchemaBuilder.defineSchema('Profile')
          .field('bio', FakerFieldType.paragraph)
          .field('avatar', FakerFieldType.avatar)
          .build();

        final userSchema = SchemaBuilder.defineSchema('User')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.fullName)
          .hasOne('profile', 'Profile')
          .build();

        schemaBuilder.registerSchema(profileSchema);
        schemaBuilder.registerSchema(userSchema);
        
        final data = schemaBuilder.generate('User');

        expect(data['profile'], isA<Map<String, dynamic>>());
        expect(data['profile']['bio'], isNotEmpty);
        expect(data['profile']['avatar'], isNotEmpty);
      });

      test('should handle hasMany relationship', () {
        final postSchema = SchemaBuilder.defineSchema('Post')
          .field('id', FakerFieldType.uuid)
          .field('title', FakerFieldType.sentence)
          .field('content', FakerFieldType.paragraph)
          .build();

        final userSchema = SchemaBuilder.defineSchema('User')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.fullName)
          .hasMany('posts', 'Post')
          .build();

        schemaBuilder.registerSchema(postSchema);
        schemaBuilder.registerSchema(userSchema);
        
        final data = schemaBuilder.generate('User');

        expect(data['posts'], isA<List>());
        expect((data['posts'] as List).length, greaterThan(0));
        
        for (final post in data['posts'] as List) {
          expect(post['id'], isNotEmpty);
          expect(post['title'], isNotEmpty);
          expect(post['content'], isNotEmpty);
        }
      });

      test('should handle belongsTo relationship', () {
        final userSchema = SchemaBuilder.defineSchema('User')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.fullName)
          .build();

        final postSchema = SchemaBuilder.defineSchema('Post')
          .field('id', FakerFieldType.uuid)
          .field('title', FakerFieldType.sentence)
          .belongsTo('userId', 'User', foreignKey: 'id')
          .build();

        schemaBuilder.registerSchema(userSchema);
        schemaBuilder.registerSchema(postSchema);
        
        // Generate some users first
        schemaBuilder.generateList('User', count: 3);
        
        final post = schemaBuilder.generate('Post');

        expect(post['userId'], isNotEmpty);
      });
    });

    group('Complex Types', () {
      test('should generate JSON fields', () {
        final schema = SchemaBuilder.defineSchema('Config')
          .field('settings', FakerFieldType.json, options: {
            'theme': FakerFieldType.word,
            'maxItems': FakerFieldType.integer,
            'enabled': FakerFieldType.boolean,
          })
          .build();

        schemaBuilder.registerSchema(schema);
        final data = schemaBuilder.generate('Config');

        expect(data['settings'], isA<Map<String, dynamic>>());
        expect(data['settings']['theme'], isNotEmpty);
        expect(data['settings']['maxItems'], isA<int>());
        expect(data['settings']['enabled'], isA<bool>());
      });

      test('should generate list fields', () {
        final schema = SchemaBuilder.defineSchema('Product')
          .field('tags', FakerFieldType.list, options: {
            'count': 3,
            'itemType': FakerFieldType.word,
          })
          .build();

        schemaBuilder.registerSchema(schema);
        final data = schemaBuilder.generate('Product');

        expect(data['tags'], isA<List>());
        expect((data['tags'] as List).length, equals(3));
        for (final tag in data['tags'] as List) {
          expect(tag, isA<String>());
          expect(tag, isNotEmpty);
        }
      });

      test('should generate map fields', () {
        final schema = SchemaBuilder.defineSchema('Metadata')
          .field('attributes', FakerFieldType.map, options: {
            'color': FakerFieldType.word,
            'size': FakerFieldType.integer,
            'available': FakerFieldType.boolean,
          })
          .build();

        schemaBuilder.registerSchema(schema);
        final data = schemaBuilder.generate('Metadata');

        expect(data['attributes'], isA<Map<String, dynamic>>());
        expect(data['attributes']['color'], isNotEmpty);
        expect(data['attributes']['size'], isA<int>());
        expect(data['attributes']['available'], isA<bool>());
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible data with seed', () {
        final faker1 = SmartFaker(seed: 100);
        final builder1 = SchemaBuilder(faker1);
        
        final faker2 = SmartFaker(seed: 100);
        final builder2 = SchemaBuilder(faker2);
        
        final schema = SchemaBuilder.defineSchema('User')
          .field('id', FakerFieldType.uuid)
          .field('name', FakerFieldType.fullName)
          .field('email', FakerFieldType.email)
          .build();
        
        builder1.registerSchema(schema);
        builder2.registerSchema(schema);
        
        final data1 = builder1.generate('User');
        final data2 = builder2.generate('User');
        
        expect(data1['id'], equals(data2['id']));
        expect(data1['name'], equals(data2['name']));
        expect(data1['email'], equals(data2['email']));
      });
    });
  });
}