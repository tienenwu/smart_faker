import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating internet-related data.
class InternetModule {
  /// Creates a new instance of [InternetModule].
  ///
  /// [randomGenerator] is used for generating random values.
  /// [localeManager] handles localization of internet data.
  InternetModule({
    required this.randomGenerator,
    required this.localeManager,
  });

  /// Random generator instance for generating random values.
  final RandomGenerator randomGenerator;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  // Common email providers
  static const List<String> _emailProviders = [
    'gmail.com',
    'yahoo.com',
    'hotmail.com',
    'outlook.com',
    'icloud.com',
    'mail.com',
    'protonmail.com',
    'aol.com',
    'yandex.com',
    'qq.com',
  ];

  static const List<String> _safeEmailProviders = [
    'example.com',
    'example.org',
    'example.net',
  ];

  static const List<String> _topLevelDomains = [
    'com',
    'org',
    'net',
    'edu',
    'gov',
    'io',
    'co',
    'app',
    'dev',
    'tech',
    'ai',
    'cloud',
    'online',
    'store',
    'blog',
  ];

  static const List<String> _domainWords = [
    'tech',
    'global',
    'solutions',
    'systems',
    'digital',
    'cloud',
    'data',
    'smart',
    'future',
    'innovation',
    'creative',
    'design',
    'marketing',
    'consulting',
    'analytics',
    'ventures',
    'labs',
    'studio',
    'hub',
    'center',
  ];

  /// Generates an email address.
  String email({
    String? firstName,
    String? lastName,
    String? provider,
  }) {
    final first = (firstName ?? _randomWord()).toLowerCase();
    final last = (lastName ?? _randomWord()).toLowerCase();
    final domain = provider ?? randomGenerator.element(_emailProviders);

    // If both names are provided, ensure both are used
    List<String> formats;
    if (firstName != null && lastName != null) {
      formats = [
        '$first.$last',
        '$first$last',
        '${first}_$last',
        '$first.$last${randomGenerator.integer(max: 99)}',
      ];
    } else {
      formats = [
        '$first.$last',
        '$first$last',
        '$first.${last[0]}',
        '${first[0]}$last',
        '$first$last${randomGenerator.integer(max: 999)}',
        '$first${randomGenerator.integer(max: 99)}',
      ];
    }

    final username = randomGenerator.element(formats);
    return '$username@$domain';
  }

  /// Generates a safe email address (using example domains).
  String safeEmail() {
    final user = username();
    final provider = randomGenerator.element(_safeEmailProviders);
    return '$user@$provider';
  }

  /// Generates a company email address.
  String companyEmail({required String companyName}) {
    final cleanCompany =
        companyName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final firstName = _randomWord().toLowerCase();
    final lastName = _randomWord().toLowerCase();

    final formats = [
      '$firstName.$lastName',
      '$firstName',
      '${firstName[0]}$lastName',
      '$firstName.${lastName[0]}',
    ];

    final username = randomGenerator.element(formats);
    return '$username@$cleanCompany.com';
  }

  /// Generates a username.
  String username({int minLength = 3, int maxLength = 20}) {
    final length = randomGenerator.integer(min: minLength, max: maxLength);
    final parts = <String>[];

    // Build username from parts
    parts.add(_randomWord());

    if (length > 8 && randomGenerator.boolean()) {
      parts.add(randomGenerator.element(['_', '.', '']));
      parts.add(_randomWord());
    }

    if (randomGenerator.boolean(probability: 0.3)) {
      parts.add(randomGenerator.integer(max: 999).toString());
    }

    var result = parts.join('').toLowerCase();

    // Ensure it meets length requirements
    if (result.length > maxLength) {
      result = result.substring(0, maxLength);
    } else if (result.length < minLength) {
      result += randomGenerator.string(length: minLength - result.length);
    }

    return result;
  }

  /// Generates a password.
  String password({
    int? length,
    int minLength = 8,
    int maxLength = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecial = false,
  }) {
    final passwordLength =
        length ?? randomGenerator.integer(min: minLength, max: maxLength);

    var charset = '';
    if (includeLowercase) charset += 'abcdefghijklmnopqrstuvwxyz';
    if (includeUppercase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (includeNumbers) charset += '0123456789';
    if (includeSpecial) charset += '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    if (charset.isEmpty) {
      charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    }

    final password = List.generate(
      passwordLength,
      (_) => charset[randomGenerator.integer(max: charset.length - 1)],
    ).join();

    return password;
  }

  /// Generates a URL.
  String url({
    String protocol = 'https',
    bool includePath = false,
    bool includeQuery = false,
  }) {
    final domain = domainName();
    var result = '$protocol://$domain';

    if (includePath) {
      final pathSegments = randomGenerator.integer(min: 1, max: 3);
      for (int i = 0; i < pathSegments; i++) {
        result += '/${_randomWord().toLowerCase()}';
      }
    }

    if (includeQuery) {
      final params = randomGenerator.integer(min: 1, max: 3);
      final queryParts = <String>[];
      for (int i = 0; i < params; i++) {
        queryParts.add('${_randomWord()}=${_randomWord()}');
      }
      result += '?${queryParts.join('&')}';
    }

    return result;
  }

  /// Generates a domain name.
  String domainName() {
    final word = domainWord();
    final tld = randomGenerator.element(_topLevelDomains);
    return '$word.$tld';
  }

  /// Generates a domain word (subdomain or domain prefix).
  String domainWord() {
    if (randomGenerator.boolean(probability: 0.7)) {
      return randomGenerator.element(_domainWords);
    }
    return _randomWord().toLowerCase();
  }

  /// Generates an IPv4 address.
  String ipv4() {
    return List.generate(4, (_) => randomGenerator.integer(max: 255)).join('.');
  }

  /// Generates an IPv6 address.
  String ipv6() {
    return List.generate(8, (_) {
      final segment = randomGenerator.integer(max: 65535);
      return segment.toRadixString(16).padLeft(4, '0');
    }).join(':');
  }

  /// Generates a private IPv4 address.
  String privateIpv4() {
    final choice = randomGenerator.integer(max: 2);
    switch (choice) {
      case 0: // 10.x.x.x
        return '10.${randomGenerator.integer(max: 255)}.'
            '${randomGenerator.integer(max: 255)}.'
            '${randomGenerator.integer(max: 255)}';
      case 1: // 172.16-31.x.x
        return '172.${randomGenerator.integer(min: 16, max: 31)}.'
            '${randomGenerator.integer(max: 255)}.'
            '${randomGenerator.integer(max: 255)}';
      default: // 192.168.x.x
        return '192.168.${randomGenerator.integer(max: 255)}.'
            '${randomGenerator.integer(max: 255)}';
    }
  }

  /// Generates a MAC address.
  String macAddress() {
    return List.generate(6, (_) {
      final octet = randomGenerator.integer(max: 255);
      return octet.toRadixString(16).padLeft(2, '0').toUpperCase();
    }).join(':');
  }

  /// Generates a port number.
  int port({bool includeWellKnown = true}) {
    if (includeWellKnown) {
      return randomGenerator.integer(min: 1, max: 65535);
    }
    // User ports (1024-65535)
    return randomGenerator.integer(min: 1024, max: 65535);
  }

  /// Generates a user agent string.
  String userAgent({String? browser}) {
    final browserChoice = browser ??
        randomGenerator.element(['chrome', 'firefox', 'safari', 'edge']);

    final os = randomGenerator.element([
      'Windows NT 10.0; Win64; x64',
      'Macintosh; Intel Mac OS X 10_15_7',
      'X11; Linux x86_64',
      'iPhone; CPU iPhone OS 15_0 like Mac OS X',
      'Android 12; Mobile',
    ]);

    switch (browserChoice) {
      case 'chrome':
        final version = randomGenerator.integer(min: 90, max: 120);
        return 'Mozilla/5.0 ($os) AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/$version.0.0.0 Safari/537.36';
      case 'firefox':
        final version = randomGenerator.integer(min: 90, max: 120);
        return 'Mozilla/5.0 ($os) Gecko/20100101 Firefox/$version.0';
      case 'safari':
        final version = randomGenerator.integer(min: 14, max: 17);
        return 'Mozilla/5.0 ($os) AppleWebKit/605.1.15 (KHTML, like Gecko) '
            'Version/$version.0 Safari/605.1.15';
      case 'edge':
        final version = randomGenerator.integer(min: 90, max: 120);
        return 'Mozilla/5.0 ($os) AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/$version.0.0.0 Safari/537.36 Edg/$version.0.0.0';
      default:
        return userAgent(browser: 'chrome');
    }
  }

  // Helper method to generate random words
  String _randomWord() {
    const words = [
      'user',
      'admin',
      'test',
      'demo',
      'info',
      'contact',
      'support',
      'help',
      'service',
      'account',
      'profile',
      'data',
      'system',
      'network',
      'server',
      'client',
      'web',
      'app',
      'mobile',
      'desktop',
      'cloud',
    ];
    return randomGenerator.element(words);
  }
}
