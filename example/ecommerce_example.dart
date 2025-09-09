import 'package:smart_faker/smart_faker.dart';
import 'package:intl/intl.dart';

void main() {
  final faker = SmartFaker(seed: 12345);

  print('🛒 E-commerce Data Generation Examples');
  print('=' * 60);

  // Order Information
  print('\n📦 Order Information:');
  print('Order ID: ${faker.ecommerce.orderId()}');
  print('Tracking: ${faker.ecommerce.trackingNumber()}');
  print('Status: ${faker.ecommerce.orderStatus()}');
  print('Invoice: ${faker.ecommerce.invoiceNumber()}');
  final delivery = faker.ecommerce.estimatedDelivery();
  print('Est. Delivery: ${DateFormat('MMM dd, yyyy').format(delivery)}');

  // Shipping & Payment
  print('\n🚚 Shipping & Payment:');
  print('Shipping Method: ${faker.ecommerce.shippingMethod()}');
  print(
      'Shipping Cost: \$${faker.ecommerce.shippingCost().toStringAsFixed(2)}');
  print('Payment Method: ${faker.ecommerce.paymentMethod()}');

  // Shopping Cart
  print('\n🛍️ Shopping Cart:');
  final cart = faker.ecommerce.cart(items: 3);
  double total = 0;
  for (final item in cart) {
    print('  ${item['product']}:');
    print('    Category: ${item['category']}');
    print('    Price: \$${item['price']}');
    print('    Quantity: ${item['quantity']}');
    print('    Subtotal: \$${item['subtotal']}');
    total += item['subtotal'] as double;
  }
  print('Cart Total: \$${total.toStringAsFixed(2)}');

  // Promotions
  print('\n🎁 Promotions:');
  print('Coupon Code: ${faker.ecommerce.couponCode()}');
  print('Discount: ${faker.ecommerce.discountPercentage()}%');
  print('Gift Card: ${faker.ecommerce.giftCardCode()}');

  // Customer Information
  print('\n👤 Customer:');
  print('Tier: ${faker.ecommerce.customerTier()}');
  print('Loyalty Points: ${faker.ecommerce.loyaltyPoints()}');
  final wishlist = faker.ecommerce.wishlist(items: 3);
  print('Wishlist: ${wishlist.join(', ')}');

  // Warehouse & Inventory
  print('\n📦 Warehouse:');
  print('SKU: ${faker.ecommerce.sku()}');
  print('Location: ${faker.ecommerce.warehouseLocation()}');
  print('Inventory Status: ${faker.ecommerce.inventoryStatus()}');

  // Product Review
  print('\n⭐ Product Review:');
  final review = faker.ecommerce.review();
  print('Rating: ${review['rating']} stars');
  print('Comment: ${review['comment']}');
  print('Helpful votes: ${review['helpful']}');
  print('Verified: ${review['verified'] ? 'Yes' : 'No'}');

  // Generate Multiple Orders
  print('\n📊 Order Batch Generation:');
  print('-' * 40);

  final orders = List.generate(5, (index) {
    final items = faker.ecommerce.cart(items: 2);
    final subtotal = items.fold<double>(
        0.0, (sum, item) => sum + (item['subtotal'] as double? ?? 0.0));
    final shipping = faker.ecommerce.shippingCost();

    return {
      'orderId': faker.ecommerce.orderId(),
      'customer': faker.person.fullName(),
      'status': faker.ecommerce.orderStatus(),
      'items': items.length,
      'subtotal': subtotal,
      'shipping': shipping,
      'total': subtotal + shipping,
      'payment': faker.ecommerce.paymentMethod(),
    };
  });

  for (final order in orders) {
    print('Order ${order['orderId']}:');
    print('  Customer: ${order['customer']}');
    print('  Status: ${order['status']}');
    print('  Items: ${order['items']}');
    print('  Total: \$${(order['total'] as double).toStringAsFixed(2)}');
    print('  Payment: ${order['payment']}');
    print('');
  }

  // Return Process
  print('🔄 Return Process:');
  print('Return Reason: ${faker.ecommerce.returnReason()}');
  print('Return ID: RET-${faker.random.integer(min: 100000, max: 999999)}');
  print('Refund Status: Processing');

  print('\n✨ E-commerce module examples completed!');
}
