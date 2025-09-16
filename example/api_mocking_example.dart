import 'package:smart_faker/smart_faker.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

void main() async {
  // Create SmartFaker instance
  final faker = SmartFaker(seed: 12345);

  // Example 1: Simple Mock Server
  await simpleMockServerExample(faker);

  // Example 2: Response Generator with Templates
  await responseGeneratorExample(faker);

  // Example 3: Stateful API with CRUD operations
  await statefulApiExample(faker);

  // Example 4: Error Simulation
  await errorSimulationExample(faker);
}

/// Example 1: Simple Mock Server
Future<void> simpleMockServerExample(SmartFaker faker) async {
  print('\n=== Example 1: Simple Mock Server ===\n');

  final mockServer = faker.createMockApi();

  // Register endpoints
  mockServer.get('/users', (request) {
    return List.generate(
        5,
        (_) => {
              'id': faker.datatype.uuid(),
              'name': faker.person.fullName(),
              'email': faker.internet.email(),
              'phone': faker.phone.phoneNumber(),
              'company': faker.company.name(),
            });
  });

  mockServer.get('/users/<id>', (request) {
    final id = request.params['id'];
    return {
      'id': id,
      'name': faker.person.fullName(),
      'email': faker.internet.email(),
      'bio': faker.person.bio(),
      'avatar': faker.image.avatar(),
      'address': {
        'street': faker.location.streetAddress(),
        'city': faker.location.city(),
        'country': faker.location.country(),
        'zipCode': faker.location.zipCode(),
      }
    };
  });

  // Start server
  final port = await mockServer.start();
  print('Mock server running on http://localhost:$port');
  print('Try: curl http://localhost:$port/users');

  // Keep server running for demo
  await Future.delayed(Duration(seconds: 2));
  await mockServer.stop();
}

/// Example 2: Response Generator with Templates
Future<void> responseGeneratorExample(SmartFaker faker) async {
  print('\n=== Example 2: Response Generator with Templates ===\n');

  final generator = ResponseGenerator(faker: faker);

  // Template for user data
  final userTemplate = {
    'id': '@uuid',
    'profile': {
      'name': '@person.fullName',
      'email': '@internet.email',
      'age': '@number.int.100',
      'bio': '@lorem.paragraph',
    },
    'settings': {
      'theme': '@randomChoice:light,dark',
      'notifications': '@boolean',
    },
    'createdAt': '@date.past',
    'tags': ['@array:3', '@lorem.word'],
  };

  // Generate data from template
  final userData = generator.generate(userTemplate);
  print('Generated User Data:');
  print(jsonEncode(userData));

  // Template for product listing
  final productTemplate = [
    '@array:10',
    {
      'id': '@uuid',
      'name': '@commerce.product',
      'price': '@commerce.price',
      'description': '@commerce.productDescription',
      'category': '@commerce.department',
      'inStock': '@boolean',
      'rating': '@number.double.5',
    }
  ];

  final products = generator.generate(productTemplate);
  print('\nGenerated Products:');
  print(jsonEncode(products).substring(0, 500) + '...');
}

/// Example 3: Stateful API with CRUD operations
Future<void> statefulApiExample(SmartFaker faker) async {
  print('\n=== Example 3: Stateful API with CRUD ===\n');

  final mockServer = faker.createMockApi();

  // Initialize with some users
  mockServer.state('users', <Map<String, dynamic>>[]);

  // GET all users
  mockServer.get('/api/users', (request) {
    return mockServer.state('users') ?? [];
  });

  // POST create user
  mockServer.post('/api/users', (request) async {
    final body = jsonDecode(await request.readAsString());
    final users =
        List<Map<String, dynamic>>.from(mockServer.state('users') ?? []);

    final newUser = {
      'id': faker.datatype.uuid(),
      'name': body['name'] ?? faker.person.fullName(),
      'email': body['email'] ?? faker.internet.email(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    users.add(newUser);
    mockServer.state('users', users);

    return newUser;
  });

  // PUT update user
  mockServer.put('/api/users/<id>', (request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final users =
        List<Map<String, dynamic>>.from(mockServer.state('users') ?? []);

    final index = users.indexWhere((u) => u['id'] == id);
    if (index != -1) {
      users[index] = {
        ...users[index],
        ...body,
        'updatedAt': DateTime.now().toIso8601String()
      };
      mockServer.state('users', users);
      return users[index];
    }

    return Response.notFound(jsonEncode({'error': 'User not found'}));
  });

  // DELETE user
  mockServer.delete('/api/users/<id>', (request) {
    final id = request.params['id'];
    final users =
        List<Map<String, dynamic>>.from(mockServer.state('users') ?? []);

    final initialLength = users.length;
    users.removeWhere((u) => u['id'] == id);
    mockServer.state('users', users);

    if (users.length < initialLength) {
      return {'success': true, 'deleted': id};
    }

    return Response.notFound(jsonEncode({'error': 'User not found'}));
  });

  final port = await mockServer.start();
  print('Stateful API running on http://localhost:$port');
  print('Endpoints:');
  print('  GET    /api/users      - List all users');
  print('  POST   /api/users      - Create user');
  print('  PUT    /api/users/:id  - Update user');
  print('  DELETE /api/users/:id  - Delete user');

  await Future.delayed(Duration(seconds: 2));
  await mockServer.stop();
}

/// Example 4: Error Simulation
Future<void> errorSimulationExample(SmartFaker faker) async {
  print('\n=== Example 4: Error Simulation ===\n');

  // Create server with error simulation
  final mockServer = faker.createMockApi(
    options: MockServerOptions(
      minDelay: 100, // Min 100ms delay
      maxDelay: 500, // Max 500ms delay
      errorRate: 0.2, // 20% chance of error
      defaultHeaders: {
        'X-API-Version': '1.0',
        'X-Mock-Server': 'SmartFaker',
      },
    ),
  );

  mockServer.get('/api/data', (request) {
    // This will randomly fail 20% of the time
    return {
      'data': faker.lorem.paragraph(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  });

  final port = await mockServer.start();
  print('Error simulation server on http://localhost:$port');
  print('20% of requests will randomly fail');
  print('Responses delayed 100-500ms');

  await Future.delayed(Duration(seconds: 2));
  await mockServer.stop();
}
