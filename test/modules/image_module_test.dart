import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('ImageModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Image URLs', () {
      test('should generate image URL', () {
        final url = faker.image.url();
        expect(url, startsWith('https://'));
        expect(url, contains('/'));
      });

      test('should generate image URL with dimensions', () {
        final url = faker.image.url(width: 800, height: 600);
        expect(url, contains('800'));
        expect(url, contains('600'));
      });

      test('should generate placeholder URL', () {
        final url = faker.image.placeholder();
        expect(url, contains('placeholder'));
      });

      test('should generate avatar URL', () {
        final url = faker.image.avatar();
        expect(url, isNotEmpty);
        expect(url, startsWith('https://'));
      });

      test('should generate data URI', () {
        final dataUri = faker.image.dataUri();
        expect(dataUri, startsWith('data:image/'));
        expect(dataUri, contains('base64,'));
      });
    });

    group('Image Categories', () {
      test('should generate nature image', () {
        final url = faker.image.nature();
        expect(url, contains('nature'));
      });

      test('should generate people image', () {
        final url = faker.image.people();
        expect(url, contains('people'));
      });

      test('should generate technology image', () {
        final url = faker.image.technology();
        expect(url, contains('technology'));
      });

      test('should generate food image', () {
        final url = faker.image.food();
        expect(url, contains('food'));
      });

      test('should generate transport image', () {
        final url = faker.image.transport();
        expect(url, contains('transport'));
      });

      test('should generate animals image', () {
        final url = faker.image.animals();
        expect(url, contains('animals'));
      });

      test('should generate business image', () {
        final url = faker.image.business();
        expect(url, contains('business'));
      });

      test('should generate fashion image', () {
        final url = faker.image.fashion();
        expect(url, contains('fashion'));
      });

      test('should generate sports image', () {
        final url = faker.image.sports();
        expect(url, contains('sports'));
      });

      test('should generate abstract image', () {
        final url = faker.image.abstract();
        expect(url, contains('abstract'));
      });
    });

    group('Color Generation', () {
      test('should generate hex color', () {
        final color = faker.image.hexColor();
        expect(color, matches(RegExp(r'^#[0-9A-F]{6}$')));
      });

      test('should generate RGB color', () {
        final color = faker.image.rgbColor();
        expect(color, matches(RegExp(r'^rgb\(\d{1,3}, \d{1,3}, \d{1,3}\)$')));
      });

      test('should generate HSL color', () {
        final color = faker.image.hslColor();
        expect(color, matches(RegExp(r'^hsl\(\d{1,3}, \d{1,3}%, \d{1,3}%\)$')));
      });
    });

    group('Local Avatar Generation', () {
      test('should generate local avatar with default settings', () {
        final avatar = faker.image.localAvatar();
        expect(avatar, startsWith('data:image/svg+xml;base64,'));
      });

      test('should generate circle avatar', () {
        final avatar = faker.image.localAvatar(shape: 'circle');
        expect(avatar, startsWith('data:image/svg+xml;base64,'));
      });

      test('should generate square avatar', () {
        final avatar = faker.image.localAvatar(shape: 'square');
        expect(avatar, startsWith('data:image/svg+xml;base64,'));
      });

      test('should generate avatar with custom name', () {
        final avatar = faker.image.localAvatar(name: 'JD');
        expect(avatar, startsWith('data:image/svg+xml;base64,'));
      });

      test('should generate avatar with custom size', () {
        final avatar = faker.image.localAvatar(size: 128);
        expect(avatar, startsWith('data:image/svg+xml;base64,'));
      });

      test('should generate avatar with custom colors', () {
        final avatar = faker.image.localAvatar(
          bgColor: '#FF6B6B',
          textColor: '#FFFFFF',
        );
        expect(avatar, startsWith('data:image/svg+xml;base64,'));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English image data', () {
        final faker = SmartFaker(locale: 'en_US');
        final url = faker.image.url();
        expect(url, isNotEmpty);
      });

      test('should generate Traditional Chinese image data', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final url = faker.image.url();
        expect(url, isNotEmpty);
      });

      test('should generate Japanese image data', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final url = faker.image.url();
        expect(url, isNotEmpty);
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible image data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.image.url(), equals(faker2.image.url()));
        expect(faker1.image.hexColor(), equals(faker2.image.hexColor()));
        expect(faker1.image.avatar(), equals(faker2.image.avatar()));
      });
    });
  });
}
