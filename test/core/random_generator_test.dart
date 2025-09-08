import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('RandomGenerator', () {
    late RandomGenerator random;

    setUp(() {
      random = RandomGenerator();
    });

    group('integer generation', () {
      test('should generate integer within range', () {
        for (int i = 0; i < 100; i++) {
          final value = random.integer(min: 10, max: 20);
          expect(value, greaterThanOrEqualTo(10));
          expect(value, lessThanOrEqualTo(20));
        }
      });

      test('should handle min == max', () {
        final value = random.integer(min: 5, max: 5);
        expect(value, equals(5));
      });
    });

    group('decimal generation', () {
      test('should generate decimal within range', () {
        for (int i = 0; i < 100; i++) {
          final value = random.decimal(min: 1.5, max: 2.5);
          expect(value, greaterThanOrEqualTo(1.5));
          expect(value, lessThanOrEqualTo(2.5));
        }
      });
    });

    group('boolean generation', () {
      test('should generate boolean with default probability', () {
        final results = <bool>[];
        for (int i = 0; i < 1000; i++) {
          results.add(random.boolean());
        }
        
        final trueCount = results.where((b) => b).length;
        // Should be roughly 50% with some tolerance
        expect(trueCount, greaterThan(400));
        expect(trueCount, lessThan(600));
      });

      test('should respect custom probability', () {
        final results = <bool>[];
        for (int i = 0; i < 1000; i++) {
          results.add(random.boolean(probability: 0.8));
        }
        
        final trueCount = results.where((b) => b).length;
        // Should be roughly 80% with some tolerance
        expect(trueCount, greaterThan(700));
        expect(trueCount, lessThan(900));
      });
    });

    group('element selection', () {
      test('should pick random element from list', () {
        final list = ['a', 'b', 'c', 'd', 'e'];
        final picked = <String>{};
        
        for (int i = 0; i < 50; i++) {
          picked.add(random.element(list));
        }
        
        // Should pick various elements
        expect(picked.length, greaterThan(1));
        expect(picked.every((e) => list.contains(e)), isTrue);
      });

      test('should throw on empty list', () {
        expect(
          () => random.element([]),
          throwsArgumentError,
        );
      });

      test('should pick multiple elements', () {
        final list = [1, 2, 3, 4, 5];
        final picked = random.elements(list, count: 3);
        
        expect(picked.length, equals(3));
        expect(picked.toSet().length, equals(3)); // All unique
        expect(picked.every((e) => list.contains(e)), isTrue);
      });

      test('should throw if count > list length', () {
        expect(
          () => random.elements([1, 2, 3], count: 5),
          throwsArgumentError,
        );
      });
    });

    group('weighted element selection', () {
      test('should pick based on weights', () {
        final weighted = {'a': 90, 'b': 10};
        final results = <String>[];
        
        for (int i = 0; i < 1000; i++) {
          results.add(random.weightedElement(weighted));
        }
        
        final aCount = results.where((r) => r == 'a').length;
        // 'a' should be picked ~90% of the time
        expect(aCount, greaterThan(800));
        expect(aCount, lessThan(950));
      });
    });

    group('string generation', () {
      test('should generate string of specified length', () {
        final str = random.string(length: 15);
        expect(str.length, equals(15));
      });

      test('should use custom character set', () {
        final str = random.string(length: 10, chars: 'ABC');
        expect(str.split('').every((c) => 'ABC'.contains(c)), isTrue);
      });
    });

    group('UUID generation', () {
      test('should generate valid UUID v4', () {
        final uuid = random.uuid();
        
        // Check UUID format
        final uuidRegex = RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        );
        expect(uuidRegex.hasMatch(uuid), isTrue);
      });

      test('should generate unique UUIDs', () {
        final uuids = <String>{};
        for (int i = 0; i < 100; i++) {
          uuids.add(random.uuid());
        }
        
        expect(uuids.length, equals(100)); // All unique
      });
    });

    group('hex color generation', () {
      test('should generate hex color with hash', () {
        final color = random.hexColor();
        expect(color, matches(RegExp(r'^#[0-9a-f]{6}$')));
      });

      test('should generate hex color without hash', () {
        final color = random.hexColor(includeHash: false);
        expect(color, matches(RegExp(r'^[0-9a-f]{6}$')));
      });
    });

    group('seeding', () {
      test('should produce reproducible results with seed', () {
        final random1 = RandomGenerator(seed: 42);
        final random2 = RandomGenerator(seed: 42);
        
        expect(random1.integer(max: 1000), equals(random2.integer(max: 1000)));
        expect(random1.decimal(), equals(random2.decimal()));
        expect(random1.boolean(), equals(random2.boolean()));
        expect(random1.uuid(), equals(random2.uuid()));
      });

      test('should change sequence when reseeded', () {
        random.seed(100);
        final value1 = random.integer(max: 1000);
        
        random.seed(200);
        final value2 = random.integer(max: 1000);
        
        expect(value1, isNot(equals(value2)));
      });

      test('should reset to non-seeded state', () {
        random.seed(42);
        expect(random.currentSeed, equals(42));
        
        random.reset();
        expect(random.currentSeed, isNull);
      });
    });
  });
}