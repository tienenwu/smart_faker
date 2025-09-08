import 'package:smart_faker/smart_faker.dart';

// ============================================
// Example 1: Simplest approach - Add factory constructor directly in class
// ============================================
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final DateTime createdAt;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.createdAt,
  });
  
  // Add this to generate fake data!
  factory User.fake() {
    final faker = SmartFaker();
    return User(
      id: faker.random.uuid(),
      name: faker.person.fullName(),
      email: faker.internet.email(),
      age: faker.random.integer(min: 18, max: 65),
      createdAt: faker.dateTime.past(),
    );
  }
  
  // Can also add batch generation
  static List<User> fakeList(int count) {
    return List.generate(count, (_) => User.fake());
  }
}

// ============================================
// Example 2: Don't want to modify original class? Use Extension
// ============================================
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
  });
}

// Use extension to add fake functionality
extension ProductFaker on Product {
  static Product fake() {
    final faker = SmartFaker();
    return Product(
      id: faker.random.uuid(),
      name: faker.commerce.productName(),
      description: faker.lorem.paragraph(),
      price: faker.commerce.price(min: 9.99, max: 999.99),
      category: faker.commerce.category(),
      stock: faker.random.integer(min: 0, max: 100),
    );
  }
}

// ============================================
// Example 3: Need related data? Use SchemaBuilder
// ============================================
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime orderDate;
  
  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.orderDate,
  });
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;
  
  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });
}

// ============================================
// Usage Examples
// ============================================
void main() {
  print('=== Example 1: Using factory constructor ===');
  // Generate a fake user
  final user = User.fake();
  print('User: ${user.name} (${user.email})');
  print('Age: ${user.age}');
  print('Created: ${user.createdAt}');
  
  // Generate multiple fake users
  final users = User.fakeList(3);
  print('\nGenerated ${users.length} users:');
  for (final u in users) {
    print('  - ${u.name}: ${u.email}');
  }
  
  print('\n=== Example 2: Using Extension ===');
  // Generate fake product
  final product = ProductFaker.fake();
  print('Product: ${product.name}');
  print('Price: \$${product.price.toStringAsFixed(2)}');
  print('Stock: ${product.stock}');
  
  print('\n=== Example 3: Using SchemaBuilder ===');
  final faker = SmartFaker();
  final builder = SchemaBuilder(faker);
  
  // Define User schema
  final userSchema = SchemaBuilder.defineSchema('User')
    .field('id', FakerFieldType.uuid)
    .field('name', FakerFieldType.fullName)
    .field('email', FakerFieldType.email)
    .field('age', FakerFieldType.integer, min: 18, max: 65)
    .withTimestamps()
    .build();
  
  // Define Product schema
  final productSchema = SchemaBuilder.defineSchema('Product')
    .field('id', FakerFieldType.uuid)
    .field('name', FakerFieldType.productName)
    .field('price', FakerFieldType.price, min: 10, max: 1000)
    .field('stock', FakerFieldType.integer, min: 0, max: 100)
    .build();
  
  // Define Order schema (with relationships)
  final orderSchema = SchemaBuilder.defineSchema('Order')
    .field('id', FakerFieldType.uuid)
    .belongsTo('userId', 'User')  // Related to User
    .hasMany('products', 'Product')  // Related to multiple Products
    .field('total', FakerFieldType.amount, min: 10, max: 5000)
    .field('status', FakerFieldType.word)
    .withTimestamps()
    .build();
  
  // Register all schemas
  builder.registerSchema(userSchema);
  builder.registerSchema(productSchema);
  builder.registerSchema(orderSchema);
  
  // Generate order data with relationships
  final orderData = builder.generate('Order');
  print('Order ID: ${orderData['id']}');
  print('User ID: ${orderData['userId']}');
  print('Products: ${(orderData['products'] as List).length} items');
  print('Total: \$${orderData['total']}');
  
  print('\n=== Example 4: Specify locale ===');
  // Generate Chinese data
  final chineseFaker = SmartFaker(locale: 'zh_TW');
  print('Chinese name: ${chineseFaker.person.fullName()}');
  print('Chinese address: ${chineseFaker.location.streetAddress()}');
  print('Chinese company: ${chineseFaker.company.name()}');
  
  // Generate Japanese data
  final japaneseFaker = SmartFaker(locale: 'ja_JP');
  print('Japanese name: ${japaneseFaker.person.fullName()}');
  print('Japanese address: ${japaneseFaker.location.streetAddress()}');
  
  print('\n=== Example 5: Reproducible data (using seed) ===');
  // Using the same seed produces identical data
  final faker1 = SmartFaker(seed: 42);
  final faker2 = SmartFaker(seed: 42);
  
  print('Faker1 name: ${faker1.person.fullName()}');
  print('Faker2 name: ${faker2.person.fullName()}');
  print('Are they the same? ${faker1.person.fullName() == faker2.person.fullName()}');
}

// ============================================
// Practical Application: Test Data
// ============================================
class TestDataGenerator {
  static void generateTestData() {
    // Generate fake data for testing
    final testUsers = User.fakeList(10);
    final testProducts = List.generate(20, (_) => ProductFaker.fake());
    
    // For API testing
    final mockApiResponse = {
      'users': testUsers.map((u) => {
        'id': u.id,
        'name': u.name,
        'email': u.email,
      }).toList(),
      'products': testProducts.map((p) => {
        'id': p.id,
        'name': p.name,
        'price': p.price,
      }).toList(),
    };
    
    print('Generated ${testUsers.length} users for testing');
    print('Generated ${testProducts.length} products for testing');
  }
}