import 'package:test/test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('RelationshipManager', () {
    late SmartFaker faker;
    late RelationshipManager manager;

    setUp(() {
      faker = SmartFaker(seed: 42);
      manager = RelationshipManager(faker);
    });

    test('stores and retrieves data correctly', () {
      final data = {'id': '123', 'name': 'Test'};
      manager.storeData('User', data);

      final retrieved = manager.getRandomItem('User');
      expect(retrieved, equals(data));
    });

    test('stores multiple data items', () {
      final dataList = [
        {'id': '1', 'name': 'Test1'},
        {'id': '2', 'name': 'Test2'},
        {'id': '3', 'name': 'Test3'},
      ];
      manager.storeDataList('Product', dataList);

      final allItems = manager.getAllItems('Product');
      expect(allItems.length, equals(3));
      expect(allItems, equals(dataList));
    });

    test('manages singletons', () {
      final singleton = {'id': 'single', 'name': 'Singleton'};
      manager.storeSingleton('config', singleton);

      final retrieved = manager.getSingleton('config');
      expect(retrieved, equals(singleton));
    });

    test('increments counters', () {
      expect(manager.getNextCounter('Order'), equals(1));
      expect(manager.getNextCounter('Order'), equals(2));
      expect(manager.getNextCounter('Order'), equals(3));

      expect(manager.getNextCounter('Invoice'), equals(1));
    });

    test('clears data correctly', () {
      manager.storeData('User', {'id': '1'});
      manager.storeData('Product', {'id': '2'});
      manager.storeSingleton('config', {'id': '3'});

      manager.clear();

      expect(manager.getRandomItem('User'), isNull);
      expect(manager.getRandomItem('Product'), isNull);
      expect(manager.getSingleton('config'), isNull);
    });

    test('clears schema-specific data', () {
      manager.storeData('User', {'id': '1'});
      manager.storeData('Product', {'id': '2'});

      manager.clearSchema('User');

      expect(manager.getRandomItem('User'), isNull);
      expect(manager.getRandomItem('Product'), isNotNull);
    });
  });

  group('SmartRelationshipBuilder', () {
    late SmartFaker faker;
    late RelationshipManager manager;
    late SmartRelationshipBuilder builder;

    setUp(() {
      faker = SmartFaker(seed: 42);
      manager = RelationshipManager(faker);
      builder = SmartRelationshipBuilder(manager: manager, faker: faker);
    });

    test('creates one-to-many relationships', () {
      final parent = {'name': 'Parent User'};

      final result = builder.oneToMany(
        parentSchema: 'User',
        childSchema: 'Post',
        parent: parent,
        childrenGenerator: (parentId) => [
          {'title': 'Post 1', 'content': 'Content 1'},
          {'title': 'Post 2', 'content': 'Content 2'},
        ],
      );

      expect(result['id'], isNotNull);

      final posts = manager.getAllItems('Post');
      expect(posts.length, equals(2));
      expect(posts[0]['parentId'], equals(result['id']));
      expect(posts[1]['parentId'], equals(result['id']));
    });

    test('creates many-to-many relationships', () {
      final users = [
        {'id': 'u1', 'name': 'User 1'},
        {'id': 'u2', 'name': 'User 2'},
      ];

      final roles = [
        {'id': 'r1', 'name': 'Admin'},
        {'id': 'r2', 'name': 'Editor'},
        {'id': 'r3', 'name': 'Viewer'},
      ];

      final pivotData = builder.manyToMany(
        schema1: 'User',
        schema2: 'Role',
        pivotSchema: 'UserRole',
        items1: users,
        items2: roles,
        foreign1Field: 'userId',
        foreign2Field: 'roleId',
      );

      expect(pivotData.isNotEmpty, isTrue);

      for (final pivot in pivotData) {
        expect(pivot['userId'], isIn(['u1', 'u2']));
        expect(pivot['roleId'], isIn(['r1', 'r2', 'r3']));
        expect(pivot['createdAt'], isA<String>());
        expect(DateTime.tryParse(pivot['createdAt']), isNotNull);
      }
    });

    test('creates hierarchical data', () {
      final root = builder.hierarchy(
        schema: 'Category',
        nodeGenerator: (depth, parentId) => {
          'name': 'Category at depth $depth',
          'level': depth,
        },
        maxDepth: 2,
        childrenPerNode: 3,
      );

      expect(root['id'], isNotNull);
      expect(root['depth'], equals(0));
      expect(root['parentId'], isNull);

      if (root['children'] != null) {
        final children = root['children'] as List;
        for (final child in children) {
          expect(child['parentId'], equals(root['id']));
          expect(child['depth'], equals(1));
        }
      }
    });

    test('creates sequential data', () {
      final sequence = builder.sequence(
        schema: 'Event',
        count: 5,
        itemGenerator: (index, previous) => {
          'id': 'event_$index',
          'sequence': index,
          'previousId': previous?['id'],
          'timestamp': faker.dateTime.recent(),
        },
      );

      expect(sequence.length, equals(5));

      for (int i = 0; i < sequence.length; i++) {
        expect(sequence[i]['sequence'], equals(i));
        if (i > 0) {
          expect(sequence[i]['previousId'], equals('event_${i - 1}'));
        } else {
          expect(sequence[i]['previousId'], isNull);
        }
      }
    });

    test('creates related groups with shared attributes', () {
      final sharedLocation = {
        'city': faker.location.city(),
        'country': faker.location.country(),
        'timezone': 'UTC+8',
      };

      final result = builder.relatedGroup(
        schemas: {
          'Company': (shared) => {
                'name': faker.company.name(),
                'city': shared['city'],
                'country': shared['country'],
              },
          'Office': (shared) => [
                {
                  'name': 'Main Office',
                  'city': shared['city'],
                  'timezone': shared['timezone'],
                },
                {
                  'name': 'Branch Office',
                  'city': shared['city'],
                  'timezone': shared['timezone'],
                },
              ],
        },
        sharedAttributes: sharedLocation,
      );

      expect(result['Company']!.length, equals(1));
      expect(result['Office']!.length, equals(2));

      // Verify shared attributes
      expect(result['Company']![0]['city'], equals(sharedLocation['city']));
      expect(result['Office']![0]['city'], equals(sharedLocation['city']));
      expect(
          result['Office']![1]['timezone'], equals(sharedLocation['timezone']));
    });
  });
}
