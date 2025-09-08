import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('InternetModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Email Generation', () {
      test('should generate valid email', () {
        final email = faker.internet.email();
        expect(email, isNotEmpty);
        expect(email, contains('@'));
        expect(email, contains('.'));
        // Basic email format validation
        expect(email, matches(RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$')));
      });

      test('should generate email with custom provider', () {
        final email = faker.internet.email(provider: 'company.com');
        expect(email, endsWith('@company.com'));
      });

      test('should generate email with first and last name', () {
        final email = faker.internet.email(
          firstName: 'John',
          lastName: 'Doe',
        );
        expect(email.toLowerCase(), contains('john'));
        expect(email.toLowerCase(), contains('doe'));
      });

      test('should generate safe email', () {
        final email = faker.internet.safeEmail();
        expect(email, matches(RegExp(r'@example\.(com|org|net)$')));
      });

      test('should generate company email', () {
        final email = faker.internet.companyEmail(companyName: 'TechCorp');
        expect(email.toLowerCase(), contains('techcorp'));
      });
    });

    group('Username Generation', () {
      test('should generate username', () {
        final username = faker.internet.username();
        expect(username, isNotEmpty);
        expect(username.length, greaterThanOrEqualTo(3));
        expect(username, matches(RegExp(r'^[\w._]+$')));
      });

      test('should generate username with custom length', () {
        final username = faker.internet.username(minLength: 10, maxLength: 15);
        expect(username.length, greaterThanOrEqualTo(10));
        expect(username.length, lessThanOrEqualTo(15));
      });
    });

    group('Password Generation', () {
      test('should generate password with default length', () {
        final password = faker.internet.password();
        expect(password.length, greaterThanOrEqualTo(8));
        expect(password.length, lessThanOrEqualTo(16));
      });

      test('should generate password with custom length', () {
        final password = faker.internet.password(length: 20);
        expect(password.length, equals(20));
      });

      test('should generate password with special characters', () {
        final password = faker.internet.password(
          length: 20,
          includeSpecial: true,
        );
        expect(password.length, equals(20));
        // Should contain at least one special character
        expect(password, matches(RegExp(r'[!@#$%^&*(),.?":{}|<>]')));
      });

      test('should generate password with custom pattern', () {
        final password = faker.internet.password(
          includeUppercase: true,
          includeLowercase: true,
          includeNumbers: true,
          includeSpecial: false,
        );
        expect(password, matches(RegExp(r'^[a-zA-Z0-9]+$')));
      });
    });

    group('URL Generation', () {
      test('should generate valid URL', () {
        final url = faker.internet.url();
        expect(url, startsWith('https://'));
        expect(url, contains('.'));
      });

      test('should generate URL with custom protocol', () {
        final url = faker.internet.url(protocol: 'http');
        expect(url, startsWith('http://'));
      });

      test('should generate URL with path', () {
        final url = faker.internet.url(includePath: true);
        expect(url, matches(RegExp(r'https://[\w.-]+\.\w+/[\w/-]+')));
      });

      test('should generate domain name', () {
        final domain = faker.internet.domainName();
        expect(domain, isNotEmpty);
        expect(domain, contains('.'));
        expect(domain, matches(RegExp(r'^[\w-]+\.\w+$')));
      });

      test('should generate subdomain', () {
        final subdomain = faker.internet.domainWord();
        expect(subdomain, isNotEmpty);
        expect(subdomain, matches(RegExp(r'^[\w-]+$')));
      });
    });

    group('IP Address Generation', () {
      test('should generate valid IPv4 address', () {
        final ip = faker.internet.ipv4();
        expect(ip, matches(RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')));
        
        // Each octet should be 0-255
        final octets = ip.split('.');
        for (final octet in octets) {
          final value = int.parse(octet);
          expect(value, greaterThanOrEqualTo(0));
          expect(value, lessThanOrEqualTo(255));
        }
      });

      test('should generate valid IPv6 address', () {
        final ip = faker.internet.ipv6();
        expect(ip, matches(RegExp(r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$')));
      });

      test('should generate private IPv4 address', () {
        final ip = faker.internet.privateIpv4();
        // Should be in private ranges: 10.x.x.x, 172.16-31.x.x, or 192.168.x.x
        expect(ip, matches(RegExp(
          r'^(10\.\d{1,3}\.\d{1,3}\.\d{1,3}|'
          r'172\.(1[6-9]|2[0-9]|3[0-1])\.\d{1,3}\.\d{1,3}|'
          r'192\.168\.\d{1,3}\.\d{1,3})$'
        )));
      });

      test('should generate MAC address', () {
        final mac = faker.internet.macAddress();
        expect(mac, matches(RegExp(
          r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$'
        )));
      });

      test('should generate port number', () {
        final port = faker.internet.port();
        expect(port, greaterThanOrEqualTo(1));
        expect(port, lessThanOrEqualTo(65535));
      });
    });

    group('User Agent Generation', () {
      test('should generate user agent string', () {
        final userAgent = faker.internet.userAgent();
        expect(userAgent, isNotEmpty);
        expect(userAgent, contains('Mozilla'));
      });

      test('should generate Chrome user agent', () {
        final userAgent = faker.internet.userAgent(browser: 'chrome');
        expect(userAgent, contains('Chrome'));
      });

      test('should generate Firefox user agent', () {
        final userAgent = faker.internet.userAgent(browser: 'firefox');
        expect(userAgent, contains('Firefox'));
      });

      test('should generate Safari user agent', () {
        final userAgent = faker.internet.userAgent(browser: 'safari');
        expect(userAgent, contains('Safari'));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);
        
        expect(faker1.internet.email(), equals(faker2.internet.email()));
        expect(faker1.internet.username(), equals(faker2.internet.username()));
        expect(faker1.internet.password(), equals(faker2.internet.password()));
        expect(faker1.internet.url(), equals(faker2.internet.url()));
        expect(faker1.internet.ipv4(), equals(faker2.internet.ipv4()));
      });
    });
  });
}