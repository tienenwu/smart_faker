import 'package:flutter/material.dart';
import 'package:smart_faker/smart_faker.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiMockingDemoScreen extends StatefulWidget {
  const ApiMockingDemoScreen({Key? key}) : super(key: key);

  @override
  State<ApiMockingDemoScreen> createState() => _ApiMockingDemoScreenState();
}

class _ApiMockingDemoScreenState extends State<ApiMockingDemoScreen> {
  final SmartFaker faker = SmartFaker();
  MockServer? mockServer;
  bool isServerRunning = false;
  String serverStatus = 'Server not running';
  List<Map<String, dynamic>> fetchedData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeMockServer();
  }

  @override
  void dispose() {
    _stopServer();
    super.dispose();
  }

  Future<void> _initializeMockServer() async {
    mockServer = MockServer(faker: faker);

    // Set up endpoints
    mockServer!.get('/api/users', {
      'users': [
        '@array:5',
        {
          'id': '@uuid',
          'name': '@person.fullName',
          'email': '@internet.email',
          'age': '@number.int:65',
          'avatar': '@image.avatar',
          'jobTitle': '@person.title',
          'company': '@company.name',
          'phone': '@phone',
        }
      ]
    });

    mockServer!.get('/api/products', {
      'products': [
        '@array:10',
        {
          'id': '@uuid',
          'name': '@commerce.product',
          'price': '@commerce.price',
          'category': '@commerce.department',
          'description': '@commerce.productDescription',
          'inStock': '@boolean',
          'rating': '@number.int:5',
          'imageUrl': '@image.url',
        }
      ],
      'total': 10,
      'page': 1,
    });

    mockServer!.get('/api/posts', {
      'posts': [
        '@array:8',
        {
          'id': '@uuid',
          'title': '@lorem.sentence',
          'content': '@lorem.paragraph',
          'author': '@person.fullName',
          'publishedAt': '@date.recent',
          'likes': '@number.int:1000',
          'comments': '@number.int:50',
          'tags': ['@array:3', '@lorem.word'],
        }
      ]
    });

    // Dynamic route with parameters
    mockServer!.get(
        '/api/users/<id>',
        (params) => {
              'id': params['id'],
              'name': '@person.fullName',
              'email': '@internet.email',
              'bio': '@person.bio',
              'address': {
                'street': '@address.street',
                'city': '@address.city',
                'country': '@address.country',
                'zipCode': '@address.zipCode',
              },
              'social': {
                'twitter': '@internet.username',
                'github': '@internet.username',
                'linkedin': '@internet.url',
              }
            });

    // POST endpoint
    mockServer!.post(
        '/api/users',
        (body) => {
              'id': '@uuid',
              'name': body['name'] ?? '@person.fullName',
              'email': body['email'] ?? '@internet.email',
              'createdAt': '@date.recent',
              'message': 'User created successfully',
            });

    // Set network simulation
    mockServer!.setDelay(300, 1000);
  }

  Future<void> _startServer() async {
    if (mockServer == null) return;

    setState(() {
      isLoading = true;
      serverStatus = 'Starting server...';
    });

    try {
      await mockServer!.start(port: 3000);
      setState(() {
        isServerRunning = true;
        serverStatus = 'Server running on http://localhost:3000';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        serverStatus = 'Failed to start server: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _stopServer() async {
    if (mockServer == null) return;

    try {
      await mockServer!.stop();
      setState(() {
        isServerRunning = false;
        serverStatus = 'Server stopped';
        fetchedData.clear();
      });
    } catch (e) {
      setState(() {
        serverStatus = 'Failed to stop server: $e';
      });
    }
  }

  Future<void> _fetchUsers() async {
    if (!isServerRunning) {
      _showMessage('Please start the server first');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/users'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fetchedData = List<Map<String, dynamic>>.from(data['users']);
          isLoading = false;
        });
      } else {
        _showMessage('Failed to fetch users: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showMessage('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchProducts() async {
    if (!isServerRunning) {
      _showMessage('Please start the server first');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/products'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fetchedData = List<Map<String, dynamic>>.from(data['products']);
          isLoading = false;
        });
      } else {
        _showMessage('Failed to fetch products: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showMessage('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchPosts() async {
    if (!isServerRunning) {
      _showMessage('Please start the server first');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/posts'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fetchedData = List<Map<String, dynamic>>.from(data['posts']);
          isLoading = false;
        });
      } else {
        _showMessage('Failed to fetch posts: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showMessage('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _createUser() async {
    if (!isServerRunning) {
      _showMessage('Please start the server first');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': faker.person.fullName(),
          'email': faker.internet.email(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _showMessage('User created: ${data['name']}');
        setState(() => isLoading = false);
      } else {
        _showMessage('Failed to create user: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showMessage('Error: $e');
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Mocking Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Server Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isServerRunning ? Icons.check_circle : Icons.cancel,
                          color: isServerRunning ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mock Server Status',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(serverStatus),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: isServerRunning || isLoading
                              ? null
                              : _startServer,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Server'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: !isServerRunning || isLoading
                              ? null
                              : _stopServer,
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop Server'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // API Endpoints Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Endpoints',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Text('• GET /api/users - List users'),
                    const Text('• GET /api/users/:id - Get user details'),
                    const Text('• POST /api/users - Create user'),
                    const Text('• GET /api/products - List products'),
                    const Text('• GET /api/posts - List blog posts'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : _fetchUsers,
                          child: const Text('Fetch Users'),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : _fetchProducts,
                          child: const Text('Fetch Products'),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : _fetchPosts,
                          child: const Text('Fetch Posts'),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : _createUser,
                          child: const Text('Create User (POST)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data Display Card
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (fetchedData.isNotEmpty) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fetched Data',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() => fetchedData.clear());
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      ...fetchedData.map((item) => _buildDataItem(item)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display different fields based on data type
            if (item.containsKey('name'))
              Text(
                item['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            if (item.containsKey('title'))
              Text(
                item['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 4),
            if (item.containsKey('email')) Text('Email: ${item['email']}'),
            if (item.containsKey('jobTitle')) Text('Job: ${item['jobTitle']}'),
            if (item.containsKey('company'))
              Text('Company: ${item['company']}'),
            if (item.containsKey('price'))
              Text(
                'Price: \$${item['price']}',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (item.containsKey('category'))
              Text('Category: ${item['category']}'),
            if (item.containsKey('inStock') != null)
              Text(
                'In Stock: ${item['inStock'] ? 'Yes' : 'No'}',
                style: TextStyle(
                  color: item['inStock'] ? Colors.green : Colors.red,
                ),
              ),
            if (item.containsKey('author')) Text('Author: ${item['author']}'),
            if (item.containsKey('content'))
              Text(
                item['content'],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            if (item.containsKey('likes')) Text('❤️ ${item['likes']} likes'),
            if (item.containsKey('comments'))
              Text('💬 ${item['comments']} comments'),
            if (item.containsKey('rating'))
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < (item['rating'] as int)
                        ? Icons.star
                        : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
