import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';
import 'package:intl/intl.dart';

class EcommerceDemoScreen extends StatefulWidget {
  const EcommerceDemoScreen({super.key});

  @override
  State<EcommerceDemoScreen> createState() => _EcommerceDemoScreenState();
}

class _EcommerceDemoScreenState extends State<EcommerceDemoScreen> {
  SmartFaker faker = SmartFaker(locale: 'en_US', seed: 12345);
  String _currentLocale = 'en_US';
  
  // Order data
  String _orderId = '';
  String _trackingNumber = '';
  String _orderStatus = '';
  DateTime _estimatedDelivery = DateTime.now();
  
  // Shipping & Payment
  String _shippingMethod = '';
  double _shippingCost = 0.0;
  String _paymentMethod = '';
  
  // Customer
  String _customerTier = '';
  int _loyaltyPoints = 0;
  
  // Products
  List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;
  
  // Promotions
  String _couponCode = '';
  int _discountPercentage = 0;
  String _giftCardCode = '';
  
  // Warehouse
  String _sku = '';
  String _warehouseLocation = '';
  String _inventoryStatus = '';
  
  // Review
  Map<String, dynamic> _review = {};
  
  // Invoice
  String _invoiceNumber = '';

  @override
  void initState() {
    super.initState();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      // Order
      _orderId = faker.ecommerce.orderId();
      _trackingNumber = faker.ecommerce.trackingNumber();
      _orderStatus = faker.ecommerce.orderStatus();
      _estimatedDelivery = faker.ecommerce.estimatedDelivery();
      
      // Shipping & Payment
      _shippingMethod = faker.ecommerce.shippingMethod();
      _shippingCost = faker.ecommerce.shippingCost();
      _paymentMethod = faker.ecommerce.paymentMethod();
      
      // Customer
      _customerTier = faker.ecommerce.customerTier();
      _loyaltyPoints = faker.ecommerce.loyaltyPoints();
      
      // Cart
      _cartItems = faker.ecommerce.cart(items: 4);
      _totalAmount = _cartItems.fold(0.0, (sum, item) => sum + (item['subtotal'] as double));
      
      // Promotions
      _couponCode = faker.ecommerce.couponCode();
      _discountPercentage = faker.ecommerce.discountPercentage();
      _giftCardCode = faker.ecommerce.giftCardCode();
      
      // Warehouse
      _sku = faker.ecommerce.sku();
      _warehouseLocation = faker.ecommerce.warehouseLocation();
      _inventoryStatus = faker.ecommerce.inventoryStatus();
      
      // Review
      _review = faker.ecommerce.review();
      
      // Invoice
      _invoiceNumber = faker.ecommerce.invoiceNumber();
    });
  }

  Widget _buildOrderCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(_orderStatus),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Order ID', _orderId),
            _buildInfoRow('Tracking', _trackingNumber),
            _buildInfoRow('Invoice', _invoiceNumber),
            _buildInfoRow('Est. Delivery', DateFormat('MMM dd, yyyy').format(_estimatedDelivery)),
            const Divider(height: 24),
            _buildInfoRow('Shipping', _shippingMethod),
            _buildInfoRow('Shipping Cost', '\$${_shippingCost.toStringAsFixed(2)}'),
            _buildInfoRow('Payment', _paymentMethod),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        color = Colors.green;
        break;
      case 'shipped':
      case 'processing':
        color = Colors.blue;
        break;
      case 'cancelled':
      case 'refunded':
      case 'returned':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }
    
    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCartCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shopping Cart',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._cartItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['product'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${item['category']} • Qty: ${item['quantity']}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${(item['subtotal'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '\$${_totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            if (_discountPercentage > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount ($_discountPercentage%)'),
                  Text(
                    '-\$${(_totalAmount * _discountPercentage / 100).toStringAsFixed(2)}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '\$${(_totalAmount * (1 - _discountPercentage / 100) + _shippingCost).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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

  Widget _buildCustomerCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Info',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricColumn('Tier', _customerTier, Icons.star),
                _buildMetricColumn('Points', _loyaltyPoints.toString(), Icons.card_giftcard),
                _buildMetricColumn('Discount', '$_discountPercentage%', Icons.local_offer),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPromotionsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Promotions & Codes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCodeRow('Coupon Code', _couponCode, Icons.local_offer),
            const SizedBox(height: 8),
            _buildCodeRow('Gift Card', _giftCardCode, Icons.card_giftcard),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeRow(String label, String code, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text('$label: '),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () => _copyToClipboard(code, label),
        ),
      ],
    );
  }

  Widget _buildWarehouseCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warehouse & Inventory',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('SKU', _sku),
            _buildInfoRow('Location', _warehouseLocation),
            _buildInfoRow('Status', _inventoryStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard() {
    final rating = (_review['rating'] as double?) ?? 0.0;
    final comment = (_review['comment'] as String?) ?? '';
    final helpful = (_review['helpful'] as int?) ?? 0;
    final verified = (_review['verified'] as bool?) ?? false;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product Review',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (verified)
                  Chip(
                    label: const Text('Verified'),
                    backgroundColor: Colors.green.withOpacity(0.2),
                    labelStyle: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(5, (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                )),
                const SizedBox(width: 8),
                Text('$rating', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment),
            const SizedBox(height: 8),
            Text(
              '$helpful people found this helpful',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          SelectableText(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _changeLocale(String locale) {
    setState(() {
      _currentLocale = locale;
      faker = SmartFaker(locale: locale, seed: 12345);
      _generateAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 E-commerce Module'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: _changeLocale,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en_US',
                child: Row(
                  children: [
                    Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('English'),
                    if (_currentLocale == 'en_US') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'zh_TW',
                child: Row(
                  children: [
                    Text('🇹🇼', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('繁體中文'),
                    if (_currentLocale == 'zh_TW') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ja_JP',
                child: Row(
                  children: [
                    Text('🇯🇵', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('日本語'),
                    if (_currentLocale == 'ja_JP') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateAll,
            tooltip: 'Generate New Data',
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildOrderCard(),
          _buildCartCard(),
          _buildCustomerCard(),
          _buildPromotionsCard(),
          _buildWarehouseCard(),
          _buildReviewCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}