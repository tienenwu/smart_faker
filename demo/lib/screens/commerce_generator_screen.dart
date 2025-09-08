import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class CommerceGeneratorScreen extends StatefulWidget {
  const CommerceGeneratorScreen({super.key});

  @override
  State<CommerceGeneratorScreen> createState() => _CommerceGeneratorScreenState();
}

class _CommerceGeneratorScreenState extends State<CommerceGeneratorScreen> {
  late SmartFaker faker;
  String currentLocale = 'en_US';
  
  // Product data
  String productName = '';
  String category = '';
  String department = '';
  String productMaterial = '';
  String productAdjective = '';
  String productDescription = '';
  
  // Price data
  double price = 0.0;
  String priceString = '';
  int discountPercentage = 0;
  double discountedPrice = 0.0;
  String discountedPriceString = '';
  
  // Codes
  String sku = '';
  String barcode = '';
  String isbn = '';
  
  // Colors
  String colorName = '';
  String hexColor = '';
  String rgbColor = '';
  
  // Store and Brand
  String storeName = '';
  String brandName = '';
  String companyType = '';

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
      // Product data
      productName = faker.commerce.productName();
      category = faker.commerce.category();
      department = faker.commerce.department();
      productMaterial = faker.commerce.productMaterial();
      productAdjective = faker.commerce.productAdjective();
      productDescription = faker.commerce.productDescription();
      
      // Price data
      price = faker.commerce.price(min: 10, max: 500);
      priceString = faker.commerce.priceString(min: 10, max: 500);
      discountPercentage = faker.commerce.discountPercentage();
      discountedPrice = price * (1 - discountPercentage / 100);
      
      // Format discounted price based on locale
      switch (currentLocale) {
        case 'zh_TW':
          discountedPriceString = 'NT\$${discountedPrice.toStringAsFixed(2)}';
          break;
        case 'ja_JP':
          discountedPriceString = '¥${discountedPrice.round()}';
          break;
        default:
          discountedPriceString = '\$${discountedPrice.toStringAsFixed(2)}';
      }
      
      // Codes
      sku = faker.commerce.sku();
      barcode = faker.commerce.barcode();
      isbn = faker.commerce.isbn();
      
      // Colors
      colorName = faker.commerce.color();
      hexColor = faker.commerce.hexColor();
      rgbColor = faker.commerce.rgbColor();
      
      // Store and Brand
      storeName = faker.commerce.storeName();
      brandName = faker.commerce.brand();
      companyType = faker.commerce.companyType();
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
        title: const Text('Commerce Generator'),
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
          _buildProductCard(),
          const SizedBox(height: 16),
          _buildPriceCard(),
          const SizedBox(height: 16),
          _buildCodesCard(),
          const SizedBox(height: 16),
          _buildColorCard(),
          const SizedBox(height: 16),
          _buildBrandCard(),
          const SizedBox(height: 16),
          _buildDescriptionCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildProductCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Product Name', productName),
            _buildField('Category', category),
            _buildField('Department', department),
            _buildField('Material', productMaterial),
            _buildField('Adjective', productAdjective),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pricing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Original Price', priceString),
            _buildField('Discount', '$discountPercentage%'),
            _buildField('Final Price', discountedPriceString),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: discountPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Codes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('SKU', sku),
            _buildField('Barcode (EAN-13)', barcode),
            _buildField('ISBN', isbn),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildField('Color Name', colorName),
                      _buildField('Hex Code', hexColor),
                      _buildField('RGB', rgbColor),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _hexToColor(hexColor),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Store & Brand',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Store', storeName),
            _buildField('Brand', brandName),
            _buildField('Company Type', companyType),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Product Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(productDescription, 'Description'),
                  tooltip: 'Copy to clipboard',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              productDescription,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
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

  Color _hexToColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}