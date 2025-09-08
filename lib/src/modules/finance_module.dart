import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating finance-related data.
class FinanceModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [FinanceModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of finance data.
  FinanceModule(this.random, this.localeManager);

  /// Gets the current locale code.
  String get currentLocale => localeManager.currentLocale;

  /// Generates a credit card number.
  String creditCardNumber() {
    final issuer = creditCardIssuer();
    String prefix;
    int length;

    switch (issuer) {
      case 'Visa':
        prefix = '4';
        length = 16;
        break;
      case 'Mastercard':
        prefix = '5${random.nextInt(5) + 1}';
        length = 16;
        break;
      case 'American Express':
        prefix = '3${random.element(['4', '7'])}';
        length = 15;
        break;
      case 'Discover':
        prefix = '6011';
        length = 16;
        break;
      default:
        prefix = '4';
        length = 16;
    }

    final remaining = length - prefix.length - 1;
    final middle =
        List.generate(remaining, (_) => random.nextInt(10).toString()).join();
    final withoutChecksum = prefix + middle;

    // Calculate Luhn checksum
    int sum = 0;
    bool alternate = false;
    for (int i = withoutChecksum.length - 1; i >= 0; i--) {
      int n = int.parse(withoutChecksum[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }
    final checksum = (10 - (sum % 10)) % 10;

    final fullNumber = withoutChecksum + checksum.toString();

    // Format with spaces
    final formatted = <String>[];
    for (int i = 0; i < fullNumber.length; i += 4) {
      final end = (i + 4 > fullNumber.length) ? fullNumber.length : i + 4;
      formatted.add(fullNumber.substring(i, end));
    }

    return formatted.join(' ');
  }

  /// Generates a credit card CVV.
  String creditCardCVV() {
    return random.nextInt(999).toString().padLeft(3, '0');
  }

  /// Generates a credit card issuer name.
  String creditCardIssuer() {
    final issuers = ['Visa', 'Mastercard', 'American Express', 'Discover'];
    return random.element(issuers);
  }

  /// Generates a masked credit card number.
  String maskedNumber() {
    final last4 = random.nextInt(9999).toString().padLeft(4, '0');
    return '**** **** **** $last4';
  }

  /// Generates a bank account number.
  String accountNumber() {
    // Generate in two parts to avoid overflow
    final part1 = random.nextInt(99999).toString().padLeft(5, '0');
    final part2 = random.nextInt(99999).toString().padLeft(5, '0');
    return part1 + part2;
  }

  /// Generates a routing number.
  String routingNumber() {
    // Generate valid routing number with checksum
    final firstTwo = random.nextInt(12) + 1; // 01-12
    final middle = random.nextInt(9999999);
    final base =
        '${firstTwo.toString().padLeft(2, '0')}${middle.toString().padLeft(7, '0')}';

    // Calculate checksum
    int sum = 0;
    final weights = [3, 7, 1, 3, 7, 1, 3, 7];
    for (int i = 0; i < 8; i++) {
      sum += int.parse(base[i]) * weights[i];
    }
    final checksum = (10 - (sum % 10)) % 10;

    return base.substring(0, 8) + checksum.toString();
  }

  /// Generates an IBAN.
  String iban() {
    final countryCode = random.element(['GB', 'DE', 'FR', 'IT', 'ES']);
    final checkDigits = random.nextInt(99).toString().padLeft(2, '0');
    final bankCode =
        random.string(length: 4, chars: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    final accountNumber = random.nextInt(999999).toString().padLeft(6, '0');
    final restLength = countryCode == 'GB' ? 8 : 10;
    final rest = random.nextInt(99999999).toString().padLeft(restLength, '0');

    return '$countryCode$checkDigits$bankCode$accountNumber$rest';
  }

  /// Generates a BIC/SWIFT code.
  String bic() {
    final bank = random.string(length: 4, chars: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    final country = random.element(['US', 'GB', 'DE', 'FR', 'JP']);
    final location =
        random.string(length: 2, chars: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');
    final branch = random.nextBool()
        ? random.string(
            length: 3, chars: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')
        : '';

    return '$bank$country$location$branch';
  }

  /// Generates a currency code.
  String currencyCode() {
    switch (currentLocale) {
      case 'zh_TW':
        return 'TWD';
      case 'ja_JP':
        return 'JPY';
      default:
        return 'USD';
    }
  }

  /// Generates a currency name.
  String currencyName() {
    switch (currentLocale) {
      case 'zh_TW':
        return '新台幣';
      case 'ja_JP':
        return '日本円';
      default:
        return 'US Dollar';
    }
  }

  /// Generates a currency symbol.
  String currencySymbol() {
    switch (currentLocale) {
      case 'zh_TW':
        return 'NT\$';
      case 'ja_JP':
        return '¥';
      default:
        return '\$';
    }
  }

  /// Generates an amount.
  double amount({double min = 1.0, double max = 10000.0, int decimals = 2}) {
    final value = random.decimal(min: min, max: max);
    final multiplier = Math.pow(10, decimals);
    return (value * multiplier).round() / multiplier;
  }

  /// Generates a Bitcoin address.
  String bitcoinAddress() {
    final prefix = random.element(['1', '3']);
    final chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
    final length = random.nextInt(10) + 25; // 25-34 characters
    final address =
        List.generate(length, (_) => chars[random.nextInt(chars.length)])
            .join();

    return '$prefix$address';
  }

  /// Generates an Ethereum address.
  String ethereumAddress() {
    final hex =
        List.generate(40, (_) => random.nextInt(16).toRadixString(16)).join();
    return '0x$hex';
  }

  /// Generates a cryptocurrency name.
  String cryptoCurrency() {
    final currencies = ['Bitcoin', 'Ethereum', 'Litecoin', 'Ripple'];
    return random.element(currencies);
  }

  /// Generates a transaction type.
  String transactionType() {
    final types = ['deposit', 'withdrawal', 'payment', 'transfer'];
    return random.element(types);
  }

  /// Generates a transaction description.
  String transactionDescription() {
    final type = transactionType();
    final descriptions = {
      'deposit': [
        'Direct deposit',
        'Cash deposit',
        'Check deposit',
        'Wire transfer deposit',
      ],
      'withdrawal': [
        'ATM withdrawal',
        'Counter withdrawal',
        'Online transfer',
      ],
      'payment': [
        'Online purchase',
        'Bill payment',
        'Subscription payment',
        'Service payment',
      ],
      'transfer': [
        'Account transfer',
        'Wire transfer',
        'International transfer',
        'P2P transfer',
      ],
    };

    return random.element(descriptions[type] ?? ['Transaction']);
  }

  /// Generates a transaction ID.
  String transactionId() {
    final hex = random.string(length: 12, chars: '0123456789ABCDEF');
    return 'TXN$hex';
  }
}

class Math {
  static double pow(num x, num exponent) {
    return x.toDouble() * (exponent > 1 ? pow(x, exponent - 1) : 1.0);
  }
}
