import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('ColorModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Color Formats', () {
      test('should generate hex color', () {
        final hex = faker.color.hex();
        expect(hex, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate hex color with alpha', () {
        final hex = faker.color.hex(includeAlpha: true);
        expect(hex, matches(RegExp(r'^#[0-9A-F]{8}$')));
      });

      test('should generate RGB color', () {
        final rgb = faker.color.rgb();
        expect(rgb, matches(RegExp(r'^rgb\(\d{1,3}, \d{1,3}, \d{1,3}\)$')));

        // Parse and validate RGB values
        final values = RegExp(r'\d+')
            .allMatches(rgb)
            .map((m) => int.parse(m.group(0)!))
            .toList();
        expect(values.length, 3);
        for (final value in values) {
          expect(value, greaterThanOrEqualTo(0));
          expect(value, lessThanOrEqualTo(255));
        }
      });

      test('should generate RGBA color', () {
        final rgba = faker.color.rgba();
        expect(
            rgba,
            matches(
                RegExp(r'^rgba\(\d{1,3}, \d{1,3}, \d{1,3}, [01](\.\d+)?\)$')));
      });

      test('should generate HSL color', () {
        final hsl = faker.color.hsl();
        expect(hsl, matches(RegExp(r'^hsl\(\d{1,3}, \d{1,3}%, \d{1,3}%\)$')));
      });

      test('should generate HSLA color', () {
        final hsla = faker.color.hsla();
        expect(
            hsla,
            matches(RegExp(
                r'^hsla\(\d{1,3}, \d{1,3}%, \d{1,3}%, [01](\.\d+)?\)$')));
      });

      test('should generate HSV color', () {
        final hsv = faker.color.hsv();
        expect(hsv, matches(RegExp(r'^hsv\(\d{1,3}, \d{1,3}%, \d{1,3}%\)$')));
      });

      test('should generate CMYK color', () {
        final cmyk = faker.color.cmyk();
        expect(
            cmyk,
            matches(
                RegExp(r'^cmyk\(\d{1,3}%, \d{1,3}%, \d{1,3}%, \d{1,3}%\)$')));
      });
    });

    group('Named Colors', () {
      test('should generate CSS color name', () {
        final color = faker.color.cssName();
        expect(color, isNotEmpty);
        expect([
          'red',
          'green',
          'blue',
          'yellow',
          'orange',
          'purple',
          'pink',
          'brown',
          'black',
          'white',
          'gray',
          'cyan',
          'magenta',
          'lime',
          'indigo',
          'violet',
          'turquoise',
          'gold',
          'silver',
          'maroon',
          'navy',
          'teal',
          'olive',
          'aqua',
          'fuchsia',
          'crimson',
          'coral',
          'salmon',
          'khaki',
          'lavender',
          'plum',
          'mint',
          'ivory',
          'pearl'
        ], contains(color.toLowerCase()));
      });

      test('should generate material color', () {
        final material = faker.color.material();
        expect(material, isNotEmpty);
        expect(
            material,
            contains(RegExp(
                r'^(red|pink|purple|deepPurple|indigo|blue|lightBlue|cyan|teal|green|lightGreen|lime|yellow|amber|orange|deepOrange|brown|grey|blueGrey)\[\d{2,3}\]$')));
      });

      test('should generate tailwind color', () {
        final tailwind = faker.color.tailwind();
        expect(tailwind, isNotEmpty);
        expect(tailwind, contains('-'));
      });
    });

    group('Color Schemes', () {
      test('should generate monochromatic scheme', () {
        final scheme = faker.color.monochromatic();
        expect(scheme, hasLength(5));
        for (final color in scheme) {
          expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
        }
      });

      test('should generate analogous scheme', () {
        final scheme = faker.color.analogous();
        expect(scheme, hasLength(3));
        for (final color in scheme) {
          expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
        }
      });

      test('should generate complementary scheme', () {
        final scheme = faker.color.complementary();
        expect(scheme, hasLength(2));
        for (final color in scheme) {
          expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
        }
      });

      test('should generate triadic scheme', () {
        final scheme = faker.color.triadic();
        expect(scheme, hasLength(3));
        for (final color in scheme) {
          expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
        }
      });

      test('should generate tetradic scheme', () {
        final scheme = faker.color.tetradic();
        expect(scheme, hasLength(4));
        for (final color in scheme) {
          expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
        }
      });

      test('should generate split complementary scheme', () {
        final scheme = faker.color.splitComplementary();
        expect(scheme, hasLength(3));
        for (final color in scheme) {
          expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
        }
      });
    });

    group('Color Properties', () {
      test('should generate random color', () {
        final color = faker.color.randomColor();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate warm color', () {
        final color = faker.color.warm();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate cool color', () {
        final color = faker.color.cool();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate pastel color', () {
        final color = faker.color.pastel();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate vibrant color', () {
        final color = faker.color.vibrant();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate dark color', () {
        final color = faker.color.dark();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate light color', () {
        final color = faker.color.light();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });
    });

    group('Color Components', () {
      test('should generate hue value', () {
        final hue = faker.color.hue();
        expect(hue, greaterThanOrEqualTo(0));
        expect(hue, lessThanOrEqualTo(360));
      });

      test('should generate saturation value', () {
        final saturation = faker.color.saturation();
        expect(saturation, greaterThanOrEqualTo(0));
        expect(saturation, lessThanOrEqualTo(100));
      });

      test('should generate lightness value', () {
        final lightness = faker.color.lightness();
        expect(lightness, greaterThanOrEqualTo(0));
        expect(lightness, lessThanOrEqualTo(100));
      });

      test('should generate alpha value', () {
        final alpha = faker.color.alpha();
        expect(alpha, greaterThanOrEqualTo(0.0));
        expect(alpha, lessThanOrEqualTo(1.0));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible colors with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.color.hex(), equals(faker2.color.hex()));
        expect(faker1.color.rgb(), equals(faker2.color.rgb()));
        expect(faker1.color.cssName(), equals(faker2.color.cssName()));
      });
    });
  });
}
