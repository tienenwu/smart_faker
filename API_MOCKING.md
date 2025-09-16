# API Mocking with SmartFaker

SmartFaker provides a powerful built-in mock server for creating realistic API endpoints during development and testing. This feature helps you develop and test your Flutter applications without depending on real backend services.

## Features

- 🚀 **Built-in HTTP Server**: Lightweight mock server using Shelf
- 📝 **Response Templates**: Define dynamic response structures
- 💾 **Stateful Operations**: Support for CRUD with in-memory storage
- ⏱️ **Network Simulation**: Configurable delays and error rates
- 🔄 **Dynamic Data**: Generate fresh data on each request
- 🎯 **Path Parameters**: Support for RESTful routing

## Quick Start

### Basic Mock Server

```dart
import 'package:smart_faker/smart_faker.dart';

void main() async {
  final faker = SmartFaker();
  final mockServer = faker.createMockApi();

  // Register a simple endpoint
  mockServer.get('/users', (request) {
    return List.generate(10, (_) => {
      'id': faker.datatype.uuid(),
      'name': faker.person.fullName(),
      'email': faker.internet.email(),
    });
  });

  // Start the server
  final port = await mockServer.start(port: 8080);
  print('Mock server running on http://localhost:$port');
}
```

## Response Templates

Use the ResponseGenerator to create dynamic responses from templates:

```dart
final generator = ResponseGenerator(faker: faker);

// Define a template with faker directives
final userTemplate = {
  'id': '@uuid',
  'profile': {
    'name': '@person.fullName',
    'email': '@internet.email',
    'age': '@number.int.100',
    'avatar': '@image.avatar',
  },
  'createdAt': '@date.past',
  'isActive': '@boolean',
};

// Generate data from template
mockServer.get('/user', (request) {
  return generator.generate(userTemplate);
});
```

### Supported Directives

| Directive | Description | Example |
|-----------|-------------|---------|
| `@uuid` | Generate UUID | `"550e8400-e29b-..."` |
| `@person.fullName` | Full name | `"John Doe"` |
| `@internet.email` | Email address | `"john@example.com"` |
| `@number.int.100` | Integer (max 100) | `42` |
| `@number.double.100` | Float (max 100) | `42.37` |
| `@boolean` | Boolean value | `true` |
| `@date.past` | Past date | `"2023-06-15T..."` |
| `@date.future` | Future date | `"2025-01-20T..."` |
| `@lorem.sentence` | Lorem sentence | `"Lorem ipsum..."` |
| `@lorem.paragraph` | Lorem paragraph | `"Lorem ipsum..."` |
| `@commerce.product` | Product name | `"Laptop"` |
| `@commerce.price` | Price string | `"29.99"` |
| `@image.url` | Image URL | `"https://..."` |
| `@array:N` | Generate N items | Array of N elements |

### Array Generation

Generate arrays with the `@array` directive:

```dart
final productsTemplate = [
  '@array:20',  // Generate 20 items
  {
    'id': '@uuid',
    'name': '@commerce.product',
    'price': '@commerce.price',
    'inStock': '@boolean',
  }
];

mockServer.get('/products', (request) {
  return generator.generate(productsTemplate);
});
```

## Stateful API with CRUD

Create a stateful API that maintains data between requests:

```dart
final mockServer = faker.createMockApi();

// Initialize state store
mockServer.state('users', []);

// GET all users
mockServer.get('/api/users', (request) {
  return mockServer.state('users');
});

// POST create user
mockServer.post('/api/users', (request) async {
  final body = jsonDecode(await request.readAsString());
  final users = List.from(mockServer.state('users'));

  final newUser = {
    'id': faker.datatype.uuid(),
    ...body,
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
  final users = List.from(mockServer.state('users'));

  final index = users.indexWhere((u) => u['id'] == id);
  if (index != -1) {
    users[index] = {...users[index], ...body};
    mockServer.state('users', users);
    return users[index];
  }

  return Response.notFound('User not found');
});

// DELETE user
mockServer.delete('/api/users/<id>', (request) {
  final id = request.params['id'];
  final users = List.from(mockServer.state('users'));

  users.removeWhere((u) => u['id'] == id);
  mockServer.state('users', users);

  return {'success': true};
});
```

## Network Simulation

Simulate real network conditions with delays and errors:

```dart
final mockServer = faker.createMockApi(
  options: MockServerOptions(
    minDelay: 100,      // Minimum 100ms delay
    maxDelay: 500,      // Maximum 500ms delay
    errorRate: 0.1,     // 10% chance of error
    defaultHeaders: {
      'X-API-Version': '1.0',
      'X-Mock-Server': 'SmartFaker',
    },
  ),
);

// Responses will have random delays and occasional errors
mockServer.get('/api/data', (request) {
  return {
    'data': faker.lorem.paragraph(),
    'timestamp': DateTime.now().toIso8601String(),
  };
});
```

### Error Types

When `errorRate` is configured, the server randomly returns:
- `500 Internal Server Error`
- `404 Not Found`
- `408 Request Timeout`
- `429 Too Many Requests`

## Path Parameters

Support for RESTful path parameters:

```dart
// Single parameter
mockServer.get('/users/<id>', (request) {
  final userId = request.params['id'];
  return {
    'id': userId,
    'name': faker.person.fullName(),
    'email': faker.internet.email(),
  };
});

// Multiple parameters
mockServer.get('/posts/<postId>/comments/<commentId>', (request) {
  final postId = request.params['postId'];
  final commentId = request.params['commentId'];
  return {
    'postId': postId,
    'commentId': commentId,
    'content': faker.lorem.paragraph(),
  };
});
```

## Integration with Flutter

### Using with Dio

```dart
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  late final MockServer _mockServer;

  ApiService() {
    _setupMockServer();
  }

  Future<void> _setupMockServer() async {
    final faker = SmartFaker();
    _mockServer = faker.createMockApi();

    // Register endpoints
    _mockServer.get('/api/users', (request) {
      return List.generate(10, (_) => User.fake());
    });

    // Start server
    final port = await _mockServer.start();

    // Configure Dio to use mock server
    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:$port',
    ));
  }

  Future<List<User>> getUsers() async {
    final response = await _dio.get('/api/users');
    return (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
}
```

### Using with http package

```dart
import 'package:http/http.dart' as http;

class ApiClient {
  late final String baseUrl;
  late final MockServer _mockServer;

  Future<void> initialize() async {
    final faker = SmartFaker();
    _mockServer = faker.createMockApi();

    // Setup endpoints
    _mockServer.get('/api/products', (request) {
      return faker.commerce.generateProducts(20);
    });

    final port = await _mockServer.start();
    baseUrl = 'http://localhost:$port';
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }

    throw Exception('Failed to load products');
  }
}
```

## Testing with Mock Server

### Widget Testing

```dart
testWidgets('displays user list from API', (tester) async {
  // Setup mock server
  final faker = SmartFaker(seed: 12345);
  final mockServer = faker.createMockApi();

  mockServer.get('/api/users', (request) {
    return [
      {'id': '1', 'name': 'Alice', 'email': 'alice@test.com'},
      {'id': '2', 'name': 'Bob', 'email': 'bob@test.com'},
    ];
  });

  final port = await mockServer.start();

  // Configure app to use mock server
  final app = MyApp(apiUrl: 'http://localhost:$port');

  await tester.pumpWidget(app);
  await tester.pumpAndSettle();

  // Verify UI displays data
  expect(find.text('Alice'), findsOneWidget);
  expect(find.text('Bob'), findsOneWidget);

  // Cleanup
  await mockServer.stop();
});
```

### Integration Testing

```dart
test('user registration flow', () async {
  final faker = SmartFaker();
  final mockServer = faker.createMockApi();

  // Setup stateful registration endpoint
  mockServer.state('users', []);

  mockServer.post('/api/register', (request) async {
    final body = jsonDecode(await request.readAsString());

    // Validate input
    if (!body.containsKey('email')) {
      return Response.badRequest(body: 'Email required');
    }

    final users = List.from(mockServer.state('users'));

    // Check for duplicates
    if (users.any((u) => u['email'] == body['email'])) {
      return Response.conflict(body: 'Email already exists');
    }

    // Create user
    final user = {
      'id': faker.datatype.uuid(),
      'email': body['email'],
      'createdAt': DateTime.now().toIso8601String(),
    };

    users.add(user);
    mockServer.state('users', users);

    return user;
  });

  final port = await mockServer.start();
  final client = ApiClient('http://localhost:$port');

  // Test registration
  final result = await client.register('test@example.com');
  expect(result.email, 'test@example.com');

  // Test duplicate prevention
  expect(
    () => client.register('test@example.com'),
    throwsA(isA<ConflictException>()),
  );

  await mockServer.stop();
});
```

## Best Practices

### 1. Use Seeding for Reproducible Tests

```dart
// Always use the same seed in tests for reproducibility
final faker = SmartFaker(seed: 12345);
final mockServer = faker.createMockApi();
```

### 2. Clean Up Resources

```dart
setUp(() async {
  mockServer = SmartFaker().createMockApi();
  await mockServer.start();
});

tearDown(() async {
  await mockServer.stop();
});
```

### 3. Organize Mock Definitions

```dart
class MockApiDefinitions {
  static void setupUserEndpoints(MockServer server, SmartFaker faker) {
    server.get('/users', (request) => ...);
    server.post('/users', (request) => ...);
    // etc.
  }

  static void setupProductEndpoints(MockServer server, SmartFaker faker) {
    server.get('/products', (request) => ...);
    // etc.
  }
}

// Usage
final mockServer = faker.createMockApi();
MockApiDefinitions.setupUserEndpoints(mockServer, faker);
MockApiDefinitions.setupProductEndpoints(mockServer, faker);
```

### 4. Environment-based Configuration

```dart
class ApiConfig {
  static String get baseUrl {
    if (kDebugMode) {
      // Use mock server in debug mode
      return 'http://localhost:8080';
    }
    return 'https://api.production.com';
  }

  static Future<void> setupMockServer() async {
    if (kDebugMode) {
      final mockServer = SmartFaker().createMockApi();
      // Setup endpoints...
      await mockServer.start(port: 8080);
    }
  }
}
```

## Limitations

- Mock server runs only locally (localhost)
- In-memory state storage (lost on restart)
- Basic routing (no regex patterns)
- No WebSocket support
- No file upload handling

## Future Enhancements

Planned features for future releases:

- JSON Schema validation
- OpenAPI/Swagger import
- GraphQL support
- WebSocket mocking
- Persistent state options
- Advanced routing patterns
- Request validation
- Response streaming

## Examples

Complete examples are available in the `/example` directory:

- `api_mocking_example.dart` - Comprehensive API mocking demos
- `stateful_api_example.dart` - CRUD operations with state
- `flutter_integration_example.dart` - Flutter app integration

## Support

For issues or feature requests related to API mocking, please visit:
[GitHub Issues](https://github.com/tienenwu/smart_faker/issues)