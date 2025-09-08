import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('SmartFaker Core', () {
    test('should create instance without parameters', () {
      final faker = SmartFaker();
      expect(faker, isNotNull);
      expect(faker.locale, equals('en_US'));
    });

    test('should create instance with custom locale', () {
      final faker = SmartFaker(locale: 'zh_TW');
      expect(faker.locale, equals('zh_TW'));
    });

    test('should create instance with seed for reproducibility', () {
      final faker1 = SmartFaker(seed: 12345);
      final faker2 = SmartFaker(seed: 12345);
      
      // Both instances should generate the same sequence
      final uuid1 = faker1.random.uuid();
      final uuid2 = faker2.random.uuid();
      
      expect(uuid1, equals(uuid2));
    });

    test('should use singleton instance', () {
      final instance1 = SmartFaker.instance;
      final instance2 = SmartFaker.instance;
      
      expect(identical(instance1, instance2), isTrue);
    });

    test('should change locale', () {
      final faker = SmartFaker();
      expect(faker.locale, equals('en_US'));
      
      faker.setLocale('ja_JP');
      expect(faker.locale, equals('ja_JP'));
    });

    test('should throw error for unsupported locale', () {
      final faker = SmartFaker();
      
      expect(
        () => faker.setLocale('invalid_LOCALE'),
        throwsArgumentError,
      );
    });

    test('should set seed for reproducible generation', () {
      final faker = SmartFaker();
      
      faker.seed(42);
      final value1 = faker.random.integer(max: 1000);
      
      faker.seed(42);
      final value2 = faker.random.integer(max: 1000);
      
      expect(value1, equals(value2));
    });

    test('should have access to configuration', () {
      final config = FakerConfig(
        defaultLocale: 'ja_JP',
        strictMode: true,
      );
      final faker = SmartFaker(config: config);
      
      expect(faker.config.defaultLocale, equals('ja_JP'));
      expect(faker.config.strictMode, isTrue);
    });
  });
}