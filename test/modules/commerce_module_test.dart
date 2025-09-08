import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('CommerceModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Product Generation', () {
      test('should generate product name', () {
        final product = faker.commerce.productName();
        expect(product, isNotEmpty);
      });

      test('should generate product category', () {
        final category = faker.commerce.category();
        expect(category, isNotEmpty);
      });

      test('should generate product department', () {
        final department = faker.commerce.department();
        expect(department, isNotEmpty);
      });

      test('should generate product material', () {
        final material = faker.commerce.productMaterial();
        expect(material, isNotEmpty);
      });

      test('should generate product adjective', () {
        final adjective = faker.commerce.productAdjective();
        expect(adjective, isNotEmpty);
      });

      test('should generate product description', () {
        final description = faker.commerce.productDescription();
        expect(description, isNotEmpty);
        expect(description.length, greaterThan(20));
      });
    });

    group('Price Generation', () {
      test('should generate price', () {
        final price = faker.commerce.price();
        expect(price, greaterThan(0));
        expect(price, lessThanOrEqualTo(1000));
      });

      test('should generate price with custom range', () {
        final price = faker.commerce.price(min: 50, max: 200);
        expect(price, greaterThanOrEqualTo(50));
        expect(price, lessThanOrEqualTo(200));
      });

      test('should generate price string with currency', () {
        final priceStr = faker.commerce.priceString();
        expect(priceStr, matches(RegExp(r'^\$\d+\.\d{2}$')));
      });

      test('should generate discount percentage', () {
        final discount = faker.commerce.discountPercentage();
        expect(discount, greaterThanOrEqualTo(5));
        expect(discount, lessThanOrEqualTo(90));
      });
    });

    group('SKU and Barcode', () {
      test('should generate SKU', () {
        final sku = faker.commerce.sku();
        expect(sku, matches(RegExp(r'^[A-Z]{3}-\d{6}$')));
      });

      test('should generate barcode (EAN-13)', () {
        final barcode = faker.commerce.barcode();
        expect(barcode, matches(RegExp(r'^\d{13}$')));

        // Validate EAN-13 checksum
        int sum = 0;
        for (int i = 0; i < 12; i++) {
          int digit = int.parse(barcode[i]);
          sum += (i % 2 == 0) ? digit : digit * 3;
        }
        int checkDigit = (10 - (sum % 10)) % 10;
        expect(int.parse(barcode[12]), equals(checkDigit));
      });

      test('should generate ISBN', () {
        final isbn = faker.commerce.isbn();
        expect(isbn, matches(RegExp(r'^978-\d-\d{5}-\d{3}-\d$')));
      });
    });

    group('Color Generation', () {
      test('should generate color name', () {
        final color = faker.commerce.color();
        expect(color, isNotEmpty);
      });

      test('should generate hex color', () {
        final hex = faker.commerce.hexColor();
        expect(hex, matches(RegExp(r'^#[0-9A-F]{6}$', caseSensitive: false)));
      });

      test('should generate RGB color', () {
        final rgb = faker.commerce.rgbColor();
        expect(rgb, matches(RegExp(r'^rgb\(\d{1,3}, \d{1,3}, \d{1,3}\)$')));

        // Extract and validate RGB values
        final values = RegExp(r'\d+')
            .allMatches(rgb)
            .map((m) => int.parse(m[0]!))
            .toList();
        expect(values.length, equals(3));
        for (var value in values) {
          expect(value, greaterThanOrEqualTo(0));
          expect(value, lessThanOrEqualTo(255));
        }
      });
    });

    group('Store and Brand', () {
      test('should generate store name', () {
        final store = faker.commerce.storeName();
        expect(store, isNotEmpty);
      });

      test('should generate brand name', () {
        final brand = faker.commerce.brand();
        expect(brand, isNotEmpty);
      });

      test('should generate company type', () {
        final type = faker.commerce.companyType();
        expect(type, isNotEmpty);
        expect(['Inc.', 'LLC', 'Corp.', 'Ltd.', 'Group'], contains(type));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English commerce data', () {
        final faker = SmartFaker(locale: 'en_US');
        final product = faker.commerce.productName();
        final price = faker.commerce.priceString();

        expect(product, isNotEmpty);
        expect(price, startsWith('\$'));
      });

      test('should generate Traditional Chinese commerce data', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final product = faker.commerce.productName();
        final price = faker.commerce.priceString();

        expect(product, isNotEmpty);
        expect(price, startsWith('NT\$'));
      });

      test('should generate Japanese commerce data', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final product = faker.commerce.productName();
        final price = faker.commerce.priceString();

        expect(product, isNotEmpty);
        expect(price, startsWith('¥'));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible commerce data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.commerce.productName(),
            equals(faker2.commerce.productName()));
        expect(faker1.commerce.price(), equals(faker2.commerce.price()));
        expect(faker1.commerce.sku(), equals(faker2.commerce.sku()));
        expect(faker1.commerce.color(), equals(faker2.commerce.color()));
      });
    });
  });
}
