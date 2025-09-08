import 'package:smart_faker/smart_faker.dart';

void main() {
  final faker = SmartFaker(locale: 'zh_TW');
  final builder = SchemaBuilder(faker);

  // Example 1: User schema with regex patterns for validation
  final userSchema = SchemaDefinitionBuilder('User')
      .id()
      .field(
        'taiwanId',
        FakerFieldType.custom,
        pattern: r'^[A-Z][12]\d{8}$', // Taiwan ID pattern
        validator: FieldValidators.taiwanId,
        validationMessage: 'Invalid Taiwan ID format',
      )
      .field(
        'email',
        FakerFieldType.email,
        validator: FieldValidators.email,
        validationMessage: 'Invalid email format',
      )
      .field(
        'phone',
        FakerFieldType.custom,
        pattern: r'^09\d{8}$', // Taiwan mobile pattern
        validator: FieldValidators.regex(r'^09\d{8}$'),
      )
      .field(
        'username',
        FakerFieldType.username,
        validator: FieldValidators.length(min: 3, max: 20),
        validationMessage: 'Username must be 3-20 characters',
      )
      .field(
        'age',
        FakerFieldType.integer,
        min: 18,
        max: 65,
        validator: FieldValidators.range(min: 18, max: 65),
      )
      .withTimestamps()
      .build();

  // Example 2: Product schema with SKU pattern
  final productSchema = SchemaDefinitionBuilder('Product')
      .id()
      .field(
        'sku',
        FakerFieldType.custom,
        pattern: r'^PRD-[A-Z]{3}-\d{4}$', // Custom SKU pattern
        validator: FieldValidators.fromPattern(r'^PRD-[A-Z]{3}-\d{4}$'),
      )
      .field(
        'barcode',
        FakerFieldType.custom,
        pattern: r'^\d{13}$', // EAN-13 barcode
        validator: FieldValidators.length(exact: 13),
      )
      .field(
        'price',
        FakerFieldType.price,
        min: 0.99,
        max: 9999.99,
        validator: FieldValidators.range(min: 0.99, max: 9999.99),
      )
      .field(
        'productName',
        FakerFieldType.productName,
      )
      .field(
        'category',
        FakerFieldType.custom,
        validator: FieldValidators.inList(['Electronics', 'Clothing', 'Food', 'Books']),
        defaultValue: 'Electronics',
      )
      .build();

  // Example 3: Order schema with complex validation
  final orderSchema = SchemaDefinitionBuilder('Order')
      .field(
        'orderNumber',
        FakerFieldType.custom,
        pattern: r'^ORD-2025-\d{6}$', // Order number pattern for 2025
        validator: FieldValidators.fromPattern(r'^ORD-2025-\d{6}$'),
      )
      .field(
        'invoiceNumber',
        FakerFieldType.custom,
        pattern: r'^[A-Z]{2}-\d{8}$', // Taiwan invoice pattern
      )
      .field(
        'trackingNumber',
        FakerFieldType.custom,
        pattern: r'^[A-Z]{2}\d{9}[A-Z]{2}$', // International tracking
      )
      .field(
        'status',
        FakerFieldType.custom,
        validator: FieldValidators.inList(['pending', 'processing', 'shipped', 'delivered']),
        defaultValue: 'pending',
      )
      .field(
        'paymentMethod',
        FakerFieldType.custom,
        validator: FieldValidators.inList(['credit_card', 'paypal', 'bank_transfer']),
      )
      .field(
        'creditCard',
        FakerFieldType.custom,
        pattern: r'^4\d{15}$', // Visa card pattern
        validator: FieldValidators.combine([
          FieldValidators.creditCard,
          FieldValidators.regex(r'^4'), // Must start with 4 (Visa)
        ]),
      )
      .withTimestamps()
      .build();

  // Example 4: Network configuration schema
  final networkSchema = SchemaDefinitionBuilder('NetworkConfig')
      .field(
        'ipAddress',
        FakerFieldType.custom,
        pattern: r'^192\.168\.\d{1,3}\.\d{1,3}$', // Local network IP
        validator: FieldValidators.ipv4,
      )
      .field(
        'macAddress',
        FakerFieldType.custom,
        pattern: FieldPatterns.macAddress,
        validator: FieldValidators.macAddress,
      )
      .field(
        'hostname',
        FakerFieldType.custom,
        pattern: r'^[a-z]{3,8}-srv-\d{3}$', // Server hostname pattern
        validator: FieldValidators.regex(r'^[a-z]{3,8}-srv-\d{3}$'),
      )
      .field(
        'port',
        FakerFieldType.integer,
        min: 1024,
        max: 65535,
        validator: FieldValidators.range(min: 1024, max: 65535),
      )
      .build();

  // Register schemas
  builder.registerSchema(userSchema);
  builder.registerSchema(productSchema);
  builder.registerSchema(orderSchema);
  builder.registerSchema(networkSchema);

  // Generate and display data
  print('=== User with Taiwan ID Validation ===');
  final user = builder.generate('User');
  print('Taiwan ID: ${user['taiwanId']}');
  print('Email: ${user['email']}');
  print('Phone: ${user['phone']}');
  print('Username: ${user['username']}');
  print('Age: ${user['age']}');
  print('');

  print('=== Product with SKU Pattern ===');
  final product = builder.generate('Product');
  print('SKU: ${product['sku']}');
  print('Barcode: ${product['barcode']}');
  print('Product: ${product['productName']}');
  print('Price: \$${product['price']}');
  print('Category: ${product['category']}');
  print('');

  print('=== Order with Complex Validation ===');
  final order = builder.generate('Order');
  print('Order #: ${order['orderNumber']}');
  print('Invoice: ${order['invoiceNumber']}');
  print('Tracking: ${order['trackingNumber']}');
  print('Status: ${order['status']}');
  print('Payment: ${order['paymentMethod']}');
  if (order['paymentMethod'] == 'credit_card') {
    print('Card: ${order['creditCard']}');
  }
  print('');

  print('=== Network Configuration ===');
  final network = builder.generate('NetworkConfig');
  print('IP: ${network['ipAddress']}');
  print('MAC: ${network['macAddress']}');
  print('Hostname: ${network['hostname']}');
  print('Port: ${network['port']}');
  print('');

  // Generate multiple users with validation
  print('=== Generating 5 Users with Validation ===');
  final users = builder.generateList('User', count: 5);
  for (int i = 0; i < users.length; i++) {
    final u = users[i];
    print('${i + 1}. ${u['username']} - ${u['taiwanId']} - ${u['phone']}');
  }
}