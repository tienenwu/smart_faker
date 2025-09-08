import '../core/smart_faker.dart';

/// Manages relationships between schemas for consistent data generation
class RelationshipManager {
  final SmartFaker faker;
  final Map<String, List<Map<String, dynamic>>> _dataStore = {};
  final Map<String, Map<String, dynamic>> _singletonStore = {};
  final Map<String, int> _counters = {};

  RelationshipManager(this.faker);

  /// Store generated data for a schema
  void storeData(String schemaName, Map<String, dynamic> data) {
    _dataStore.putIfAbsent(schemaName, () => []).add(data);
  }

  /// Store multiple generated data for a schema
  void storeDataList(String schemaName, List<Map<String, dynamic>> dataList) {
    _dataStore.putIfAbsent(schemaName, () => []).addAll(dataList);
  }

  /// Store singleton data that should be reused
  void storeSingleton(String key, Map<String, dynamic> data) {
    _singletonStore[key] = data;
  }

  /// Get a random existing item from a schema
  Map<String, dynamic>? getRandomItem(String schemaName) {
    final items = _dataStore[schemaName];
    if (items != null && items.isNotEmpty) {
      return faker.random.element(items);
    }
    return null;
  }

  /// Get all items from a schema
  List<Map<String, dynamic>> getAllItems(String schemaName) {
    return _dataStore[schemaName] ?? [];
  }

  /// Get a singleton item
  Map<String, dynamic>? getSingleton(String key) {
    return _singletonStore[key];
  }

  /// Get the next counter value for a schema
  int getNextCounter(String schemaName) {
    _counters[schemaName] = (_counters[schemaName] ?? 0) + 1;
    return _counters[schemaName]!;
  }

  /// Clear all stored data
  void clear() {
    _dataStore.clear();
    _singletonStore.clear();
    _counters.clear();
  }

  /// Clear data for a specific schema
  void clearSchema(String schemaName) {
    _dataStore.remove(schemaName);
    _counters.remove(schemaName);
  }
}

/// Smart relationship builder for creating consistent related data
class SmartRelationshipBuilder {
  final RelationshipManager manager;
  final SmartFaker faker;

  SmartRelationshipBuilder({
    required this.manager,
    required this.faker,
  });

  /// Create a one-to-many relationship
  Map<String, dynamic> oneToMany({
    required String parentSchema,
    required String childSchema,
    required Map<String, dynamic> parent,
    required List<Map<String, dynamic>> Function(String parentId)
        childrenGenerator,
    String parentIdField = 'id',
    String childForeignKey = 'parentId',
  }) {
    final parentId = parent[parentIdField] ?? faker.random.uuid();
    parent[parentIdField] = parentId;

    final children = childrenGenerator(parentId);
    for (final child in children) {
      child[childForeignKey] = parentId;
      manager.storeData(childSchema, child);
    }

    manager.storeData(parentSchema, parent);
    return parent;
  }

  /// Create a many-to-many relationship
  List<Map<String, dynamic>> manyToMany({
    required String schema1,
    required String schema2,
    required String pivotSchema,
    required List<Map<String, dynamic>> items1,
    required List<Map<String, dynamic>> items2,
    String id1Field = 'id',
    String id2Field = 'id',
    String foreign1Field = 'item1Id',
    String foreign2Field = 'item2Id',
  }) {
    final pivotData = <Map<String, dynamic>>[];

    // Store primary items
    for (final item in items1) {
      manager.storeData(schema1, item);
    }
    for (final item in items2) {
      manager.storeData(schema2, item);
    }

    // Create pivot relationships
    for (final item1 in items1) {
      final relatedCount = faker.random.integer(min: 1, max: items2.length);
      final relatedItems = <Map<String, dynamic>>[];
      for (int i = 0; i < relatedCount; i++) {
        relatedItems.add(faker.random.element(items2));
      }

      for (final item2 in relatedItems) {
        pivotData.add({
          'id': faker.random.uuid(),
          foreign1Field: item1[id1Field],
          foreign2Field: item2[id2Field],
          'createdAt': faker.dateTime.recent().toIso8601String(),
        });
      }
    }

    manager.storeDataList(pivotSchema, pivotData);
    return pivotData;
  }

  /// Create hierarchical data (tree structure)
  Map<String, dynamic> hierarchy({
    required String schema,
    required Map<String, dynamic> Function(int depth, String? parentId)
        nodeGenerator,
    int maxDepth = 3,
    int childrenPerNode = 2,
    String? parentId,
    int currentDepth = 0,
  }) {
    final node = nodeGenerator(currentDepth, parentId);
    final nodeId = node['id'] ?? faker.random.uuid();
    node['id'] = nodeId;
    node['parentId'] = parentId;
    node['depth'] = currentDepth;

    manager.storeData(schema, node);

    if (currentDepth < maxDepth) {
      final childCount = faker.random.integer(min: 0, max: childrenPerNode);
      final children = <Map<String, dynamic>>[];

      for (int i = 0; i < childCount; i++) {
        children.add(hierarchy(
          schema: schema,
          nodeGenerator: nodeGenerator,
          maxDepth: maxDepth,
          childrenPerNode: childrenPerNode,
          parentId: nodeId,
          currentDepth: currentDepth + 1,
        ));
      }

      node['children'] = children;
    }

    return node;
  }

  /// Create sequential data with references
  List<Map<String, dynamic>> sequence({
    required String schema,
    required int count,
    required Map<String, dynamic> Function(
            int index, Map<String, dynamic>? previous)
        itemGenerator,
  }) {
    final items = <Map<String, dynamic>>[];
    Map<String, dynamic>? previousItem;

    for (int i = 0; i < count; i++) {
      final item = itemGenerator(i, previousItem);
      items.add(item);
      manager.storeData(schema, item);
      previousItem = item;
    }

    return items;
  }

  /// Create related data with shared attributes
  Map<String, List<Map<String, dynamic>>> relatedGroup({
    required Map<String, Function(Map<String, dynamic> shared)> schemas,
    required Map<String, dynamic> sharedAttributes,
  }) {
    final result = <String, List<Map<String, dynamic>>>{};

    for (final entry in schemas.entries) {
      final schemaName = entry.key;
      final generator = entry.value;
      final data = generator(sharedAttributes);

      if (data is List) {
        result[schemaName] = data.cast<Map<String, dynamic>>();
        manager.storeDataList(schemaName, data.cast<Map<String, dynamic>>());
      } else if (data is Map<String, dynamic>) {
        result[schemaName] = [data];
        manager.storeData(schemaName, data);
      }
    }

    return result;
  }
}
