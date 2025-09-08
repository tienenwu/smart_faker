import 'package:smart_faker/smart_faker.dart';

void main() {
  // Basic usage
  basicUsage();
  
  // Localized data generation
  localizedDataGeneration();
  
  // Seeded data for reproducible results
  seededDataGeneration();
  
  // Schema-based generation
  schemaBasedGeneration();
  
  // Smart relationships
  smartRelationships();
  
  // Batch data generation
  batchDataGeneration();
}

/// Basic usage example
void basicUsage() {
  print('=== Basic Usage ===');
  final faker = SmartFaker();
  
  // Person data
  print('Name: ${faker.person.fullName()}');
  print('Email: ${faker.internet.email()}');
  print('Phone: ${faker.phone.number()}');
  print('Job: ${faker.person.jobTitle()}');
  
  // Address data
  print('Address: ${faker.location.streetAddress()}');
  print('City: ${faker.location.city()}');
  print('Country: ${faker.location.country()}');
  
  // Company data
  print('Company: ${faker.company.name()}');
  print('Industry: ${faker.company.industry()}');
  
  print('');
}

/// Generate data in different languages
void localizedDataGeneration() {
  print('=== Localized Data Generation ===');
  
  // English (default)
  final enFaker = SmartFaker(locale: 'en_US');
  print('English: ${enFaker.person.fullName()} - ${enFaker.company.name()}');
  
  // Traditional Chinese
  final zhFaker = SmartFaker(locale: 'zh_TW');
  print('Chinese: ${zhFaker.person.fullName()} - ${zhFaker.company.name()}');
  
  // Japanese
  final jaFaker = SmartFaker(locale: 'ja_JP');
  print('Japanese: ${jaFaker.person.fullName()} - ${jaFaker.company.name()}');
  
  print('');
}

/// Generate reproducible data with seeds
void seededDataGeneration() {
  print('=== Seeded Data Generation ===');
  
  // Same seed produces same results
  final faker1 = SmartFaker(seed: 12345);
  final faker2 = SmartFaker(seed: 12345);
  
  print('Faker1 Name: ${faker1.person.fullName()}');
  print('Faker2 Name: ${faker2.person.fullName()}');
  print('Names are identical: ${faker1.person.fullName() == faker2.person.fullName()}');
  
  print('');
}

/// Generate data using schemas
void schemaBasedGeneration() {
  print('=== Schema-based Generation ===');
  
  final faker = SmartFaker();
  final builder = SchemaBuilder(faker);
  
  // Define a user schema
  final userSchema = SchemaBuilder.defineSchema('User')
    .id()
    .withName()
    .withContact()
    .field('age', FakerFieldType.integer, min: 18, max: 65)
    .field('isActive', FakerFieldType.boolean)
    .withTimestamps()
    .build();
  
  // Register and generate
  builder.registerSchema(userSchema);
  final user = builder.generate('User');
  
  print('Generated User:');
  user.forEach((key, value) {
    print('  $key: $value');
  });
  
  print('');
}

/// Generate related data with smart relationships
void smartRelationships() {
  print('=== Smart Relationships ===');
  
  final faker = SmartFaker();
  final manager = RelationshipManager(faker);
  final relationshipBuilder = SmartRelationshipBuilder(
    manager: manager,
    faker: faker,
  );
  
  // Create a user with related posts (one-to-many)
  final userWithPosts = relationshipBuilder.oneToMany(
    parentSchema: 'User',
    childSchema: 'Post',
    parent: {
      'id': faker.random.uuid(),
      'name': faker.person.fullName(),
      'email': faker.internet.email(),
    },
    childrenGenerator: (parentId) => List.generate(3, (index) => {
      'id': faker.random.uuid(),
      'title': faker.lorem.sentence(),
      'content': faker.lorem.paragraph(),
      'authorId': parentId,
      'publishedAt': faker.dateTime.recent().toIso8601String(),
    }),
  );
  
  print('User: ${userWithPosts['parent']['name']}');
  print('Posts: ${(userWithPosts['children'] as List).length} posts created');
  
  print('');
}

/// Generate batch data for testing
void batchDataGeneration() {
  print('=== Batch Data Generation ===');
  
  final faker = SmartFaker(seed: 42); // Use seed for reproducibility
  
  // Generate multiple products
  final products = List.generate(5, (index) => {
    'id': faker.random.uuid(),
    'name': faker.commerce.productName(),
    'price': faker.commerce.price(min: 10, max: 1000),
    'category': faker.commerce.category(),
    'sku': faker.random.string(length: 8),
    'inStock': faker.random.boolean(),
    'rating': faker.random.integer(min: 1, max: 5),
  });
  
  print('Generated ${products.length} products:');
  for (var i = 0; i < products.length; i++) {
    final product = products[i];
    print('  ${i + 1}. ${product['name']} - \$${product['price']} (${product['category']})');
  }
  
  // Generate test users with consistent data
  final users = List.generate(3, (index) {
    final firstName = faker.person.firstName();
    final lastName = faker.person.lastName();
    final username = '${firstName.toLowerCase()}.${lastName.toLowerCase()}';
    
    return {
      'id': faker.random.uuid(),
      'firstName': firstName,
      'lastName': lastName,
      'fullName': '$firstName $lastName',
      'email': faker.internet.email(firstName: firstName, lastName: lastName),
      'username': username,
      'avatar': faker.image.avatar(),
      'phone': faker.phone.number(),
      'address': {
        'street': faker.location.streetAddress(),
        'city': faker.location.city(),
        'state': faker.location.state(),
        'zipCode': faker.location.zipCode(),
        'country': faker.location.country(),
      },
      'createdAt': faker.dateTime.past().toIso8601String(),
    };
  });
  
  print('\nGenerated ${users.length} users:');
  for (var user in users) {
    print('  - ${user['fullName']} (${user['email']})');
  }
}