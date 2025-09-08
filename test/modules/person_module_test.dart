import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';
import 'package:smart_faker/src/modules/models/gender.dart';

void main() {
  group('PersonModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Name Generation', () {
      test('should generate first name', () {
        final firstName = faker.person.firstName();
        expect(firstName, isNotEmpty);
        expect(firstName, matches(RegExp(r'^[A-Z][a-z]+$')));
      });

      test('should generate last name', () {
        final lastName = faker.person.lastName();
        expect(lastName, isNotEmpty);
        expect(lastName, matches(RegExp(r'^[A-Z][a-z]+$')));
      });

      test('should generate full name', () {
        final fullName = faker.person.fullName();
        expect(fullName, isNotEmpty);
        expect(fullName, contains(' '));
        expect(fullName.split(' ').length, greaterThanOrEqualTo(2));
      });

      test('should generate gender-specific first names', () {
        final maleName = faker.person.firstName(gender: Gender.male);
        final femaleName = faker.person.firstName(gender: Gender.female);

        expect(maleName, isNotEmpty);
        expect(femaleName, isNotEmpty);
      });
    });

    group('Age Generation', () {
      test('should generate age within default range', () {
        final age = faker.person.age();
        expect(age, greaterThanOrEqualTo(18));
        expect(age, lessThanOrEqualTo(65));
      });

      test('should generate age within custom range', () {
        final age = faker.person.age(min: 25, max: 35);
        expect(age, greaterThanOrEqualTo(25));
        expect(age, lessThanOrEqualTo(35));
      });
    });

    group('Job Title Generation', () {
      test('should generate job title', () {
        final jobTitle = faker.person.jobTitle();
        expect(jobTitle, isNotEmpty);
        expect(jobTitle.split(' ').length, greaterThanOrEqualTo(1));
      });

      test('should generate job department', () {
        final department = faker.person.jobDepartment();
        expect(department, isNotEmpty);
      });

      test('should generate job descriptor', () {
        final descriptor = faker.person.jobDescriptor();
        expect(descriptor, isNotEmpty);
      });
    });

    group('Gender Generation', () {
      test('should generate gender', () {
        final gender = faker.person.gender();
        expect(gender, isA<Gender>());
        expect([Gender.male, Gender.female], contains(gender));
      });
    });

    group('Complete Person Generation', () {
      test('should generate complete person object', () {
        final person = faker.person.generatePerson();

        expect(person.firstName, isNotEmpty);
        expect(person.lastName, isNotEmpty);
        expect(person.fullName, isNotEmpty);
        expect(person.age, greaterThanOrEqualTo(18));
        expect(person.gender, isA<Gender>());
        expect(person.jobTitle, isNotEmpty);
        expect(person.email, isNotEmpty);
        expect(person.phone, isNotEmpty);
      });

      test('should generate consistent person data', () {
        final person = faker.person.generatePerson(age: 22);

        // Young person should have junior job title
        expect(
            person.jobTitle.toLowerCase(),
            anyOf(
                contains('junior'), contains('intern'), contains('assistant')));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible names with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.person.firstName(), equals(faker2.person.firstName()));
        expect(faker1.person.lastName(), equals(faker2.person.lastName()));
        expect(faker1.person.fullName(), equals(faker2.person.fullName()));
        expect(faker1.person.age(), equals(faker2.person.age()));
        expect(faker1.person.jobTitle(), equals(faker2.person.jobTitle()));
      });
    });
  });
}
