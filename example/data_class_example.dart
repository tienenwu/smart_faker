import 'package:smart_faker/smart_faker.dart';

/// Example 1: Using factory constructor pattern
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final int age;
  final String? bio;
  final DateTime createdAt;
  final bool isActive;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.age,
    this.bio,
    required this.createdAt,
    required this.isActive,
  });

  /// Factory constructor to create a User with fake data
  factory User.fake({int? seed, String? locale}) {
    final faker = SmartFaker(seed: seed, locale: locale ?? 'en_US');
    return User(
      id: faker.random.uuid(),
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName(),
      email: faker.internet.email(),
      phone: faker.phone.number(),
      age: faker.random.integer(min: 18, max: 65),
      bio: faker.lorem.paragraph(),
      createdAt: faker.dateTime.past(),
      isActive: faker.random.boolean(),
    );
  }

  /// Generate a list of fake users
  static List<User> fakeList({required int count, int? seed}) {
    return List.generate(count, (_) => User.fake(seed: seed));
  }
}

/// Example 2: Using static factory method pattern
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String sku;
  final String category;
  final int stock;
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.sku,
    required this.category,
    required this.stock,
    required this.tags,
  });

  /// Static method to create Product with fake data
  static Product fromFaker(SmartFaker faker) {
    return Product(
      id: faker.random.uuid(),
      name: faker.commerce.productName(),
      description: faker.lorem.paragraph(),
      price: faker.commerce.price(min: 9.99, max: 999.99),
      sku: faker.commerce.sku(),
      category: faker.commerce.category(),
      stock: faker.random.integer(min: 0, max: 100),
      tags: List.generate(3, (_) => faker.lorem.word()),
    );
  }

  /// Generate fake product
  static Product fake({int? seed}) {
    final faker = SmartFaker(seed: seed);
    return fromFaker(faker);
  }

  /// Generate list of fake products
  static List<Product> fakeList({required int count, int? seed}) {
    final faker = SmartFaker(seed: seed);
    return List.generate(count, (_) => fromFaker(faker));
  }
}

/// Example 3: Using extension method for existing classes
class Order {
  final String id;
  final String customerId;
  final List<String> productIds;
  final double total;
  final String status;
  final DateTime orderDate;
  final String shippingAddress;

  const Order({
    required this.id,
    required this.customerId,
    required this.productIds,
    required this.total,
    required this.status,
    required this.orderDate,
    required this.shippingAddress,
  });
}

/// Extension to add fake data generation to Order
extension OrderFaker on Order {
  static Order fake({int? seed}) {
    final faker = SmartFaker(seed: seed);
    return Order(
      id: faker.random.uuid(),
      customerId: faker.random.uuid(),
      productIds: List.generate(
        faker.random.integer(min: 1, max: 5),
        (_) => faker.random.uuid(),
      ),
      total: faker.commerce.price(min: 10, max: 1000),
      status: faker.random
          .element(['pending', 'processing', 'shipped', 'delivered']),
      orderDate: faker.dateTime.recent(),
      shippingAddress: faker.location.streetAddress(),
    );
  }

  static List<Order> fakeList({required int count, int? seed}) {
    return List.generate(count, (_) => fake(seed: seed));
  }
}

/// Example 4: Using SchemaBuilder for complex relationships
void schemaBuilderExample() {
  final faker = SmartFaker();
  final schemaBuilder = SchemaBuilder(faker);

  // Define User schema
  final userSchema = SchemaBuilder.defineSchema('User')
      .id()
      .withName()
      .withContact()
      .field('age', FakerFieldType.integer, min: 18, max: 65)
      .field('bio', FakerFieldType.paragraph, required: false)
      .withTimestamps()
      .build();

  // Define Product schema
  final productSchema = SchemaBuilder.defineSchema('Product')
      .id()
      .field('name', FakerFieldType.productName)
      .field('price', FakerFieldType.price, min: 9.99, max: 999.99)
      .field('description', FakerFieldType.paragraph)
      .withTimestamps()
      .build();

  // Define Order schema with relationships
  final orderSchema = SchemaBuilder.defineSchema('Order')
      .id()
      .belongsTo('userId', 'User')
      .hasMany('products', 'Product')
      .field('total', FakerFieldType.amount)
      .field('status', FakerFieldType.word)
      .withTimestamps()
      .build();

  // Register schemas
  schemaBuilder.registerSchema(userSchema);
  schemaBuilder.registerSchema(productSchema);
  schemaBuilder.registerSchema(orderSchema);

  // Generate data with relationships
  final order = schemaBuilder.generate('Order');
  print(order);
}

void main() {
  // Example 1: Generate single user
  final user = User.fake();
  print('User: ${user.firstName} ${user.lastName} - ${user.email}');

  // Example 2: Generate list of products
  final products = Product.fakeList(count: 5);
  for (final product in products) {
    print('Product: ${product.name} - \$${product.price}');
  }

  // Example 3: Generate order using extension
  final order = OrderFaker.fake();
  print('Order: ${order.id} - Total: \$${order.total}');

  // Example 4: Use SchemaBuilder
  schemaBuilderExample();

  // Example 5: Reproducible data with seed
  final user1 = User.fake(seed: 42);
  final user2 = User.fake(seed: 42);
  print('Same users: ${user1.email == user2.email}'); // true
}
