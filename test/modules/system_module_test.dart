import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('SystemModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('File System', () {
      test('should generate file name', () {
        final fileName = faker.system.fileName();
        expect(fileName, matches(RegExp(r'^[a-z_]+\.[a-z]+$')));
      });

      test('should generate file extension', () {
        final ext = faker.system.fileExtension();
        expect(ext, matches(RegExp(r'^[a-z]+$')));
      });

      test('should generate file path', () {
        final path = faker.system.filePath();
        expect(path, contains('/'));
      });

      test('should generate directory path', () {
        final dir = faker.system.directoryPath();
        expect(dir, startsWith('/'));
        expect(dir, endsWith('/'));
      });

      test('should generate MIME type', () {
        final mime = faker.system.mimeType();
        expect(mime, contains('/'));
      });
    });

    group('Network', () {
      test('should generate semver version', () {
        final version = faker.system.semver();
        expect(version, matches(RegExp(r'^\d+\.\d+\.\d+$')));
      });

      test('should generate semantic version with prerelease', () {
        final version = faker.system.semverPrerelease();
        expect(version, matches(RegExp(r'^\d+\.\d+\.\d+-[a-z]+\.\d+$')));
      });
    });

    group('System Info', () {
      test('should generate process name', () {
        final process = faker.system.processName();
        expect(process, isNotEmpty);
      });

      test('should generate cron expression', () {
        final cron = faker.system.cron();
        final parts = cron.split(' ');
        expect(parts, hasLength(5));
      });

      test('should generate environment variable', () {
        final env = faker.system.environmentVariable();
        expect(env, matches(RegExp(r'^[A-Z_]+$')));
      });

      test('should generate OS name', () {
        final os = faker.system.operatingSystem();
        expect(['Windows', 'macOS', 'Linux', 'Ubuntu', 'Debian', 'Fedora', 
                'CentOS', 'RedHat', 'openSUSE', 'Arch Linux',
                'Android', 'iOS', 'Windows Phone',
                'FreeBSD', 'OpenBSD', 'NetBSD'], 
          contains(os));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English system data', () {
        final faker = SmartFaker(locale: 'en_US');
        final file = faker.system.fileName();
        expect(file, isNotEmpty);
      });

      test('should generate Traditional Chinese system data', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final file = faker.system.fileName();
        expect(file, isNotEmpty);
      });

      test('should generate Japanese system data', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final file = faker.system.fileName();
        expect(file, isNotEmpty);
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible system data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);
        
        expect(faker1.system.fileName(), equals(faker2.system.fileName()));
        expect(faker1.system.semver(), equals(faker2.system.semver()));
        expect(faker1.system.processName(), equals(faker2.system.processName()));
      });
    });
  });
}