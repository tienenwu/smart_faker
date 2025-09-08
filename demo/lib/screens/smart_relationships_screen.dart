import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';
import 'dart:convert';

class SmartRelationshipsScreen extends StatefulWidget {
  const SmartRelationshipsScreen({super.key});

  @override
  State<SmartRelationshipsScreen> createState() =>
      _SmartRelationshipsScreenState();
}

class _SmartRelationshipsScreenState extends State<SmartRelationshipsScreen> {
  final SmartFaker faker = SmartFaker(seed: 42);
  late RelationshipManager manager;
  late SmartRelationshipBuilder builder;

  String selectedExample = 'ecommerce';
  Map<String, dynamic> generatedData = {};

  @override
  void initState() {
    super.initState();
    manager = RelationshipManager(faker);
    builder = SmartRelationshipBuilder(manager: manager, faker: faker);
    _generateExample();
  }

  void _generateExample() {
    manager.clear(); // Clear previous data

    switch (selectedExample) {
      case 'ecommerce':
        _generateEcommerceExample();
        break;
      case 'social':
        _generateSocialMediaExample();
        break;
      case 'hierarchy':
        _generateHierarchyExample();
        break;
      case 'sequential':
        _generateSequentialExample();
        break;
    }
  }

  void _generateEcommerceExample() {
    // Create customer
    final customer = {
      'id': faker.random.uuid(),
      'name': faker.person.fullName(),
      'email': faker.internet.email(),
      'registeredAt': faker.dateTime.past().toIso8601String(),
    };

    // Create order with related items
    final order = builder.oneToMany(
      parentSchema: 'Order',
      childSchema: 'OrderItem',
      parent: {
        'orderNumber':
            'ORD-${manager.getNextCounter('Order').toString().padLeft(6, '0')}',
        'customerId': customer['id'],
        'customerName': customer['name'],
        'status': faker.random
            .element(['pending', 'processing', 'shipped', 'delivered']),
        'orderDate': faker.dateTime.recent().toIso8601String(),
      },
      childrenGenerator: (orderId) {
        final itemCount = faker.random.integer(min: 2, max: 5);
        return List.generate(
            itemCount,
            (i) => {
                  'id': faker.random.uuid(),
                  'productName': faker.commerce.productName(),
                  'quantity': faker.random.integer(min: 1, max: 3),
                  'unitPrice': faker.commerce.price(min: 9.99, max: 199.99),
                });
      },
    );

    // Calculate total
    final items = manager
        .getAllItems('OrderItem')
        .where((item) => item['orderId'] == order['id'])
        .toList();

    double total = 0;
    for (final item in items) {
      total += (item['unitPrice'] as num) * (item['quantity'] as int);
    }
    order['total'] = total;

    setState(() {
      generatedData = {
        'customer': customer,
        'order': order,
        'items': items,
      };
    });
  }

  void _generateSocialMediaExample() {
    // Create users
    final users = List.generate(
        5,
        (i) => {
              'id': faker.random.uuid(),
              'username': faker.internet.username(),
              'displayName': faker.person.fullName(),
              'bio': faker.lorem.sentence(),
              'joinedAt': faker.dateTime.past().toIso8601String(),
              'followersCount': 0,
              'followingCount': 0,
            });

    // Create posts for each user
    final posts = <Map<String, dynamic>>[];
    for (final user in users) {
      final postCount = faker.random.integer(min: 1, max: 3);
      for (int i = 0; i < postCount; i++) {
        posts.add({
          'id': faker.random.uuid(),
          'userId': user['id'],
          'username': user['username'],
          'content': faker.lorem.paragraph(),
          'likes': faker.random.integer(min: 0, max: 100),
          'postedAt': faker.dateTime.recent().toIso8601String(),
        });
        manager.storeData('Post', posts.last);
      }
    }

    // Create follow relationships
    final followData = builder.manyToMany(
      schema1: 'User',
      schema2: 'User',
      pivotSchema: 'Follow',
      items1: users.sublist(0, 3),
      items2: users.sublist(2),
      foreign1Field: 'followerId',
      foreign2Field: 'followingId',
    );

    // Update follower counts
    for (final follow in followData) {
      final follower = users.firstWhere((u) => u['id'] == follow['followerId']);
      final following =
          users.firstWhere((u) => u['id'] == follow['followingId']);
      follower['followingCount'] = (follower['followingCount'] as int) + 1;
      following['followersCount'] = (following['followersCount'] as int) + 1;
    }

    setState(() {
      generatedData = {
        'users': users,
        'posts': posts,
        'follows': followData,
      };
    });
  }

  void _generateHierarchyExample() {
    final orgChart = builder.hierarchy(
      schema: 'Department',
      nodeGenerator: (depth, parentId) {
        final departmentTypes = [
          ['Executive'],
          ['Engineering', 'Marketing', 'Sales', 'HR'],
          ['Frontend', 'Backend', 'QA', 'Design'],
        ];

        final typeList =
            depth < departmentTypes.length ? departmentTypes[depth] : ['Team'];

        return {
          'name': faker.random.element(typeList),
          'budget': faker.finance.amount(min: 50000, max: 500000),
          'headcount': faker.random.integer(min: 5, max: 30),
        };
      },
      maxDepth: 2,
      childrenPerNode: 3,
    );

    setState(() {
      generatedData = {
        'organization': orgChart,
      };
    });
  }

  void _generateSequentialExample() {
    final events = builder.sequence(
      schema: 'Event',
      count: 5,
      itemGenerator: (index, previous) {
        final eventTypes = [
          'user_signup',
          'email_verified',
          'profile_completed',
          'first_purchase',
          'subscription_upgraded'
        ];
        DateTime baseTime;
        if (previous != null && previous['timestamp'] != null) {
          // Parse the ISO string back to DateTime for calculation
          baseTime = DateTime.parse(previous['timestamp'] as String);
        } else {
          baseTime = faker.dateTime.past();
        }

        return {
          'id': 'evt_${index + 1}',
          'type':
              index < eventTypes.length ? eventTypes[index] : 'custom_event',
          'userId': previous?['userId'] ?? faker.random.uuid(),
          'previousEventId': previous?['id'],
          'timestamp': baseTime
              .add(Duration(hours: faker.random.integer(min: 1, max: 24)))
              .toIso8601String(),
          'metadata': {
            'ip': faker.internet.ipv4(),
            'sessionId':
                previous?['metadata']?['sessionId'] ?? faker.random.uuid(),
          },
        };
      },
    );

    setState(() {
      generatedData = {
        'events': events,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Relationships'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateExample,
            tooltip: 'Regenerate',
          ),
        ],
      ),
      body: Column(
        children: [
          // Example selector
          Container(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'ecommerce',
                  label: Text('E-commerce'),
                  icon: Icon(Icons.shopping_cart),
                ),
                ButtonSegment(
                  value: 'social',
                  label: Text('Social'),
                  icon: Icon(Icons.people),
                ),
                ButtonSegment(
                  value: 'hierarchy',
                  label: Text('Hierarchy'),
                  icon: Icon(Icons.account_tree),
                ),
                ButtonSegment(
                  value: 'sequential',
                  label: Text('Sequential'),
                  icon: Icon(Icons.timeline),
                ),
              ],
              selected: {selectedExample},
              onSelectionChanged: (Set<String> selection) {
                setState(() {
                  selectedExample = selection.first;
                  _generateExample();
                });
              },
            ),
          ),

          // Description card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getExampleDescription(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Generated data display
          Expanded(
            child: generatedData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Generated Data',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 20),
                                    onPressed: () {
                                      final jsonStr =
                                          const JsonEncoder.withIndent('  ')
                                              .convert(generatedData);
                                      Clipboard.setData(
                                          ClipboardData(text: jsonStr));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied to clipboard'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              constraints: const BoxConstraints(maxHeight: 500),
                              child: SingleChildScrollView(
                                child: SelectableText(
                                  const JsonEncoder.withIndent('  ')
                                      .convert(generatedData),
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.greenAccent
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatisticsCard(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _getExampleDescription() {
    switch (selectedExample) {
      case 'ecommerce':
        return 'One-to-Many relationship: Customer → Order → Order Items with consistent relationships';
      case 'social':
        return 'Many-to-Many relationship: Users ↔ Users (followers) with posts and counts';
      case 'hierarchy':
        return 'Tree structure: Organizational chart with departments and sub-departments';
      case 'sequential':
        return 'Sequential data: Event chain where each event references the previous one';
      default:
        return '';
    }
  }

  Widget _buildStatisticsCard() {
    Map<String, int> stats = {};

    switch (selectedExample) {
      case 'ecommerce':
        stats = {
          'Customer': 1,
          'Order': 1,
          'Order Items': (generatedData['items'] as List?)?.length ?? 0,
        };
        break;
      case 'social':
        stats = {
          'Users': (generatedData['users'] as List?)?.length ?? 0,
          'Posts': (generatedData['posts'] as List?)?.length ?? 0,
          'Follow Relations': (generatedData['follows'] as List?)?.length ?? 0,
        };
        break;
      case 'hierarchy':
        int countNodes(Map<String, dynamic> node) {
          int count = 1;
          if (node['children'] != null) {
            for (final child in node['children'] as List) {
              count += countNodes(child as Map<String, dynamic>);
            }
          }
          return count;
        }
        stats = {
          'Departments': countNodes(generatedData['organization'] ?? {}),
        };
        break;
      case 'sequential':
        stats = {
          'Events': (generatedData['events'] as List?)?.length ?? 0,
        };
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...stats.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
