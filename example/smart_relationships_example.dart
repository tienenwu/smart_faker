import 'package:smart_faker/smart_faker.dart';
import 'package:smart_faker/src/schema/relationship_manager.dart';

/// Example demonstrating smart relationships for realistic data generation
void main() {
  final faker = SmartFaker(seed: 42);
  final manager = RelationshipManager(faker);
  final relationshipBuilder = SmartRelationshipBuilder(
    manager: manager,
    faker: faker,
  );
  
  print('=== Smart Relationships Examples ===\n');
  
  // Example 1: E-commerce scenario with consistent relationships
  ecommerceExample(faker, manager, relationshipBuilder);
  
  // Example 2: Social media scenario with complex relationships
  socialMediaExample(faker, manager, relationshipBuilder);
  
  // Example 3: Company hierarchy with organizational structure
  companyHierarchyExample(faker, manager, relationshipBuilder);
  
  // Example 4: Event-driven system with sequential data
  eventSystemExample(faker, manager, relationshipBuilder);
}

void ecommerceExample(
  SmartFaker faker,
  RelationshipManager manager,
  SmartRelationshipBuilder builder,
) {
  print('--- E-commerce Example ---');
  
  // Create customers with orders
  final customers = List.generate(3, (i) => {
    'id': faker.random.uuid(),
    'name': faker.person.fullName(),
    'email': faker.internet.email(),
    'registeredAt': faker.dateTime.past(),
  });
  
  // Create products
  final products = List.generate(10, (i) => {
    'id': faker.random.uuid(),
    'name': faker.commerce.productName(),
    'price': faker.commerce.price(min: 10, max: 500),
    'sku': faker.commerce.sku(),
    'stock': faker.random.integer(min: 0, max: 100),
  });
  
  // Store products for reference
  manager.storeDataList('Product', products);
  
  // Create orders with consistent customer relationships
  for (final customer in customers) {
    final orderCount = faker.random.integer(min: 1, max: 3);
    
    for (int i = 0; i < orderCount; i++) {
      final order = builder.oneToMany(
        parentSchema: 'Order',
        childSchema: 'OrderItem',
        parent: {
          'orderNumber': 'ORD-${manager.getNextCounter('Order').toString().padLeft(6, '0')}',
          'customerId': customer['id'],
          'customerName': customer['name'],
          'customerEmail': customer['email'],
          'status': faker.random.element(['pending', 'processing', 'shipped', 'delivered']),
          'orderDate': faker.dateTime.recent(),
        },
        childrenGenerator: (orderId) {
          final itemCount = faker.random.integer(min: 1, max: 5);
          final selectedProducts = <Map<String, dynamic>>[];
          
          for (int j = 0; j < itemCount; j++) {
            final product = faker.random.element(products);
            selectedProducts.add({
              'id': faker.random.uuid(),
              'orderId': orderId,
              'productId': product['id'],
              'productName': product['name'],
              'quantity': faker.random.integer(min: 1, max: 3),
              'unitPrice': product['price'] as num,
              'subtotal': (product['price'] as num) * faker.random.integer(min: 1, max: 3),
            });
          }
          
          return selectedProducts;
        },
        parentIdField: 'id',
        childForeignKey: 'orderId',
      );
      
      // Calculate order total from items
      final orderItems = manager.getAllItems('OrderItem')
          .where((item) => item['orderId'] == order['id'])
          .toList();
      
      final total = orderItems.fold<double>(
        0.0,
        (sum, item) => sum + (item['subtotal'] as num).toDouble(),
      );
      
      order['total'] = total;
      
      print('\nOrder ${order['orderNumber']} for ${order['customerName']}:');
      print('  Status: ${order['status']}');
      print('  Items: ${orderItems.length}');
      print('  Total: \$${total.toStringAsFixed(2)}');
    }
  }
}

void socialMediaExample(
  SmartFaker faker,
  RelationshipManager manager,
  SmartRelationshipBuilder builder,
) {
  print('\n--- Social Media Example ---');
  
  // Create users
  final users = List.generate(5, (i) => {
    'id': faker.random.uuid(),
    'username': faker.internet.username(),
    'displayName': faker.person.fullName(),
    'bio': faker.lorem.sentence(),
    'joinedAt': faker.dateTime.past(),
    'followersCount': 0,
    'followingCount': 0,
  });
  
  // Create posts for each user
  for (final user in users) {
    final postCount = faker.random.integer(min: 1, max: 3);
    
    for (int i = 0; i < postCount; i++) {
      final post = {
        'id': faker.random.uuid(),
        'userId': user['id'],
        'username': user['username'],
        'content': faker.lorem.paragraph(),
        'likes': faker.random.integer(min: 0, max: 100),
        'shares': faker.random.integer(min: 0, max: 20),
        'postedAt': faker.dateTime.recent(),
      };
      
      manager.storeData('Post', post);
    }
  }
  
  // Create follow relationships (many-to-many)
  final followData = builder.manyToMany(
    schema1: 'User',
    schema2: 'User',
    pivotSchema: 'Follow',
    items1: users.sublist(0, 3), // First 3 users follow others
    items2: users.sublist(2),    // Last 3 users can be followed
    id1Field: 'id',
    id2Field: 'id',
    foreign1Field: 'followerId',
    foreign2Field: 'followingId',
  );
  
  // Update follower/following counts
  for (final follow in followData) {
    final follower = users.firstWhere((u) => u['id'] == follow['followerId']);
    final following = users.firstWhere((u) => u['id'] == follow['followingId']);
    
    follower['followingCount'] = (follower['followingCount'] as int) + 1;
    following['followersCount'] = (following['followersCount'] as int) + 1;
  }
  
  print('\nSocial Network:');
  for (final user in users) {
    print('  @${user['username']}: ${user['followersCount']} followers, ${user['followingCount']} following');
    
    final userPosts = manager.getAllItems('Post')
        .where((p) => p['userId'] == user['id'])
        .toList();
    
    if (userPosts.isNotEmpty) {
      print('    Posts: ${userPosts.length}');
    }
  }
}

void companyHierarchyExample(
  SmartFaker faker,
  RelationshipManager manager,
  SmartRelationshipBuilder builder,
) {
  print('\n--- Company Hierarchy Example ---');
  
  // Create organizational structure
  final orgStructure = builder.hierarchy(
    schema: 'Department',
    nodeGenerator: (depth, parentId) {
      final departmentTypes = [
        ['Executive', 'Board'],
        ['Engineering', 'Marketing', 'Sales', 'HR', 'Finance'],
        ['Frontend', 'Backend', 'DevOps', 'QA', 'Design', 'Analytics'],
      ];
      
      final typeList = depth < departmentTypes.length 
          ? departmentTypes[depth]
          : ['Team'];
      
      return {
        'name': faker.random.element(typeList),
        'budget': faker.finance.amount(min: 50000, max: 500000),
        'headcount': faker.random.integer(min: 5, max: 50),
      };
    },
    maxDepth: 2,
    childrenPerNode: 3,
  );
  
  // Create employees for each department
  void assignEmployees(Map<String, dynamic> department) {
    final employeeCount = faker.random.integer(min: 3, max: 8);
    
    for (int i = 0; i < employeeCount; i++) {
      final employee = {
        'id': faker.random.uuid(),
        'name': faker.person.fullName(),
        'email': faker.internet.email(),
        'departmentId': department['id'],
        'departmentName': department['name'],
        'position': faker.commerce.department(),
        'salary': faker.finance.amount(min: 40000, max: 150000),
        'hiredAt': faker.dateTime.past(),
      };
      
      manager.storeData('Employee', employee);
    }
    
    // Recursively assign employees to child departments
    if (department['children'] != null) {
      for (final child in department['children'] as List) {
        assignEmployees(child as Map<String, dynamic>);
      }
    }
  }
  
  assignEmployees(orgStructure);
  
  // Print hierarchy
  void printHierarchy(Map<String, dynamic> node, String indent) {
    print('$indent${node['name']} (Level ${node['depth']})');
    
    final employees = manager.getAllItems('Employee')
        .where((e) => e['departmentId'] == node['id'])
        .toList();
    
    print('$indent  Employees: ${employees.length}');
    print('$indent  Budget: \$${(node['budget'] as double).toStringAsFixed(0)}');
    
    if (node['children'] != null) {
      for (final child in node['children'] as List) {
        printHierarchy(child as Map<String, dynamic>, '$indent  ');
      }
    }
  }
  
  print('\nOrganizational Structure:');
  printHierarchy(orgStructure, '  ');
}

void eventSystemExample(
  SmartFaker faker,
  RelationshipManager manager,
  SmartRelationshipBuilder builder,
) {
  print('\n--- Event System Example ---');
  
  // Create sequential events with dependencies
  final events = builder.sequence(
    schema: 'Event',
    count: 5,
    itemGenerator: (index, previous) {
      final eventTypes = ['user_signup', 'email_verified', 'profile_completed', 'first_purchase', 'subscription_upgraded'];
      final baseTime = previous?['timestamp'] as DateTime? ?? faker.dateTime.past();
      
      return {
        'id': 'evt_${index + 1}',
        'type': index < eventTypes.length ? eventTypes[index] : 'custom_event',
        'userId': previous?['userId'] ?? faker.random.uuid(),
        'previousEventId': previous?['id'],
        'timestamp': baseTime.add(Duration(hours: faker.random.integer(min: 1, max: 24))),
        'metadata': {
          'ip': faker.internet.ipv4(),
          'userAgent': faker.internet.userAgent(),
          'sessionId': previous?['metadata']?['sessionId'] ?? faker.random.uuid(),
        },
      };
    },
  );
  
  print('\nEvent Sequence:');
  for (final event in events) {
    print('  ${event['id']}: ${event['type']}');
    print('    Time: ${event['timestamp']}');
    if (event['previousEventId'] != null) {
      print('    Previous: ${event['previousEventId']}');
    }
    print('    Session: ${event['metadata']['sessionId']}');
  }
  
  // Create audit trail
  final auditTrail = builder.relatedGroup(
    schemas: {
      'AuditLog': (shared) => events.map((event) => {
        'id': faker.random.uuid(),
        'eventId': event['id'],
        'action': 'EVENT_PROCESSED',
        'userId': shared['systemUserId'],
        'timestamp': (event['timestamp'] as DateTime).add(Duration(seconds: faker.random.integer(min: 1, max: 60))),
        'ipAddress': shared['serverIp'],
        'result': 'SUCCESS',
      }).toList(),
      'SystemMetrics': (shared) => {
        'id': faker.random.uuid(),
        'timestamp': DateTime.now(),
        'eventsProcessed': events.length,
        'systemUserId': shared['systemUserId'],
        'serverIp': shared['serverIp'],
        'avgProcessingTime': faker.random.integer(min: 10, max: 100),
      },
    },
    sharedAttributes: {
      'systemUserId': 'system_${faker.random.uuid()}',
      'serverIp': faker.internet.ipv4(),
    },
  );
  
  print('\nAudit Summary:');
  final metrics = auditTrail['SystemMetrics']![0];
  print('  Events Processed: ${metrics['eventsProcessed']}');
  print('  Avg Processing Time: ${metrics['avgProcessingTime']}ms');
  print('  Server IP: ${metrics['serverIp']}');
}