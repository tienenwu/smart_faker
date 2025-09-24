import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('DateTimeModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Past and Future Dates', () {
      test('should generate past date', () {
        final date = faker.dateTime.past();
        expect(date.isBefore(DateTime.now()), isTrue);
      });

      test('should generate past date with years parameter', () {
        final now = DateTime.now();
        final date = faker.dateTime.past(years: 2);
        final twoYearsAgo = now.subtract(const Duration(days: 730));

        expect(date.isBefore(now), isTrue);
        expect(date.isAfter(twoYearsAgo), isTrue);
      });

      test('should generate future date', () {
        final date = faker.dateTime.future();
        expect(date.isAfter(DateTime.now()), isTrue);
      });

      test('should generate future date with years parameter', () {
        final now = DateTime.now();
        final date = faker.dateTime.future(years: 2);
        final twoYearsLater = now.add(const Duration(days: 730));

        expect(date.isAfter(now), isTrue);
        expect(date.isBefore(twoYearsLater), isTrue);
      });
    });

    group('Between Dates', () {
      test('should generate date between two dates', () {
        final start = DateTime(2020, 1, 1);
        final end = DateTime(2022, 12, 31);
        final date = faker.dateTime.between(from: start, to: end);

        expect(date.isAfter(start) || date.isAtSameMomentAs(start), isTrue);
        expect(date.isBefore(end) || date.isAtSameMomentAs(end), isTrue);
      });

      test('should handle same date for from and to', () {
        final sameDate = DateTime(2021, 6, 15);
        final date = faker.dateTime.between(from: sameDate, to: sameDate);

        expect(date, equals(sameDate));
      });
    });

    group('Recent and Soon', () {
      test('should generate recent date', () {
        final now = DateTime.now();
        final date = faker.dateTime.recent();
        expect(date.isBefore(now) || date.isAtSameMomentAs(now), isTrue);
        expect(
          now.difference(date) <= const Duration(days: 8),
          isTrue,
          reason:
              'diff: \${now.difference(date)} date: \${date.toIso8601String()}',
        );
      });

      test('should generate recent date with custom days', () {
        final now = DateTime.now();
        final date = faker.dateTime.recent(days: 30);
        expect(date.isBefore(now) || date.isAtSameMomentAs(now), isTrue);
        expect(
          now.difference(date) <= const Duration(days: 31),
          isTrue,
          reason:
              'diff: \${now.difference(date)} date: \${date.toIso8601String()}',
        );
      });

      test('should generate soon date', () {
        final now = DateTime.now();
        final date = faker.dateTime.soon();
        final sevenDaysLater = now.add(const Duration(days: 7));

        expect(date.isAfter(now) || date.isAtSameMomentAs(now), isTrue);
        expect(date.isBefore(sevenDaysLater), isTrue);
      });

      test('should generate soon date with custom days', () {
        final now = DateTime.now();
        final date = faker.dateTime.soon(days: 30);
        final thirtyDaysLater = now.add(const Duration(days: 30));

        expect(date.isAfter(now) || date.isAtSameMomentAs(now), isTrue);
        expect(date.isBefore(thirtyDaysLater), isTrue);
      });
    });

    group('Weekdays and Months', () {
      test('should generate weekday name', () {
        final weekday = faker.dateTime.weekday();
        expect(weekday, isNotEmpty);
        expect([
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ], contains(weekday));
      });

      test('should generate weekday abbreviation', () {
        final abbr = faker.dateTime.weekdayAbbr();
        expect(abbr, isNotEmpty);
        expect(
            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], contains(abbr));
      });

      test('should generate month name', () {
        final month = faker.dateTime.month();
        expect(month, isNotEmpty);
        expect([
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ], contains(month));
      });

      test('should generate month abbreviation', () {
        final abbr = faker.dateTime.monthAbbr();
        expect(abbr, isNotEmpty);
        expect([
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ], contains(abbr));
      });
    });

    group('Time Components', () {
      test('should generate hour', () {
        final hour = faker.dateTime.hour();
        expect(hour, greaterThanOrEqualTo(0));
        expect(hour, lessThanOrEqualTo(23));
      });

      test('should generate minute', () {
        final minute = faker.dateTime.minute();
        expect(minute, greaterThanOrEqualTo(0));
        expect(minute, lessThanOrEqualTo(59));
      });

      test('should generate second', () {
        final second = faker.dateTime.second();
        expect(second, greaterThanOrEqualTo(0));
        expect(second, lessThanOrEqualTo(59));
      });

      test('should generate time string', () {
        final time = faker.dateTime.timeString();
        expect(time, matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
      });
    });

    group('Timestamps', () {
      test('should generate unix timestamp', () {
        final timestamp = faker.dateTime.unixTimestamp();
        expect(timestamp, isPositive);

        // Should be between 1970 and reasonable future
        final minTimestamp = 0;
        final maxTimestamp = DateTime(2100).millisecondsSinceEpoch ~/ 1000;
        expect(timestamp, greaterThanOrEqualTo(minTimestamp));
        expect(timestamp, lessThanOrEqualTo(maxTimestamp));
      });

      test('should generate ISO 8601 string', () {
        final iso = faker.dateTime.iso8601();
        expect(iso,
            matches(RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$')));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English weekday and month', () {
        final faker = SmartFaker(locale: 'en_US');
        final weekday = faker.dateTime.weekday();
        final month = faker.dateTime.month();

        expect(weekday, isNotEmpty);
        expect(month, isNotEmpty);
      });

      test('should generate Traditional Chinese weekday and month', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final weekday = faker.dateTime.weekday();
        final month = faker.dateTime.month();

        expect(weekday, contains('星期'));
        expect(month, contains('月'));
      });

      test('should generate Japanese weekday and month', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final weekday = faker.dateTime.weekday();
        final month = faker.dateTime.month();

        expect(weekday, contains('曜日'));
        expect(month, contains('月'));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible dates with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        // For dates, compare days since epoch instead of exact milliseconds
        final past1 = faker1.dateTime.past();
        final past2 = faker2.dateTime.past();
        expect(past1.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000),
            equals(past2.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000)));

        final future1 = faker1.dateTime.future();
        final future2 = faker2.dateTime.future();
        expect(future1.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000),
            equals(future2.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000)));

        expect(faker1.dateTime.weekday(), equals(faker2.dateTime.weekday()));
        expect(faker1.dateTime.month(), equals(faker2.dateTime.month()));
      });
    });
  });
}
