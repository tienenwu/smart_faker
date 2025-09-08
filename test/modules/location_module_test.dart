import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('LocationModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Address Generation', () {
      test('should generate street address', () {
        final address = faker.location.streetAddress();
        expect(address, isNotEmpty);
        expect(address, matches(RegExp(r'^\d+\s+.+')));
      });

      test('should generate street name', () {
        final street = faker.location.streetName();
        expect(street, isNotEmpty);
      });

      test('should generate building number', () {
        final number = faker.location.buildingNumber();
        expect(number, isNotEmpty);
        expect(int.tryParse(number), isNotNull);
      });

      test('should generate secondary address', () {
        final secondary = faker.location.secondaryAddress();
        expect(secondary, isNotEmpty);
        expect(secondary, matches(RegExp(r'(Apt\.|Suite|Unit)\s+\w+')));
      });

      test('should generate full address', () {
        final address = faker.location.fullAddress();
        expect(address, isNotEmpty);
        expect(address, contains(','));
      });
    });

    group('City and State', () {
      test('should generate city name', () {
        final city = faker.location.city();
        expect(city, isNotEmpty);
      });

      test('should generate state', () {
        final state = faker.location.state();
        expect(state, isNotEmpty);
      });

      test('should generate state abbreviation', () {
        final abbr = faker.location.stateAbbr();
        expect(abbr, isNotEmpty);
        expect(abbr.length, lessThanOrEqualTo(3));
      });

      test('should generate country', () {
        final country = faker.location.country();
        expect(country, isNotEmpty);
      });

      test('should generate country code', () {
        final code = faker.location.countryCode();
        expect(code, matches(RegExp(r'^[A-Z]{2}$')));
      });
    });

    group('Postal Codes', () {
      test('should generate zip code', () {
        final zip = faker.location.zipCode();
        expect(zip, isNotEmpty);
        // US format: 5 digits or 5+4 format
        expect(zip, matches(RegExp(r'^\d{5}(-\d{4})?$')));
      });

      test('should generate postal code', () {
        final postal = faker.location.postalCode();
        expect(postal, isNotEmpty);
      });
    });

    group('Coordinates', () {
      test('should generate latitude', () {
        final lat = faker.location.latitude();
        expect(lat, greaterThanOrEqualTo(-90));
        expect(lat, lessThanOrEqualTo(90));
      });

      test('should generate longitude', () {
        final lon = faker.location.longitude();
        expect(lon, greaterThanOrEqualTo(-180));
        expect(lon, lessThanOrEqualTo(180));
      });

      test('should generate coordinates', () {
        final coords = faker.location.coordinates();
        expect(coords.latitude, greaterThanOrEqualTo(-90));
        expect(coords.latitude, lessThanOrEqualTo(90));
        expect(coords.longitude, greaterThanOrEqualTo(-180));
        expect(coords.longitude, lessThanOrEqualTo(180));
      });

      test('should generate nearby coordinates', () {
        final base = faker.location.coordinates();
        final nearby = faker.location.nearbyCoordinates(
          latitude: base.latitude,
          longitude: base.longitude,
          radius: 10, // 10km
        );
        
        // Calculate approximate distance (simplified)
        final latDiff = (base.latitude - nearby.latitude).abs();
        final lonDiff = (base.longitude - nearby.longitude).abs();
        
        // Rough check - within reasonable range
        expect(latDiff, lessThan(0.2)); // ~20km
        expect(lonDiff, lessThan(0.2));
      });
    });

    group('Other Location Data', () {
      test('should generate timezone', () {
        final timezone = faker.location.timezone();
        expect(timezone, isNotEmpty);
        expect(timezone, contains('/'));
      });

      test('should generate direction', () {
        final direction = faker.location.direction();
        expect(direction, isNotEmpty);
        expect(['North', 'South', 'East', 'West', 
                'Northeast', 'Northwest', 'Southeast', 'Southwest'],
                contains(direction));
      });

      test('should generate cardinal direction', () {
        final cardinal = faker.location.cardinalDirection();
        expect(['N', 'S', 'E', 'W', 'NE', 'NW', 'SE', 'SW'],
                contains(cardinal));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English address format', () {
        final faker = SmartFaker(locale: 'en_US');
        final address = faker.location.fullAddress();
        expect(address, isNotEmpty);
        // US format includes state abbreviation
        expect(address, matches(RegExp(r',\s+[A-Z]{2}\s+\d{5}')));
      });

      test('should generate Traditional Chinese address format', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final address = faker.location.fullAddress();
        expect(address, isNotEmpty);
        // Taiwan format includes 區, 市, 路, 號
        expect(address, anyOf(
          contains('區'),
          contains('市'),
          contains('路'),
          contains('號'),
        ));
      });

      test('should generate Japanese address format', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final address = faker.location.fullAddress();
        expect(address, isNotEmpty);
        // Japanese format includes 都, 府, 県, 市, 区
        expect(address, anyOf(
          contains('都'),
          contains('府'),
          contains('県'),
          contains('市'),
          contains('区'),
        ));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);
        
        expect(faker1.location.streetAddress(), 
               equals(faker2.location.streetAddress()));
        expect(faker1.location.city(), 
               equals(faker2.location.city()));
        expect(faker1.location.zipCode(), 
               equals(faker2.location.zipCode()));
        expect(faker1.location.latitude(), 
               equals(faker2.location.latitude()));
        expect(faker1.location.longitude(), 
               equals(faker2.location.longitude()));
      });
    });
  });
}