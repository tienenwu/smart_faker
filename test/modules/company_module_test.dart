import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('CompanyModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Company Names', () {
      test('should generate company name', () {
        final name = faker.company.name();
        expect(name, isNotEmpty);
      });

      test('should generate company suffix', () {
        final suffix = faker.company.suffix();
        expect(suffix, isNotEmpty);
        expect(
            ['Inc.', 'LLC', 'Corp.', 'Ltd.', 'Group', 'Holdings', 'Partners'],
            contains(suffix));
      });

      test('should generate company with suffix', () {
        final nameWithSuffix = faker.company.nameWithSuffix();
        expect(nameWithSuffix, isNotEmpty);
        expect(nameWithSuffix, contains(' '));
      });
    });

    group('Company Details', () {
      test('should generate catchphrase', () {
        final catchphrase = faker.company.catchphrase();
        expect(catchphrase, isNotEmpty);
        expect(catchphrase.length, greaterThan(10));
      });

      test('should generate buzzword', () {
        final buzzword = faker.company.buzzword();
        expect(buzzword, isNotEmpty);
      });

      test('should generate BS (business speak)', () {
        final bs = faker.company.bs();
        expect(bs, isNotEmpty);
      });

      test('should generate industry', () {
        final industry = faker.company.industry();
        expect(industry, isNotEmpty);
      });

      test('should generate department', () {
        final department = faker.company.department();
        expect(department, isNotEmpty);
      });
    });

    group('Company Identifiers', () {
      test('should generate EIN (Employer Identification Number)', () {
        final ein = faker.company.ein();
        expect(ein, matches(RegExp(r'^\d{2}-\d{7}$')));
      });

      test('should generate DUNS number', () {
        final duns = faker.company.dunsNumber();
        expect(duns, matches(RegExp(r'^\d{2}-\d{3}-\d{4}$')));
      });

      test('should generate SIC code', () {
        final sic = faker.company.sicCode();
        expect(sic, matches(RegExp(r'^\d{4}$')));
      });

      test('should generate NAICS code', () {
        final naics = faker.company.naicsCode();
        expect(naics, matches(RegExp(r'^\d{6}$')));
      });
    });

    group('Company Size and Type', () {
      test('should generate company size', () {
        final size = faker.company.companySize();
        expect(['Startup', 'Small', 'Medium', 'Large', 'Enterprise'],
            contains(size));
      });

      test('should generate employee count', () {
        final count = faker.company.employeeCount();
        expect(count, greaterThan(0));
        expect(count, lessThanOrEqualTo(100000));
      });

      test('should generate employee count range', () {
        final range = faker.company.employeeCountRange();
        expect(range, matches(RegExp(r'^\d+-\d+$|^\d+\+$')));
      });

      test('should generate revenue range', () {
        final revenue = faker.company.revenueRange();
        expect(revenue, isNotEmpty);
        expect(revenue, contains('\$'));
      });
    });

    group('Company Mission and Values', () {
      test('should generate mission statement', () {
        final mission = faker.company.missionStatement();
        expect(mission, isNotEmpty);
        expect(mission.length, greaterThan(20));
      });

      test('should generate company values', () {
        final values = faker.company.values();
        expect(values, isA<List<String>>());
        expect(values.length, greaterThanOrEqualTo(3));
        expect(values.length, lessThanOrEqualTo(5));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English company data', () {
        final faker = SmartFaker(locale: 'en_US');
        final name = faker.company.name();
        final suffix = faker.company.suffix();

        expect(name, isNotEmpty);
        expect(['Inc.', 'LLC', 'Corp.', 'Ltd.', 'Holdings'], contains(suffix));
      });

      test('should generate Traditional Chinese company data', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final name = faker.company.name();
        final suffix = faker.company.suffix();

        expect(name, isNotEmpty);
        expect(['有限公司', '股份有限公司', '企業', '集團'], contains(suffix));
      });

      test('should generate Japanese company data', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final name = faker.company.name();
        final suffix = faker.company.suffix();

        expect(name, isNotEmpty);
        expect(['株式会社', '有限会社', 'グループ', 'ホールディングス'], contains(suffix));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible company data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.company.name(), equals(faker2.company.name()));
        expect(
            faker1.company.catchphrase(), equals(faker2.company.catchphrase()));
        expect(faker1.company.ein(), equals(faker2.company.ein()));
        expect(faker1.company.employeeCount(),
            equals(faker2.company.employeeCount()));
      });
    });
  });
}
