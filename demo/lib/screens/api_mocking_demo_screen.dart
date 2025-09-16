import 'package:flutter/material.dart';
import 'package:smart_faker/smart_faker.dart';

class ApiMockingDemoScreen extends StatefulWidget {
  const ApiMockingDemoScreen({Key? key}) : super(key: key);

  @override
  State<ApiMockingDemoScreen> createState() => _ApiMockingDemoScreenState();
}

class _ApiMockingDemoScreenState extends State<ApiMockingDemoScreen> {
  final SmartFaker faker = SmartFaker();
  final ResponseGenerator responseGenerator = ResponseGenerator();
  List<Map<String, dynamic>> generatedData = [];
  String selectedEndpoint = 'users';
  bool isLoading = false;

  // Template definitions for different endpoints
  final Map<String, dynamic> templates = {
    'users': {
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
    },
    'products': {
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
    },
    'posts': {
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
    },
  };

  void _generateData(String endpoint) {
    setState(() {
      isLoading = true;
      selectedEndpoint = endpoint;
    });

    // Simulate network delay
    Future.delayed(Duration(milliseconds: 500), () {
      List<Map<String, dynamic>> data = [];

      if (endpoint == 'users') {
        data = List.generate(
            5,
            (_) => {
                  'id': faker.datatype.uuid(),
                  'name': faker.person.fullName(),
                  'email': faker.internet.email(),
                  'age': faker.datatype.number(min: 18, max: 65),
                  'avatar': faker.image.avatarUrl(),
                  'jobTitle': faker.person.jobTitle(),
                  'company': faker.company.name(),
                  'phone': faker.phone.number(),
                });
      } else if (endpoint == 'products') {
        data = List.generate(
            10,
            (_) => {
                  'id': faker.datatype.uuid(),
                  'name': faker.commerce.productName(),
                  'price': faker.commerce.price(),
                  'category': faker.commerce.department(),
                  'description': faker.lorem.sentence(),
                  'inStock': faker.datatype.boolean(),
                  'rating': faker.datatype.number(min: 1, max: 5),
                  'imageUrl': faker.image.imageUrl(width: 200, height: 200),
                });
      } else if (endpoint == 'posts') {
        data = List.generate(
            8,
            (_) => {
                  'id': faker.datatype.uuid(),
                  'title': faker.lorem.sentence(),
                  'content': faker.lorem.paragraph(),
                  'author': faker.person.fullName(),
                  'publishedAt': faker.date.recent().toIso8601String(),
                  'likes': faker.datatype.number(max: 1000),
                  'comments': faker.datatype.number(max: 50),
                  'tags': List.generate(3, (_) => faker.lorem.word()),
                });
      }

      setState(() {
        generatedData = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Mocking Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              elevation: 4,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blue.shade900.withOpacity(0.3)
                  : Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.blue.shade300
                                    : Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'API Mocking Feature',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'SmartFaker v0.4.0 includes a built-in mock server for testing API integrations. '
                      'This demo shows how response templates work with faker directives.',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'In a real app, you would start the MockServer and make HTTP requests. '
                      'Here we demonstrate the response generation directly.',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Template Examples Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Response Templates',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Text('Example faker directives:'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '@uuid - Generate UUID\n'
                        '@person.fullName - Full name\n'
                        '@internet.email - Email address\n'
                        '@commerce.product - Product name\n'
                        '@lorem.paragraph - Lorem text\n'
                        '@array:N - Generate N items\n'
                        '{{person.name}} - String interpolation',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Endpoint Selection Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Endpoint',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          avatar: const Icon(Icons.person, size: 18),
                          label: const Text('Users'),
                          selected: selectedEndpoint == 'users',
                          onSelected: isLoading
                              ? null
                              : (selected) {
                                  if (selected) _generateData('users');
                                },
                        ),
                        ChoiceChip(
                          avatar: const Icon(Icons.shopping_bag, size: 18),
                          label: const Text('Products'),
                          selected: selectedEndpoint == 'products',
                          onSelected: isLoading
                              ? null
                              : (selected) {
                                  if (selected) _generateData('products');
                                },
                        ),
                        ChoiceChip(
                          avatar: const Icon(Icons.article, size: 18),
                          label: const Text('Posts'),
                          selected: selectedEndpoint == 'posts',
                          onSelected: isLoading
                              ? null
                              : (selected) {
                                  if (selected) _generateData('posts');
                                },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Generated Data Display
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (generatedData.isNotEmpty) ...[
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
                            'Generated Response',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Regenerate'),
                            onPressed: () => _generateData(selectedEndpoint),
                          ),
                        ],
                      ),
                      const Divider(),
                      ...generatedData.map((item) => _buildDataItem(item)),
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
            if (item.containsKey('email'))
              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(item['email']),
                ],
              ),
            if (item.containsKey('jobTitle'))
              Row(
                children: [
                  const Icon(Icons.work, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(item['jobTitle']),
                ],
              ),
            if (item.containsKey('company'))
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(item['company']),
                ],
              ),
            if (item.containsKey('price'))
              Text(
                '\$${item['price']}',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            if (item.containsKey('category'))
              Chip(
                label: Text(item['category']),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blue.shade900.withOpacity(0.5)
                    : Colors.blue.shade50,
              ),
            if (item.containsKey('inStock'))
              Row(
                children: [
                  Icon(
                    item['inStock'] ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: item['inStock'] ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item['inStock'] ? 'In Stock' : 'Out of Stock',
                    style: TextStyle(
                      color: item['inStock'] ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            if (item.containsKey('author'))
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('by ${item['author']}'),
                ],
              ),
            if (item.containsKey('content'))
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item['content'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            if (item.containsKey('likes'))
              Row(
                children: [
                  const Text('❤️ '),
                  Text('${item['likes']} likes'),
                ],
              ),
            if (item.containsKey('comments'))
              Row(
                children: [
                  const Text('💬 '),
                  Text('${item['comments']} comments'),
                ],
              ),
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
            if (item.containsKey('tags'))
              Wrap(
                spacing: 4,
                children: (item['tags'] as List)
                    .map((tag) => Chip(
                          label: Text(tag.toString(),
                              style: const TextStyle(fontSize: 10)),
                          padding: const EdgeInsets.all(0),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
