import 'package:test/test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  late SmartFaker faker;

  setUp(() {
    faker = SmartFaker(seed: 12345);
  });

  group('PatternModule', () {
    group('Basic Pattern Generation', () {
      test('generates digits with \\d', () {
        final result = faker.pattern.fromRegex(r'\d\d\d');
        expect(result, matches(RegExp(r'^\d{3}$')));
      });

      test('generates word characters with \\w', () {
        final result = faker.pattern.fromRegex(r'\w\w\w\w');
        expect(result, matches(RegExp(r'^\w{4}$')));
      });

      test('generates from character class [a-z]', () {
        final result = faker.pattern.fromRegex(r'[a-z]{5}');
        expect(result, matches(RegExp(r'^[a-z]{5}$')));
      });

      test('generates from character class [A-Z]', () {
        final result = faker.pattern.fromRegex(r'[A-Z]{3}');
        expect(result, matches(RegExp(r'^[A-Z]{3}$')));
      });

      test('generates from character class [0-9]', () {
        final result = faker.pattern.fromRegex(r'[0-9]{4}');
        expect(result, matches(RegExp(r'^[0-9]{4}$')));
      });

      test('handles mixed character classes', () {
        final result = faker.pattern.fromRegex(r'[A-Z][0-9][a-z]');
        expect(result, matches(RegExp(r'^[A-Z][0-9][a-z]$')));
      });
    });

    group('Quantifiers', () {
      test('handles {n} quantifier', () {
        final result = faker.pattern.fromRegex(r'\d{5}');
        expect(result, matches(RegExp(r'^\d{5}$')));
      });

      test('handles {n,m} quantifier', () {
        final result = faker.pattern.fromRegex(r'[A-Z]{2,4}');
        expect(result, matches(RegExp(r'^[A-Z]{2,4}$')));
        expect(result.length, greaterThanOrEqualTo(2));
        expect(result.length, lessThanOrEqualTo(4));
      });

      test('handles + quantifier', () {
        final result = faker.pattern.fromRegex(r'[a-z]+');
        expect(result, matches(RegExp(r'^[a-z]+$')));
        expect(result.length, greaterThanOrEqualTo(1));
      });

      test('handles * quantifier', () {
        final result = faker.pattern.fromRegex(r'[0-9]*X');
        expect(result, matches(RegExp(r'^[0-9]*X$')));
        expect(result, endsWith('X'));
      });

      test('handles ? quantifier', () {
        final result = faker.pattern.fromRegex(r'[A-Z]?123');
        expect(result, matches(RegExp(r'^[A-Z]?123$')));
        expect(result, endsWith('123'));
      });
    });

    group('Complex Patterns', () {
      test('generates with anchors', () {
        final result = faker.pattern.fromRegex(r'^[A-Z]{3}$');
        expect(result, matches(RegExp(r'^[A-Z]{3}$')));
      });

      test('handles groups', () {
        final result = faker.pattern.fromRegex(r'(ABC|DEF)-\d{3}');
        expect(result, matches(RegExp(r'^(ABC|DEF)-\d{3}$')));
      });

      test('handles alternation', () {
        final results = <String>{};
        for (int i = 0; i < 20; i++) {
          results.add(faker.pattern.fromRegex(r'(RED|BLUE|GREEN)'));
        }
        // Should generate different values
        expect(results.length, greaterThan(1));
        expect(results, everyElement(matches(RegExp(r'^(RED|BLUE|GREEN)$'))));
      });

      test('handles escape sequences', () {
        final result = faker.pattern.fromRegex(r'ID\.\d{4}');
        expect(result, matches(RegExp(r'^ID\.\d{4}$')));
      });

      test('handles mixed patterns', () {
        final result = faker.pattern.fromRegex(r'[A-Z]{2}-\d{4}-[a-z]{3}');
        expect(result, matches(RegExp(r'^[A-Z]{2}-\d{4}-[a-z]{3}$')));
      });
    });

    group('Preset Patterns', () {
      test('generates Taiwan phone number', () {
        final phone = faker.pattern.taiwanPhone();
        expect(phone, matches(RegExp(r'^09\d{2}-\d{3}-\d{3}$')));
      });

      test('generates Taiwan ID format', () {
        final id = faker.pattern.taiwanIdFormat();
        expect(id, matches(RegExp(r'^[A-Z][12]\d{8}$')));
      });

      test('generates US phone number', () {
        final phone = faker.pattern.usPhone();
        expect(phone, matches(RegExp(r'^\(\d{3}\) \d{3}-\d{4}$')));
      });

      test('generates Japan phone number', () {
        final phone = faker.pattern.japanPhone();
        expect(phone, matches(RegExp(r'^0[789]0-\d{4}-\d{4}$')));
      });

      test('generates email format', () {
        final email = faker.pattern.emailFormat();
        expect(email, matches(RegExp(r'^[a-z]{3,10}\.[a-z]{3,10}@[a-z]{5,10}\.com$')));
      });

      test('generates Visa card format', () {
        final card = faker.pattern.visaFormat();
        expect(card, matches(RegExp(r'^4\d{3} \d{4} \d{4} \d{4}$')));
      });

      test('generates Mastercard format', () {
        final card = faker.pattern.mastercardFormat();
        expect(card, matches(RegExp(r'^5[1-5]\d{2} \d{4} \d{4} \d{4}$')));
      });

      test('generates order ID format', () {
        final orderId = faker.pattern.orderIdFormat();
        expect(orderId, matches(RegExp(r'^ORD-\d{10}$')));
      });

      test('generates custom order ID format', () {
        final orderId = faker.pattern.orderIdFormat(prefix: 'INV');
        expect(orderId, matches(RegExp(r'^INV-\d{10}$')));
      });

      test('generates SKU format', () {
        final sku = faker.pattern.skuFormat();
        expect(sku, matches(RegExp(r'^[A-Z]{3}-\d{6}$')));
      });

      test('generates tracking number format', () {
        final tracking = faker.pattern.trackingNumberFormat();
        expect(tracking, matches(RegExp(r'^[A-Z]{2}\d{10}[A-Z]{2}$')));
      });

      test('generates invoice format', () {
        final invoice = faker.pattern.invoiceFormat();
        expect(invoice, matches(RegExp(r'^INV-2024\d{6}$')));
      });

      test('generates custom year invoice format', () {
        final invoice = faker.pattern.invoiceFormat(year: 2025);
        expect(invoice, matches(RegExp(r'^INV-2025\d{6}$')));
      });

      test('generates license plate format', () {
        final plate = faker.pattern.licensePlateFormat();
        expect(plate, matches(RegExp(r'^[A-Z]{3}-\d{4}$')));
      });

      test('generates IPv4 format', () {
        final ip = faker.pattern.ipv4Format();
        final parts = ip.split('.');
        expect(parts.length, equals(4));
        for (final part in parts) {
          final num = int.parse(part);
          expect(num, greaterThanOrEqualTo(1));
          expect(num, lessThanOrEqualTo(254));
        }
      });

      test('generates MAC address format', () {
        final mac = faker.pattern.macAddressFormat();
        expect(mac, matches(RegExp(r'^[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}$')));
      });

      test('generates hex color format', () {
        final color = faker.pattern.hexColorFormat();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('generates UUID format', () {
        final uuid = faker.pattern.uuidFormat();
        expect(uuid, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
      });
    });

    group('Real-world Patterns', () {
      test('generates various Taiwan phone formats', () {
        final patterns = [
          r'^09\d{8}$',           // Mobile without dashes
          r'^09\d{2}-\d{6}$',     // Mobile with one dash
          r'^09\d{2}-\d{3}-\d{3}$', // Mobile with two dashes
          r'^02-\d{4}-\d{4}$',    // Taipei landline
          r'^07-\d{3}-\d{4}$',    // Kaohsiung landline
        ];

        for (final pattern in patterns) {
          final result = faker.pattern.fromRegex(pattern);
          expect(result, matches(RegExp(pattern)));
        }
      });

      test('generates various credit card formats', () {
        // Visa
        final visa = faker.pattern.fromRegex(r'^4\d{15}$');
        expect(visa, matches(RegExp(r'^4\d{15}$')));
        expect(visa.length, equals(16));

        // Mastercard
        final mastercard = faker.pattern.fromRegex(r'^5[1-5]\d{14}$');
        expect(mastercard, matches(RegExp(r'^5[1-5]\d{14}$')));

        // American Express
        final amex = faker.pattern.fromRegex(r'^3[47]\d{13}$');
        expect(amex, matches(RegExp(r'^3[47]\d{13}$')));
        expect(amex.length, equals(15));
      });

      test('generates various order/invoice formats', () {
        final patterns = {
          r'^ORD-\d{10}$': 'ORD-',
          r'^INV-2024\d{6}$': 'INV-2024',
          r'^PO#\d{8}$': 'PO#',
          r'^[A-Z]{2}\d{8}$': RegExp(r'^[A-Z]{2}'),
        };

        patterns.forEach((pattern, expectedStart) {
          final result = faker.pattern.fromRegex(pattern);
          expect(result, matches(RegExp(pattern)));
          if (expectedStart is String) {
            expect(result, startsWith(expectedStart));
          } else if (expectedStart is RegExp) {
            expect(result, matches(expectedStart));
          }
        });
      });

      test('generates email variations', () {
        final patterns = [
          r'^[a-z]+@[a-z]+\.com$',
          r'^[a-z]+\.[a-z]+@[a-z]+\.com$',
          r'^[a-z]+_[a-z]+@[a-z]+\.org$',
          r'^[a-z]+\d{2}@[a-z]+\.net$',
        ];

        for (final pattern in patterns) {
          final email = faker.pattern.fromRegex(pattern);
          expect(email, matches(RegExp(pattern)));
          expect(email, contains('@'));
        }
      });
    });

    group('Error Handling', () {
      test('throws on invalid escape sequence', () {
        expect(
          () => faker.pattern.fromRegex(r'\'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws on unclosed character class', () {
        expect(
          () => faker.pattern.fromRegex(r'[a-z'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws on unclosed group', () {
        expect(
          () => faker.pattern.fromRegex(r'(abc'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws on unclosed quantifier', () {
        expect(
          () => faker.pattern.fromRegex(r'\d{5'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Performance', () {
      test('generates patterns quickly', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          faker.pattern.fromRegex(r'^[A-Z]{3}-\d{6}$');
        }
        
        stopwatch.stop();
        // Should complete 1000 generations in under 1 second
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('handles complex patterns efficiently', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 100; i++) {
          faker.pattern.fromRegex(
            r'^([A-Z]{2,4}|[0-9]{3,5})-\d{4}-[a-z]+@[a-z]+\.(com|org|net)$'
          );
        }
        
        stopwatch.stop();
        // Should complete 100 complex generations in under 1 second
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });
  });
}