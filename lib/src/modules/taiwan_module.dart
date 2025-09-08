import '../core/random_generator.dart';

/// Module for generating Taiwan-specific data.
class TaiwanModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Creates a new instance of [TaiwanModule].
  ///
  /// [random] is used for generating random values.
  TaiwanModule(this.random);

  /// Generates a valid Taiwan ID number (身分證字號).
  ///
  /// Taiwan ID format: 1 letter + 1 digit (gender) + 8 digits + 1 check digit
  /// First letter represents the city/county of registration
  /// Second digit: 1 for male, 2 for female
  String idNumber({bool? male}) {
    // City/County codes
    final cityLetters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];

    // Letter to number mapping for checksum
    final letterValues = {
      'A': 10,
      'B': 11,
      'C': 12,
      'D': 13,
      'E': 14,
      'F': 15,
      'G': 16,
      'H': 17,
      'I': 34,
      'J': 18,
      'K': 19,
      'L': 20,
      'M': 21,
      'N': 22,
      'O': 35,
      'P': 23,
      'Q': 24,
      'R': 25,
      'S': 26,
      'T': 27,
      'U': 28,
      'V': 29,
      'W': 32,
      'X': 30,
      'Y': 31,
      'Z': 33
    };

    // Random city letter
    final cityLetter = random.element(cityLetters);

    // Gender digit
    final isMale = male ?? random.boolean();
    final genderDigit = isMale ? '1' : '2';

    // Generate 7 random digits
    final digits =
        List.generate(7, (_) => random.nextInt(10).toString()).join();

    // Calculate checksum
    final letterValue = letterValues[cityLetter]!;
    final n1 = letterValue ~/ 10;
    final n2 = letterValue % 10;

    int sum = n1 + n2 * 9;
    sum += int.parse(genderDigit) * 8;

    for (int i = 0; i < 7; i++) {
      sum += int.parse(digits[i]) * (7 - i);
    }

    final checkDigit = (10 - (sum % 10)) % 10;

    return '$cityLetter$genderDigit$digits$checkDigit';
  }

  /// Generates a valid Taiwan company tax ID (統一編號).
  ///
  /// Taiwan company tax ID format: 8 digits with checksum
  String companyTaxId() {
    // Generate 7 random digits
    final digits = List.generate(7, (_) => random.nextInt(10));

    // Calculate checksum using Taiwan's algorithm
    final weights = [1, 2, 1, 2, 1, 2, 4, 1];
    int sum = 0;

    for (int i = 0; i < 7; i++) {
      final product = digits[i] * weights[i];
      sum += (product ~/ 10) + (product % 10);
    }

    // Special case for digit 7
    if (digits[6] == 7) {
      // Two possible check digits
      final checkDigit1 = (10 - (sum % 10)) % 10;
      final checkDigit2 = (10 - ((sum + 1) % 10)) % 10;
      digits.add(random.boolean() ? checkDigit1 : checkDigit2);
    } else {
      final checkDigit = (10 - (sum % 10)) % 10;
      digits.add(checkDigit);
    }

    return digits.join();
  }

  /// Generates a Taiwan landline phone number.
  ///
  /// Format: (0X) XXXX-XXXX where X depends on the area
  String landlineNumber() {
    final areaCodes = {
      '台北': '02',
      '基隆': '02',
      '桃園': '03',
      '新竹': '03',
      '苗栗': '037',
      '台中': '04',
      '彰化': '04',
      '南投': '049',
      '雲林': '05',
      '嘉義': '05',
      '台南': '06',
      '高雄': '07',
      '屏東': '08',
      '台東': '089',
      '花蓮': '038',
      '宜蘭': '039',
      '澎湖': '06',
      '金門': '082',
      '馬祖': '0836',
    };

    final areaCode = random.element(areaCodes.values.toList());
    final firstPart = random.integer(min: 1000, max: 9999);
    final secondPart = random.integer(min: 1000, max: 9999);

    return '($areaCode) $firstPart-$secondPart';
  }

  /// Generates a Taiwan postal code (郵遞區號).
  ///
  /// Returns a 3-digit or 5-digit postal code
  String postalCode({bool fiveDigit = false}) {
    // Major city/county codes (3-digit)
    final codes = [
      '100', '103', '104', '105', '106', '108', '110', '111', '112', '114',
      '115', '116', // Taipei
      '200', '201', '202', '203', '204', '205', '206', // Keelung
      '207', '208', '220', '221', '222', '223', '224', '226', '227',
      '228', // New Taipei
      '231', '232', '233', '234', '235', '236', '237', '238', '239',
      '241', // New Taipei
      '242', '243', '244', '247', '248', '249', '251', '252',
      '253', // New Taipei
      '260', '261', '262', '263', '264', '265', '266', '267', '268', '269',
      '270', // Yilan
      '300', '302', '303', '304', '305', '306', '307', '308', // Hsinchu
      '310', '311', '312', '313', '314', '315', // Hsinchu County
      '320', '324', '325', '326', '327', '328', '330', '333', '334', '335',
      '336', '337', '338', // Taoyuan
      '350', '351', '352', '353', '354', '356', '357', '358', '360', '361',
      '362', '363', '364', '365', '366', '367', '368', '369', // Miaoli
      '400', '401', '402', '403', '404', '406', '407', '408', // Taichung
      '411', '412', '413', '414', '420', '421', '422', '423', '424', '426',
      '427', '428', '429', // Taichung
      '432', '433', '434', '435', '436', '437', '438', '439', // Taichung
      '500',
      '502',
      '503',
      '504',
      '505',
      '506',
      '507',
      '508',
      '509',
      '510',
      '511',
      '512',
      '513',
      '514',
      '515',
      '516',
      '520',
      '521',
      '522',
      '523',
      '524',
      '525',
      '526',
      '527',
      '528',
      '530', // Changhua
      '540', '541', '542', '544', '545', '546', '551', '552', '553', '555',
      '556', '557', '558', // Nantou
      '600', '602', '603', '604', '605', '606', '607', '608', // Chiayi
      '611', '612', '613', '614', '615', '616', '621', '622', '623', '624',
      '625', // Chiayi County
      '630',
      '631',
      '632',
      '633',
      '634',
      '635',
      '636',
      '637',
      '638',
      '640',
      '643',
      '646',
      '647',
      '648',
      '649',
      '651',
      '652',
      '653',
      '654',
      '655', // Yunlin
      '700',
      '701',
      '702',
      '704',
      '708',
      '709',
      '710',
      '711',
      '712',
      '713',
      '714',
      '715',
      '716',
      '717',
      '718',
      '719',
      '720',
      '721',
      '722',
      '723',
      '724',
      '725',
      '726',
      '727', // Tainan
      '730', '731', '732', '733', '734', '735', '736', '737', '741', '742',
      '743', '744', '745', // Tainan
      '800', '801', '802', '803', '804', '805', '806', '807', // Kaohsiung
      '811', '812', '813', '814', '815', '820', '821', '822', '823', '824',
      '825', '826', '827', '828', '829', // Kaohsiung
      '830', '831', '832', '833', '840', '842', '843', '844', '845', '846',
      '847', '848', '849', '851', '852', // Kaohsiung
      '880', '881', '882', '883', '884', '885', // Penghu
      '890', '891', '892', '893', '894', '896', // Kinmen
      '900', '901', '902', '903', '904', '905', '906', '907', '908', '909',
      '911', '912', '913', // Pingtung
      '920', '921', '922', '923', '924', '925', '926', '927', '928', '929',
      '931', '932', // Pingtung
      '940', '941', '942', '943', '944', '945', '946', '947', // Pingtung
      '950', '951', '952', '953', '954', '955', '956', '957', '958', '959',
      '961', '962', '963', '964', '965', '966', // Taitung
      '970', '971', '972', '973', '974', '975', '976', '977', '978', '979',
      '981', '982', '983', // Hualien
    ];

    final threeDigit = random.element(codes);

    if (fiveDigit) {
      final extra = random.integer(min: 10, max: 99);
      return '$threeDigit$extra';
    }

    return threeDigit;
  }

  /// Generates a Taiwan vehicle license plate number.
  ///
  /// Format varies by vehicle type
  String licensePlate({String? type}) {
    final vehicleType =
        type ?? random.element(['car', 'motorcycle', 'electric']);

    switch (vehicleType) {
      case 'motorcycle':
        // Format: ABC-123 or 123-ABC
        if (random.boolean()) {
          final letters = List.generate(
              3, (_) => String.fromCharCode(65 + random.nextInt(26))).join();
          final numbers = random.integer(min: 100, max: 999);
          return '$letters-$numbers';
        } else {
          final numbers = random.integer(min: 100, max: 999);
          final letters = List.generate(
              3, (_) => String.fromCharCode(65 + random.nextInt(26))).join();
          return '$numbers-$letters';
        }

      case 'electric':
        // Electric vehicle format: EAA-0001
        final letter1 = 'E';
        final letter2 = String.fromCharCode(65 + random.nextInt(26));
        final letter3 = String.fromCharCode(65 + random.nextInt(26));
        final numbers =
            random.integer(min: 1, max: 9999).toString().padLeft(4, '0');
        return '$letter1$letter2$letter3-$numbers';

      default: // car
        // Format: ABC-1234 or AB-1234
        final letterCount = random.element([2, 3]);
        final letters = List.generate(letterCount,
            (_) => String.fromCharCode(65 + random.nextInt(26))).join();
        final numbers = random.integer(min: 1000, max: 9999);
        return '$letters-$numbers';
    }
  }

  /// Generates a Taiwan bank account number.
  ///
  /// Format: Bank code (3 digits) + Branch code (4 digits) + Account number (6-14 digits)
  String bankAccount() {
    // Common Taiwan bank codes
    final bankCodes = [
      '004', // 臺灣銀行
      '005', // 土地銀行
      '006', // 合作金庫
      '007', // 第一銀行
      '008', // 華南銀行
      '009', // 彰化銀行
      '011', // 上海銀行
      '012', // 台北富邦
      '013', // 國泰世華
      '017', // 兆豐銀行
      '021', // 花旗銀行
      '048', // 王道銀行
      '050', // 臺灣企銀
      '052', // 渣打銀行
      '053', // 台中銀行
      '054', // 京城銀行
      '081', // 滙豐銀行
      '101', // 瑞興銀行
      '102', // 華泰銀行
      '103', // 台新銀行
      '108', // 陽信銀行
      '118', // 板信銀行
      '147', // 三信銀行
      '803', // 聯邦銀行
      '805', // 遠東銀行
      '806', // 元大銀行
      '807', // 永豐銀行
      '808', // 玉山銀行
      '809', // 凱基銀行
      '810', // 星展銀行
      '812', // 台新銀行
      '815', // 日盛銀行
      '816', // 安泰銀行
      '822', // 中國信託
    ];

    final bankCode = random.element(bankCodes);
    final branchCode = random.integer(min: 1000, max: 9999);
    final accountLength = random.integer(min: 10, max: 14);
    final accountNumber =
        List.generate(accountLength, (_) => random.nextInt(10)).join();

    return '$bankCode-$branchCode-$accountNumber';
  }

  /// Generates a Taiwan health insurance card number.
  ///
  /// Format: 2 letters + 8 digits
  String healthInsuranceNumber() {
    final letter1 = String.fromCharCode(65 + random.nextInt(26));
    final letter2 = String.fromCharCode(65 + random.nextInt(26));
    final digits = List.generate(8, (_) => random.nextInt(10)).join();

    return '$letter1$letter2$digits';
  }
}
