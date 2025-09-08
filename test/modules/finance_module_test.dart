import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('FinanceModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Credit Card', () {
      test('should generate credit card number', () {
        final cardNumber = faker.finance.creditCardNumber();
        expect(cardNumber, matches(RegExp(r'^\d{4} \d{4} \d{4} \d{4}$')));
      });

      test('should generate credit card CVV', () {
        final cvv = faker.finance.creditCardCVV();
        expect(cvv, matches(RegExp(r'^\d{3}$')));
      });

      test('should generate credit card issuer', () {
        final issuer = faker.finance.creditCardIssuer();
        expect(issuer, isNotEmpty);
        expect(['Visa', 'Mastercard', 'American Express', 'Discover'], 
          contains(issuer));
      });

      test('should generate masked credit card', () {
        final masked = faker.finance.maskedNumber();
        expect(masked, matches(RegExp(r'^\*{4} \*{4} \*{4} \d{4}$')));
      });
    });

    group('Bank Account', () {
      test('should generate account number', () {
        final account = faker.finance.accountNumber();
        expect(account, matches(RegExp(r'^\d{10}$')));
      });

      test('should generate routing number', () {
        final routing = faker.finance.routingNumber();
        expect(routing, matches(RegExp(r'^\d{9}$')));
      });

      test('should generate IBAN', () {
        final iban = faker.finance.iban();
        expect(iban, matches(RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]+$')));
      });

      test('should generate BIC/SWIFT code', () {
        final bic = faker.finance.bic();
        expect(bic, matches(RegExp(r'^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$')));
      });
    });

    group('Currency', () {
      test('should generate currency code', () {
        final code = faker.finance.currencyCode();
        expect(code, matches(RegExp(r'^[A-Z]{3}$')));
      });

      test('should generate currency name', () {
        final name = faker.finance.currencyName();
        expect(name, isNotEmpty);
      });

      test('should generate currency symbol', () {
        final symbol = faker.finance.currencySymbol();
        expect(symbol, isNotEmpty);
      });

      test('should generate amount', () {
        final amount = faker.finance.amount();
        expect(amount, greaterThan(0));
        expect(amount, lessThanOrEqualTo(10000));
      });

      test('should generate amount with custom range', () {
        final amount = faker.finance.amount(min: 100, max: 500);
        expect(amount, greaterThanOrEqualTo(100));
        expect(amount, lessThanOrEqualTo(500));
      });
    });

    group('Cryptocurrency', () {
      test('should generate bitcoin address', () {
        final address = faker.finance.bitcoinAddress();
        expect(address, matches(RegExp(r'^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$')));
      });

      test('should generate ethereum address', () {
        final address = faker.finance.ethereumAddress();
        expect(address, matches(RegExp(r'^0x[a-fA-F0-9]{40}$')));
      });

      test('should generate crypto currency', () {
        final crypto = faker.finance.cryptoCurrency();
        expect(crypto, isNotEmpty);
        expect(['Bitcoin', 'Ethereum', 'Litecoin', 'Ripple'], 
          contains(crypto));
      });
    });

    group('Transaction', () {
      test('should generate transaction type', () {
        final type = faker.finance.transactionType();
        expect(['deposit', 'withdrawal', 'payment', 'transfer'], 
          contains(type));
      });

      test('should generate transaction description', () {
        final description = faker.finance.transactionDescription();
        expect(description, isNotEmpty);
      });

      test('should generate transaction ID', () {
        final id = faker.finance.transactionId();
        expect(id, matches(RegExp(r'^TXN[0-9A-F]{12}$')));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English finance data', () {
        final faker = SmartFaker(locale: 'en_US');
        final currency = faker.finance.currencySymbol();
        
        expect(currency, equals('\$'));
      });

      test('should generate Traditional Chinese finance data', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final currency = faker.finance.currencySymbol();
        
        expect(currency, equals('NT\$'));
      });

      test('should generate Japanese finance data', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final currency = faker.finance.currencySymbol();
        
        expect(currency, equals('¥'));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible finance data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);
        
        expect(faker1.finance.creditCardNumber(), equals(faker2.finance.creditCardNumber()));
        expect(faker1.finance.amount(), equals(faker2.finance.amount()));
        expect(faker1.finance.bitcoinAddress(), equals(faker2.finance.bitcoinAddress()));
      });
    });
  });
}