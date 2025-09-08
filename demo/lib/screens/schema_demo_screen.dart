import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';
import 'dart:convert';

class SchemaDemoScreen extends StatefulWidget {
  const SchemaDemoScreen({super.key});

  @override
  State<SchemaDemoScreen> createState() => _SchemaDemoScreenState();
}

class _SchemaDemoScreenState extends State<SchemaDemoScreen> {
  late SmartFaker faker;
  late SchemaBuilder schemaBuilder;
  String selectedSchema = 'User';
  Map<String, dynamic> generatedData = {};
  List<Map<String, dynamic>> generatedList = [];
  bool showList = false;

  @override
  void initState() {
    super.initState();
    faker = SmartFaker();
    schemaBuilder = SchemaBuilder(faker);
    _registerSchemas();
    _generateSingle();
  }

  void _registerSchemas() {
    // User schema
    final userSchema = SchemaBuilder.defineSchema('User')
        .id()
        .withName()
        .withContact()
        .field('age', FakerFieldType.integer, min: 18, max: 65)
        .field('bio', FakerFieldType.paragraph, required: false)
        .hasMany('posts', 'Post')
        .withTimestamps()
        .build();

    // Post schema
    final postSchema = SchemaBuilder.defineSchema('Post')
        .id()
        .field('title', FakerFieldType.sentence)
        .field('content', FakerFieldType.paragraph)
        .field('tags', FakerFieldType.list, options: {
          'count': 3,
          'itemType': FakerFieldType.word,
        })
        .field('likes', FakerFieldType.integer, min: 0, max: 1000)
        .belongsTo('authorId', 'User', foreignKey: 'id')
        .withTimestamps()
        .build();

    // Product schema
    final productSchema = SchemaBuilder.defineSchema('Product')
        .id()
        .field('name', FakerFieldType.productName)
        .field('description', FakerFieldType.paragraph)
        .field('price', FakerFieldType.price, min: 9.99, max: 999.99)
        .field('sku', FakerFieldType.sku)
        .field('barcode', FakerFieldType.barcode)
        .field('inStock', FakerFieldType.boolean)
        .field('quantity', FakerFieldType.integer, min: 0, max: 100)
        .field('category', FakerFieldType.word)
        .field('tags', FakerFieldType.list, options: {
          'count': 5,
          'itemType': FakerFieldType.word,
        })
        .withTimestamps()
        .build();

    // Company schema
    final companySchema = SchemaBuilder.defineSchema('Company')
        .id()
        .field('name', FakerFieldType.companyName)
        .field('industry', FakerFieldType.industry)
        .field('catchphrase', FakerFieldType.catchPhrase)
        .field('website', FakerFieldType.url)
        .field('email', FakerFieldType.email)
        .field('phone', FakerFieldType.phone)
        .withAddress()
        .field('employees', FakerFieldType.integer, min: 10, max: 10000)
        .field('revenue', FakerFieldType.amount, min: 100000, max: 10000000)
        .hasMany('departments', 'Department')
        .withTimestamps()
        .build();

    // Department schema
    final departmentSchema = SchemaBuilder.defineSchema('Department')
        .id()
        .field('name', FakerFieldType.word)
        .field('manager', FakerFieldType.fullName)
        .field('budget', FakerFieldType.amount, min: 50000, max: 1000000)
        .field('headcount', FakerFieldType.integer, min: 5, max: 100)
        .belongsTo('companyId', 'Company', foreignKey: 'id')
        .build();

    // Order schema
    final orderSchema = SchemaBuilder.defineSchema('Order')
        .id()
        .field('orderNumber', FakerFieldType.uuid)
        .field('status', FakerFieldType.word)
        .field('total', FakerFieldType.amount, min: 10, max: 5000)
        .field('items', FakerFieldType.list, options: {
          'count': 3,
          'itemType': FakerFieldType.productName,
        })
        .field('shippingAddress', FakerFieldType.address)
        .field('billingAddress', FakerFieldType.address)
        .field('paymentMethod', FakerFieldType.creditCard)
        .belongsTo('customerId', 'User', foreignKey: 'id')
        .withTimestamps()
        .build();

    // Register all schemas
    schemaBuilder.registerSchema(userSchema);
    schemaBuilder.registerSchema(postSchema);
    schemaBuilder.registerSchema(productSchema);
    schemaBuilder.registerSchema(companySchema);
    schemaBuilder.registerSchema(departmentSchema);
    schemaBuilder.registerSchema(orderSchema);
  }

  void _generateSingle() {
    setState(() {
      generatedData = schemaBuilder.generate(selectedSchema);
      showList = false;
    });
  }

  void _generateList() {
    setState(() {
      generatedList = schemaBuilder.generateList(selectedSchema, count: 3);
      showList = true;
    });
  }

  void _copyToClipboard() {
    final data =
        _convertToJsonEncodable(showList ? generatedList : generatedData);
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
    Clipboard.setData(ClipboardData(text: jsonStr));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON copied to clipboard')),
    );
  }

  dynamic _convertToJsonEncodable(dynamic obj) {
    if (obj is DateTime) {
      return obj.toIso8601String();
    } else if (obj is Map) {
      return obj
          .map((key, value) => MapEntry(key, _convertToJsonEncodable(value)));
    } else if (obj is List) {
      return obj.map((e) => _convertToJsonEncodable(e)).toList();
    }
    return obj;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schema-based Generation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyToClipboard,
            tooltip: 'Copy JSON',
          ),
        ],
      ),
      body: Column(
        children: [
          // Schema selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Schema: '),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedSchema,
                    isExpanded: true,
                    items: [
                      'User',
                      'Post',
                      'Product',
                      'Company',
                      'Department',
                      'Order'
                    ]
                        .map((schema) => DropdownMenuItem(
                              value: schema,
                              child: Text(schema),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSchema = value;
                        });
                        _generateSingle();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateSingle,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Generate Single'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateList,
                    icon: const Icon(Icons.list),
                    label: const Text('Generate List (3)'),
                  ),
                ),
              ],
            ),
          ),

          // Generated data display
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                ),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  const JsonEncoder.withIndent('  ').convert(
                      _convertToJsonEncodable(
                          showList ? generatedList : generatedData)),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green[
                            400] // Green text for dark mode (like code editors)
                        : Colors.black87, // Dark text for light mode
                  ),
                ),
              ),
            ),
          ),

          // Schema definition info
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.blue[900]?.withOpacity(0.3)
                : Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Schema Features:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getSchemaDescription(selectedSchema),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSchemaDescription(String schema) {
    switch (schema) {
      case 'User':
        return '• ID, Name fields, Contact info\n• Age (18-65), Optional bio\n• Has many posts relationship\n• Timestamps';
      case 'Post':
        return '• ID, Title, Content\n• Tags list (3 words)\n• Likes count (0-1000)\n• Belongs to User\n• Timestamps';
      case 'Product':
        return '• ID, Name, Description\n• Price (\$9.99-\$999.99), SKU, Barcode\n• Stock status, Quantity (0-100)\n• Category, Tags list\n• Timestamps';
      case 'Company':
        return '• ID, Name, Industry, Catchphrase\n• Website, Contact info, Address\n• Employees (10-10000), Revenue\n• Has many departments\n• Timestamps';
      case 'Department':
        return '• ID, Name, Manager\n• Budget (\$50k-\$1M)\n• Headcount (5-100)\n• Belongs to Company';
      case 'Order':
        return '• ID, Order number, Status\n• Total (\$10-\$5000)\n• Items list, Addresses\n• Payment method\n• Belongs to User\n• Timestamps';
      default:
        return '';
    }
  }
}
