import 'package:test/test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('SchemaBuilder Validation Tests', () {
    late SmartFaker faker;
    late SchemaBuilder builder;

    setUp(() {
      faker = SmartFaker(seed: 12345);
      builder = SchemaBuilder(faker);
    });

    test('Field with regex pattern generates matching values', () {
      final schema = SchemaDefinitionBuilder('TestSchema')
          .field(
            'taiwanId',
            FakerFieldType.custom,
            pattern: r'^[A-Z][12]\d{8}$',
          )
          .field(
            'phone',
            FakerFieldType.custom,
            pattern: r'^09\d{8}$',
          )
          .build();

      builder.registerSchema(schema);
      final result = builder.generate('TestSchema');

      expect(result['taiwanId'], matches(RegExp(r'^[A-Z][12]\d{8}$')));
      expect(result['phone'], matches(RegExp(r'^09\d{8}$')));
    });

    test('Field validator ensures generated values are valid', () {
      final schema = SchemaDefinitionBuilder('ValidatedSchema')
          .field(
            'email',
            FakerFieldType.email,
            validator: FieldValidators.email,
          )
          .field(
            'age',
            FakerFieldType.integer,
            min: 18,
            max: 65,
            validator: FieldValidators.range(min: 18, max: 65),
          )
          .build();

      builder.registerSchema(schema);
      final result = builder.generate('ValidatedSchema');

      expect(FieldValidators.email(result['email']), isTrue);
      expect(result['age'], greaterThanOrEqualTo(18));
      expect(result['age'], lessThanOrEqualTo(65));
    });

    test('Combined validators work correctly', () {
      final schema = SchemaDefinitionBuilder('CombinedValidation')
          .field(
            'creditCard',
            FakerFieldType.custom,
            pattern: r'^4\d{15}$', // Visa pattern
            validator: FieldValidators.combine([
              FieldValidators.creditCard,
              FieldValidators.regex(r'^4'), // Must start with 4
              FieldValidators.length(exact: 16),
            ]),
          )
          .build();

      builder.registerSchema(schema);
      final result = builder.generate('CombinedValidation');
      final card = result['creditCard'] as String;

      expect(card, hasLength(16));
      expect(card, startsWith('4'));
      expect(card, matches(RegExp(r'^\d+$')));
    });

    test('InList validator ensures value is from allowed list', () {
      final schema = SchemaDefinitionBuilder('ListValidation')
          .field(
            'status',
            FakerFieldType.custom,
            validator:
                FieldValidators.inList(['pending', 'active', 'inactive']),
            defaultValue: 'pending',
          )
          .field(
            'category',
            FakerFieldType.custom,
            validator: FieldValidators.inList(['A', 'B', 'C']),
            defaultValue: 'A',
          )
          .build();

      builder.registerSchema(schema);
      final result = builder.generate('ListValidation');

      expect(['pending', 'active', 'inactive'], contains(result['status']));
      expect(['A', 'B', 'C'], contains(result['category']));
    });

    test('Pattern and validator work together', () {
      final schema = SchemaDefinitionBuilder('PatternAndValidation')
          .field(
            'sku',
            FakerFieldType.custom,
            pattern: r'^SKU-[A-Z]{3}-\d{4}$',
            validator: FieldValidators.fromPattern(r'^SKU-[A-Z]{3}-\d{4}$'),
          )
          .build();

      builder.registerSchema(schema);
      final result = builder.generate('PatternAndValidation');

      expect(result['sku'], matches(RegExp(r'^SKU-[A-Z]{3}-\d{4}$')));
    });

    test('Validation error message is used when validation fails', () {
      // Create a validator that always fails
      bool alwaysFails(dynamic value) => false;

      final schema = SchemaDefinitionBuilder('FailingValidation')
          .field(
            'impossible',
            FakerFieldType.custom,
            pattern: r'^test$',
            validator: alwaysFails,
            validationMessage: 'This field always fails validation',
          )
          .build();

      builder.registerSchema(schema);

      expect(
        () => builder.generate('FailingValidation'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('This field always fails validation'),
          ),
        ),
      );
    });

    test('Multiple fields with different validators', () {
      final schema = SchemaDefinitionBuilder('ComplexValidation')
          .field(
            'uuid',
            FakerFieldType.uuid,
            validator: FieldValidators.uuid,
          )
          .field(
            'ipAddress',
            FakerFieldType.custom,
            pattern: r'^192\.168\.\d{1,3}\.\d{1,3}$',
            validator: FieldValidators.ipv4,
          )
          .field(
            'macAddress',
            FakerFieldType.custom,
            pattern: FieldPatterns.macAddress,
            validator: FieldValidators.macAddress,
          )
          .field(
            'hexColor',
            FakerFieldType.custom,
            pattern: r'^#[A-Fa-f0-9]{6}$',
            validator: FieldValidators.hexColor,
          )
          .build();

      builder.registerSchema(schema);
      final result = builder.generate('ComplexValidation');

      expect(FieldValidators.uuid(result['uuid']), isTrue);
      expect(FieldValidators.ipv4(result['ipAddress']), isTrue);
      expect(result['ipAddress'], startsWith('192.168.'));
      expect(FieldValidators.macAddress(result['macAddress']), isTrue);
      expect(FieldValidators.hexColor(result['hexColor']), isTrue);
    });

    test('Generate list with validation', () {
      final schema = SchemaDefinitionBuilder('ListGeneration')
          .field(
            'orderNumber',
            FakerFieldType.custom,
            pattern: r'^ORD-\d{6}$',
            validator: FieldValidators.fromPattern(r'^ORD-\d{6}$'),
          )
          .build();

      builder.registerSchema(schema);
      final results = builder.generateList('ListGeneration', count: 10);

      expect(results, hasLength(10));
      for (final result in results) {
        expect(result['orderNumber'], matches(RegExp(r'^ORD-\d{6}$')));
      }
    });
  });

  group('FieldValidators Tests', () {
    test('Email validator', () {
      expect(FieldValidators.email('test@example.com'), isTrue);
      expect(FieldValidators.email('user.name@domain.co.uk'), isTrue);
      expect(FieldValidators.email('invalid'), isFalse);
      expect(FieldValidators.email('missing@'), isFalse);
      expect(FieldValidators.email('@domain.com'), isFalse);
      expect(FieldValidators.email(123), isFalse);
    });

    test('Phone validator', () {
      expect(FieldValidators.phone('0912345678'), isTrue);
      expect(FieldValidators.phone('+886912345678'), isTrue);
      expect(FieldValidators.phone('(02) 1234-5678'), isTrue);
      expect(
          FieldValidators.phone('123'), isTrue); // Short numbers can be valid
      expect(FieldValidators.phone('not a phone'), isFalse);
    });

    test('URL validator', () {
      expect(FieldValidators.url('https://example.com'), isTrue);
      expect(FieldValidators.url('http://sub.domain.com/path'), isTrue);
      expect(FieldValidators.url('example.com'), isTrue);
      expect(FieldValidators.url('not a url'), isFalse);
    });

    test('Credit card validator', () {
      expect(FieldValidators.creditCard('4111111111111111'), isTrue);
      expect(FieldValidators.creditCard('5500 0000 0000 0004'), isTrue);
      expect(FieldValidators.creditCard('1234'), isFalse);
      expect(FieldValidators.creditCard('not a card'), isFalse);
    });

    test('UUID validator', () {
      expect(
        FieldValidators.uuid('550e8400-e29b-41d4-a716-446655440000'),
        isTrue,
      );
      expect(FieldValidators.uuid('not-a-uuid'), isFalse);
      expect(FieldValidators.uuid('550e8400-e29b-41d4'), isFalse);
    });

    test('Taiwan ID validator', () {
      expect(FieldValidators.taiwanId('A123456789'), isTrue);
      expect(FieldValidators.taiwanId('B234567890'), isTrue);
      expect(FieldValidators.taiwanId('123456789'), isFalse);
      expect(FieldValidators.taiwanId('AA23456789'), isFalse);
    });

    test('IPv4 validator', () {
      expect(FieldValidators.ipv4('192.168.1.1'), isTrue);
      expect(FieldValidators.ipv4('10.0.0.1'), isTrue);
      expect(FieldValidators.ipv4('255.255.255.255'), isTrue);
      expect(FieldValidators.ipv4('256.1.1.1'), isFalse);
      expect(FieldValidators.ipv4('192.168'), isFalse);
    });

    test('MAC address validator', () {
      expect(FieldValidators.macAddress('00:11:22:33:44:55'), isTrue);
      expect(FieldValidators.macAddress('00-11-22-33-44-55'), isTrue);
      expect(FieldValidators.macAddress('001122334455'), isFalse);
      expect(FieldValidators.macAddress('00:11:22'), isFalse);
    });

    test('Hex color validator', () {
      expect(FieldValidators.hexColor('#FF0000'), isTrue);
      expect(FieldValidators.hexColor('#F00'), isTrue);
      expect(FieldValidators.hexColor('#ff00aa'), isTrue);
      expect(FieldValidators.hexColor('FF0000'), isFalse);
      expect(FieldValidators.hexColor('#GG0000'), isFalse);
    });

    test('Length validator', () {
      final exactLength = FieldValidators.length(exact: 5);
      expect(exactLength('12345'), isTrue);
      expect(exactLength('1234'), isFalse);
      expect(exactLength('123456'), isFalse);

      final minMax = FieldValidators.length(min: 3, max: 10);
      expect(minMax('abc'), isTrue);
      expect(minMax('1234567890'), isTrue);
      expect(minMax('ab'), isFalse);
      expect(minMax('12345678901'), isFalse);
    });

    test('Range validator', () {
      final range = FieldValidators.range(min: 10, max: 100);
      expect(range(50), isTrue);
      expect(range(10), isTrue);
      expect(range(100), isTrue);
      expect(range(9), isFalse);
      expect(range(101), isFalse);
      expect(range('not a number'), isFalse);
    });

    test('InList validator', () {
      final inList = FieldValidators.inList(['apple', 'banana', 'orange']);
      expect(inList('apple'), isTrue);
      expect(inList('banana'), isTrue);
      expect(inList('grape'), isFalse);
      expect(inList(null), isFalse);
    });

    test('Combine validator', () {
      final combined = FieldValidators.combine([
        FieldValidators.length(min: 5),
        FieldValidators.regex(r'^[A-Z]'),
      ]);
      expect(combined('HELLO'), isTrue);
      expect(combined('HELLO WORLD'), isTrue);
      expect(combined('hello'), isFalse); // Doesn't start with uppercase
      expect(combined('HI'), isFalse); // Too short
    });
  });
}
