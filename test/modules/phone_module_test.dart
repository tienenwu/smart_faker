import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('PhoneModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Phone Numbers', () {
      test('should generate phone number', () {
        final phone = faker.phone.number();
        expect(phone, isNotEmpty);
        expect(phone, contains(RegExp(r'[\d\s\-\(\)\+]')));
      });

      test('should generate mobile number', () {
        final mobile = faker.phone.mobile();
        expect(mobile, isNotEmpty);
        expect(mobile, contains(RegExp(r'[\d\s\-\(\)\+]')));
      });

      test('should generate international number', () {
        final intl = faker.phone.international();
        expect(intl, startsWith('+'));
        expect(intl, contains(RegExp(r'[\d\s\-]')));
      });

      test('should generate toll-free number', () {
        final tollFree = faker.phone.tollFree();
        expect(tollFree, isNotEmpty);
        expect(tollFree, contains(RegExp(r'[\d\s\-]')));
      });

      test('should generate formatted number', () {
        final formatted = faker.phone.formatted();
        expect(formatted, matches(RegExp(r'^\(\d{3}\) \d{3}-\d{4}$')));
      });

      test('should generate extension', () {
        final ext = faker.phone.extension();
        expect(ext, matches(RegExp(r'^\d{1,4}$')));
      });
    });

    group('Device Info', () {
      test('should generate IMEI', () {
        final imei = faker.phone.imei();
        expect(imei, matches(RegExp(r'^\d{15}$')));
      });

      test('should generate IMSI', () {
        final imsi = faker.phone.imsi();
        expect(imsi, matches(RegExp(r'^\d{15}$')));
      });

      test('should generate phone model', () {
        final model = faker.phone.model();
        expect(model, isNotEmpty);
      });

      test('should generate phone manufacturer', () {
        final manufacturer = faker.phone.manufacturer();
        expect([
          'Apple',
          'Samsung',
          'Google',
          'Xiaomi',
          'OnePlus',
          'Huawei',
          'Sony',
          'LG',
          'Motorola',
          'Nokia',
          'OPPO',
          'Vivo',
          'Realme',
          'ASUS',
          'HTC'
        ], contains(manufacturer));
      });

      test('should generate OS version', () {
        final os = faker.phone.osVersion();
        expect(os, isNotEmpty);
      });
    });

    group('Country Codes', () {
      test('should generate country code', () {
        final code = faker.phone.countryCode();
        expect(code, startsWith('+'));
        expect(code, matches(RegExp(r'^\+\d{1,3}$')));
      });

      test('should generate area code', () {
        final area = faker.phone.areaCode();
        expect(area, matches(RegExp(r'^\d{3}$')));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English phone format', () {
        final faker = SmartFaker(locale: 'en_US');
        final phone = faker.phone.number();
        expect(phone, isNotEmpty);
      });

      test('should generate Traditional Chinese phone format', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final phone = faker.phone.number();
        expect(phone, isNotEmpty);
      });

      test('should generate Japanese phone format', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final phone = faker.phone.number();
        expect(phone, isNotEmpty);
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible phone data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.phone.number(), equals(faker2.phone.number()));
        expect(faker1.phone.imei(), equals(faker2.phone.imei()));
        expect(faker1.phone.model(), equals(faker2.phone.model()));
      });
    });
  });
}
