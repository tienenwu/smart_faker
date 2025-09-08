import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating phone-related data.
class PhoneModule {
  final RandomGenerator random;
  final LocaleManager localeManager;

  PhoneModule(this.random, this.localeManager);

  String get currentLocale => localeManager.currentLocale;

  /// Generates a phone number based on locale.
  String number() {
    switch (currentLocale) {
      case 'zh_TW':
        // Taiwan mobile format: 09XX-XXX-XXX
        return '09${random.integer(min: 10, max: 99)}-'
               '${random.integer(min: 100, max: 999)}-'
               '${random.integer(min: 100, max: 999)}';
      case 'ja_JP':
        // Japan mobile format: 0X0-XXXX-XXXX
        final prefix = random.element(['070', '080', '090']);
        return '$prefix-'
               '${random.integer(min: 1000, max: 9999)}-'
               '${random.integer(min: 1000, max: 9999)}';
      default:
        // US format: (XXX) XXX-XXXX
        return formatted();
    }
  }

  /// Generates a mobile phone number.
  String mobile() {
    switch (currentLocale) {
      case 'zh_TW':
        return '09${random.integer(min: 10000000, max: 99999999)}';
      case 'ja_JP':
        final prefix = random.element(['070', '080', '090']);
        return '$prefix${random.integer(min: 10000000, max: 99999999)}';
      default:
        final area = random.element(['415', '650', '408', '510', '925', '628']);
        return '($area) ${random.integer(min: 200, max: 999)}-'
               '${random.integer(min: 1000, max: 9999)}';
    }
  }

  /// Generates an international phone number.
  String international() {
    final country = countryCode();
    // Generate number in parts to avoid overflow
    final part1 = random.integer(min: 100, max: 999);
    final part2 = random.integer(min: 100, max: 999);
    final part3 = random.integer(min: 1000, max: 9999);
    return '$country $part1 $part2 $part3';
  }

  /// Generates a toll-free number.
  String tollFree() {
    final prefix = random.element(['800', '888', '877', '866', '855', '844', '833']);
    return '1-$prefix-${random.integer(min: 100, max: 999)}-'
           '${random.integer(min: 1000, max: 9999)}';
  }

  /// Generates a formatted US phone number.
  String formatted() {
    return '(${areaCode()}) ${random.integer(min: 200, max: 999)}-'
           '${random.integer(min: 1000, max: 9999)}';
  }

  /// Generates a phone extension.
  String extension() {
    return random.integer(min: 1, max: 9999).toString();
  }

  /// Generates an IMEI number.
  String imei() {
    // Generate 14 digits
    final digits = List.generate(14, (_) => random.nextInt(10));
    
    // Calculate Luhn check digit
    int sum = 0;
    for (int i = 0; i < 14; i++) {
      int digit = digits[i];
      if (i % 2 == 1) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + (digit ~/ 10);
        }
      }
      sum += digit;
    }
    final checkDigit = (10 - (sum % 10)) % 10;
    
    return digits.join() + checkDigit.toString();
  }

  /// Generates an IMSI number.
  String imsi() {
    // MCC (3 digits) + MNC (2-3 digits) + MSIN (9-10 digits)
    final mcc = random.integer(min: 100, max: 999);
    final mnc = random.integer(min: 10, max: 999);
    final msin = random.integer(min: 100000000, max: 999999999);
    return '$mcc$mnc$msin'.padRight(15, '0').substring(0, 15);
  }

  /// Generates a phone model name.
  String model() {
    final manufacturer = this.manufacturer();
    switch (manufacturer) {
      case 'Apple':
        final model = random.element(['iPhone 15 Pro', 'iPhone 15', 'iPhone 14 Pro', 
                                      'iPhone 14', 'iPhone 13', 'iPhone SE']);
        return model;
      case 'Samsung':
        final series = random.element(['Galaxy S24', 'Galaxy S23', 'Galaxy Note', 
                                       'Galaxy A54', 'Galaxy Z Fold', 'Galaxy Z Flip']);
        return series;
      case 'Google':
        return 'Pixel ${random.integer(min: 6, max: 9)}';
      default:
        return '$manufacturer ${random.element(_modelSuffixes)}';
    }
  }

  /// Generates a phone manufacturer name.
  String manufacturer() {
    return random.element(_manufacturers);
  }

  /// Generates an OS version.
  String osVersion() {
    final os = random.element(['iOS', 'Android']);
    if (os == 'iOS') {
      return 'iOS ${random.integer(min: 14, max: 17)}.${random.integer(min: 0, max: 9)}';
    } else {
      return 'Android ${random.integer(min: 10, max: 14)}';
    }
  }

  /// Generates a country code.
  String countryCode() {
    return random.element(_countryCodes);
  }

  /// Generates an area code.
  String areaCode() {
    return random.element(_areaCodes);
  }

  static final List<String> _manufacturers = [
    'Apple', 'Samsung', 'Google', 'Xiaomi', 'OnePlus', 'Huawei',
    'Sony', 'LG', 'Motorola', 'Nokia', 'OPPO', 'Vivo',
    'Realme', 'ASUS', 'HTC',
  ];

  static final List<String> _modelSuffixes = [
    'Pro', 'Pro Max', 'Ultra', 'Plus', 'Mini', 'Lite',
    'Edge', 'Note', 'Max', 'Prime', 'X', 'Z',
    '5G', 'Turbo', 'Power', 'Play',
  ];

  static final List<String> _countryCodes = [
    '+1',    // US/Canada
    '+44',   // UK
    '+49',   // Germany
    '+33',   // France
    '+39',   // Italy
    '+34',   // Spain
    '+31',   // Netherlands
    '+46',   // Sweden
    '+47',   // Norway
    '+358',  // Finland
    '+81',   // Japan
    '+82',   // South Korea
    '+86',   // China
    '+886',  // Taiwan
    '+852',  // Hong Kong
    '+65',   // Singapore
    '+60',   // Malaysia
    '+66',   // Thailand
    '+84',   // Vietnam
    '+62',   // Indonesia
    '+63',   // Philippines
    '+91',   // India
    '+61',   // Australia
    '+64',   // New Zealand
    '+55',   // Brazil
    '+52',   // Mexico
    '+54',   // Argentina
    '+56',   // Chile
    '+57',   // Colombia
    '+51',   // Peru
  ];

  static final List<String> _areaCodes = [
    '201', '202', '203', '205', '206', '207', '208', '209', '210',
    '212', '213', '214', '215', '216', '217', '218', '219', '224',
    '225', '228', '229', '231', '234', '239', '240', '248', '251',
    '252', '253', '254', '256', '260', '262', '267', '269', '270',
    '272', '276', '281', '301', '302', '303', '304', '305', '307',
    '308', '309', '310', '312', '313', '314', '315', '316', '317',
    '318', '319', '320', '321', '323', '325', '330', '331', '334',
    '336', '337', '339', '340', '341', '346', '347', '351', '352',
    '360', '361', '364', '380', '385', '386', '401', '402', '404',
    '405', '406', '407', '408', '409', '410', '412', '413', '414',
    '415', '417', '419', '423', '424', '425', '430', '432', '434',
    '435', '440', '442', '443', '445', '447', '458', '463', '464',
    '469', '470', '475', '478', '479', '480', '484', '501', '502',
    '503', '504', '505', '507', '508', '509', '510', '512', '513',
    '515', '516', '517', '518', '520', '530', '531', '534', '539',
    '540', '541', '551', '559', '561', '562', '563', '564', '567',
    '570', '571', '572', '573', '574', '575', '580', '585', '586',
    '601', '602', '603', '605', '606', '607', '608', '609', '610',
    '612', '614', '615', '616', '617', '618', '619', '620', '623',
    '626', '628', '629', '630', '631', '636', '640', '641', '646',
    '650', '651', '656', '657', '659', '660', '661', '662', '667',
    '669', '678', '680', '681', '682', '689', '701', '702', '703',
    '704', '706', '707', '708', '712', '713', '714', '715', '716',
    '717', '718', '719', '720', '724', '725', '726', '727', '730',
    '731', '732', '734', '737', '740', '743', '747', '754', '757',
    '760', '762', '763', '765', '769', '770', '772', '773', '774',
    '775', '779', '781', '785', '786', '801', '802', '803', '804',
    '805', '806', '808', '810', '812', '813', '814', '815', '816',
    '817', '818', '820', '828', '830', '831', '832', '838', '839',
    '840', '843', '845', '847', '848', '850', '854', '856', '857',
    '858', '859', '860', '862', '863', '864', '865', '870', '872',
    '878', '901', '903', '904', '906', '907', '908', '909', '910',
    '912', '913', '914', '915', '916', '917', '918', '919', '920',
    '925', '928', '929', '930', '931', '934', '936', '937', '938',
    '940', '941', '947', '949', '951', '952', '954', '956', '959',
    '970', '971', '972', '973', '978', '979', '980', '984', '985',
    '986', '989',
  ];
}