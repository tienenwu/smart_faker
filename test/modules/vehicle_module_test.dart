import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('VehicleModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Vehicle Information', () {
      test('should generate vehicle manufacturer', () {
        final manufacturer = faker.vehicle.manufacturer();
        expect(manufacturer, isNotEmpty);
      });

      test('should generate vehicle model', () {
        final model = faker.vehicle.model();
        expect(model, isNotEmpty);
      });

      test('should generate vehicle type', () {
        final type = faker.vehicle.type();
        expect([
          'Sedan',
          'SUV',
          'Truck',
          'Van',
          'Coupe',
          'Convertible',
          'Hatchback'
        ], contains(type));
      });

      test('should generate vehicle fuel type', () {
        final fuel = faker.vehicle.fuel();
        expect(['Gasoline', 'Diesel', 'Electric', 'Hybrid', 'Hydrogen'],
            contains(fuel));
      });

      test('should generate vehicle color', () {
        final color = faker.vehicle.color();
        expect(color, isNotEmpty);
      });

      test('should generate vehicle transmission', () {
        final transmission = faker.vehicle.transmission();
        expect(['Manual', 'Automatic', 'CVT', 'Semi-Automatic'],
            contains(transmission));
      });
    });

    group('Vehicle Identifiers', () {
      test('should generate VIN', () {
        final vin = faker.vehicle.vin();
        expect(vin, hasLength(17));
        expect(vin, matches(RegExp(r'^[A-HJ-NPR-Z0-9]{17}$')));
      });

      test('should generate license plate', () {
        final plate = faker.vehicle.licensePlate();
        expect(plate, isNotEmpty);
      });

      test('should generate vehicle registration', () {
        final registration = faker.vehicle.registration();
        expect(registration, matches(RegExp(r'^REG\d{8}$')));
      });
    });

    group('Vehicle Specifications', () {
      test('should generate manufacture year', () {
        final year = faker.vehicle.year();
        final currentYear = DateTime.now().year;
        expect(year, greaterThanOrEqualTo(1990));
        expect(year, lessThanOrEqualTo(currentYear + 1));
      });

      test('should generate engine type', () {
        final engine = faker.vehicle.engine();
        expect(engine, isNotEmpty);
      });

      test('should generate drive type', () {
        final drive = faker.vehicle.drive();
        expect(['FWD', 'RWD', 'AWD', '4WD'], contains(drive));
      });

      test('should generate doors count', () {
        final doors = faker.vehicle.doors();
        expect([2, 3, 4, 5], contains(doors));
      });

      test('should generate seats count', () {
        final seats = faker.vehicle.seats();
        expect(seats, greaterThanOrEqualTo(2));
        expect(seats, lessThanOrEqualTo(9));
      });

      test('should generate mileage', () {
        final mileage = faker.vehicle.mileage();
        expect(mileage, greaterThanOrEqualTo(0));
        expect(mileage, lessThanOrEqualTo(300000));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English vehicle data', () {
        final faker = SmartFaker(locale: 'en_US');
        final plate = faker.vehicle.licensePlate();

        expect(plate, matches(RegExp(r'^[A-Z]{3}-\d{4}$')));
      });

      test('should generate Traditional Chinese vehicle data', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final plate = faker.vehicle.licensePlate();

        expect(plate, matches(RegExp(r'^[A-Z]{3}-\d{4}$')));
      });

      test('should generate Japanese vehicle data', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final plate = faker.vehicle.licensePlate();

        expect(plate, matches(RegExp(r'^.{2,4} \d{2}-\d{2}$')));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible vehicle data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.vehicle.manufacturer(),
            equals(faker2.vehicle.manufacturer()));
        expect(faker1.vehicle.vin(), equals(faker2.vehicle.vin()));
        expect(faker1.vehicle.year(), equals(faker2.vehicle.year()));
      });
    });
  });
}
