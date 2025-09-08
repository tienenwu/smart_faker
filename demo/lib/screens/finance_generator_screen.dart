import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class FinanceGeneratorScreen extends StatefulWidget {
  const FinanceGeneratorScreen({super.key});

  @override
  State<FinanceGeneratorScreen> createState() => _FinanceGeneratorScreenState();
}

class _FinanceGeneratorScreenState extends State<FinanceGeneratorScreen> {
  late SmartFaker faker;
  String currentLocale = 'en_US';
  
  // Credit card
  String creditCardNumber = '';
  String creditCardCVV = '';
  String creditCardIssuer = '';
  String maskedNumber = '';
  
  // Bank account
  String accountNumber = '';
  String routingNumber = '';
  String iban = '';
  String bic = '';
  
  // Currency
  String currencyCode = '';
  String currencyName = '';
  String currencySymbol = '';
  double amount = 0.0;
  String formattedAmount = '';
  
  // Cryptocurrency
  String bitcoinAddress = '';
  String ethereumAddress = '';
  String cryptoCurrency = '';
  
  // Transaction
  String transactionType = '';
  String transactionDescription = '';
  String transactionId = '';

  @override
  void initState() {
    super.initState();
    faker = SmartFaker(locale: currentLocale);
    _generateAllData();
  }

  void _setLocale(String locale) {
    setState(() {
      currentLocale = locale;
      faker.setLocale(locale);
      _generateAllData();
    });
  }

  void _generateAllData() {
    setState(() {
      // Credit card
      creditCardNumber = faker.finance.creditCardNumber();
      creditCardCVV = faker.finance.creditCardCVV();
      creditCardIssuer = faker.finance.creditCardIssuer();
      maskedNumber = faker.finance.maskedNumber();
      
      // Bank account
      accountNumber = faker.finance.accountNumber();
      routingNumber = faker.finance.routingNumber();
      iban = faker.finance.iban();
      bic = faker.finance.bic();
      
      // Currency
      currencyCode = faker.finance.currencyCode();
      currencyName = faker.finance.currencyName();
      currencySymbol = faker.finance.currencySymbol();
      amount = faker.finance.amount(min: 100, max: 10000);
      formattedAmount = '$currencySymbol${amount.toStringAsFixed(2)}';
      
      // Cryptocurrency
      bitcoinAddress = faker.finance.bitcoinAddress();
      ethereumAddress = faker.finance.ethereumAddress();
      cryptoCurrency = faker.finance.cryptoCurrency();
      
      // Transaction
      transactionType = faker.finance.transactionType();
      transactionDescription = faker.finance.transactionDescription();
      transactionId = faker.finance.transactionId();
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: currentLocale,
              underline: Container(),
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Theme.of(context).colorScheme.primary,
              items: const [
                DropdownMenuItem(
                  value: 'en_US',
                  child: Text('🇺🇸 English', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'zh_TW',
                  child: Text('🇹🇼 繁體中文', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'ja_JP',
                  child: Text('🇯🇵 日本語', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _setLocale(value);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCreditCardCard(),
          const SizedBox(height: 16),
          _buildBankAccountCard(),
          const SizedBox(height: 16),
          _buildCurrencyCard(),
          const SizedBox(height: 16),
          _buildCryptocurrencyCard(),
          const SizedBox(height: 16),
          _buildTransactionCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCreditCardCard() {
    return Card(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    creditCardIssuer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.credit_card, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                creditCardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CVV',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        creditCardCVV,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Masked',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        maskedNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankAccountCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bank Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Account Number', accountNumber),
            _buildField('Routing Number', routingNumber),
            _buildField('IBAN', iban),
            _buildField('BIC/SWIFT', bic),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Currency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Code', currencyCode),
            _buildField('Name', currencyName),
            _buildField('Symbol', currencySymbol),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sample Amount:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  formattedAmount,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptocurrencyCard() {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.currency_bitcoin,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Cryptocurrency',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildField('Currency', cryptoCurrency),
            _buildCryptoField('Bitcoin Address', bitcoinAddress),
            _buildCryptoField('Ethereum Address', ethereumAddress),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('ID', transactionId),
            _buildField('Type', transactionType),
            _buildField('Description', transactionDescription),
            const SizedBox(height: 8),
            _buildTransactionTypeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTypeIndicator() {
    Color indicatorColor;
    IconData icon;
    
    switch (transactionType) {
      case 'deposit':
        indicatorColor = Colors.green;
        icon = Icons.arrow_downward;
        break;
      case 'withdrawal':
        indicatorColor = Colors.orange;
        icon = Icons.arrow_upward;
        break;
      case 'payment':
        indicatorColor = Colors.blue;
        icon = Icons.payment;
        break;
      case 'transfer':
        indicatorColor = Colors.purple;
        icon = Icons.swap_horiz;
        break;
      default:
        indicatorColor = Colors.grey;
        icon = Icons.monetization_on;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: indicatorColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: indicatorColor, size: 16),
          const SizedBox(width: 6),
          Text(
            transactionType.toUpperCase(),
            style: TextStyle(
              color: indicatorColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _copyToClipboard(value, label),
              child: Text(
                value,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _copyToClipboard(value, label),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}