import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class SchemaValidationDemoScreen extends StatefulWidget {
  const SchemaValidationDemoScreen({super.key});

  @override
  State<SchemaValidationDemoScreen> createState() =>
      _SchemaValidationDemoScreenState();
}

class _SchemaValidationDemoScreenState
    extends State<SchemaValidationDemoScreen> {
  final SmartFaker faker = SmartFaker(locale: 'zh_TW');
  late final SchemaBuilder builder;
  final TextEditingController _patternController = TextEditingController();
  String _selectedSchema = 'User';
  Map<String, dynamic> _generatedData = {};

  @override
  void initState() {
    super.initState();
    builder = SchemaBuilder(faker);
    _setupSchemas();
    _generateData();
  }

  @override
  void dispose() {
    _patternController.dispose();
    super.dispose();
  }

  void _setupSchemas() {
    // User schema with Taiwan-specific validation
    final userSchema = SchemaDefinitionBuilder('User')
        .id()
        .field(
          'taiwanId',
          FakerFieldType.custom,
          pattern: r'^[A-Z][12]\d{8}$',
          validator: FieldValidators.taiwanId,
          validationMessage: 'Invalid Taiwan ID format',
        )
        .field(
          'email',
          FakerFieldType.email,
          validator: FieldValidators.email,
        )
        .field(
          'phone',
          FakerFieldType.custom,
          pattern: r'^09\d{8}$',
          validator: FieldValidators.regex(r'^09\d{8}$'),
        )
        .field(
          'username',
          FakerFieldType.username,
          validator: FieldValidators.length(min: 3, max: 20),
        )
        .withTimestamps()
        .build();

    // Order schema with complex patterns
    final orderSchema = SchemaDefinitionBuilder('Order')
        .field(
          'orderNumber',
          FakerFieldType.custom,
          pattern: r'^ORD-2025-\d{6}$',
          validator: FieldValidators.fromPattern(r'^ORD-2025-\d{6}$'),
        )
        .field(
          'invoiceNumber',
          FakerFieldType.custom,
          pattern: r'^[A-Z]{2}-\d{8}$',
        )
        .field(
          'trackingNumber',
          FakerFieldType.custom,
          pattern: r'^[A-Z]{2}\d{9}[A-Z]{2}$',
        )
        .field(
          'status',
          FakerFieldType.custom,
          validator:
              FieldValidators.inList(['pending', 'processing', 'shipped']),
          defaultValue: 'pending',
        )
        .field(
          'creditCard',
          FakerFieldType.custom,
          pattern: r'^4\d{15}$', // Visa
          validator: FieldValidators.creditCard,
        )
        .withTimestamps()
        .build();

    // Product schema with SKU validation
    final productSchema = SchemaDefinitionBuilder('Product')
        .field(
          'sku',
          FakerFieldType.custom,
          pattern: r'^PRD-[A-Z]{3}-\d{4}$',
          validator: FieldValidators.fromPattern(r'^PRD-[A-Z]{3}-\d{4}$'),
        )
        .field(
          'barcode',
          FakerFieldType.custom,
          pattern: r'^\d{13}$',
          validator: FieldValidators.length(exact: 13),
        )
        .field(
          'price',
          FakerFieldType.price,
          min: 99.0,
          max: 9999.0,
          validator: FieldValidators.range(min: 99, max: 9999),
        )
        .field(
          'productName',
          FakerFieldType.productName,
        )
        .build();

    // Network configuration schema
    final networkSchema = SchemaDefinitionBuilder('Network')
        .field(
          'ipAddress',
          FakerFieldType.custom,
          pattern: r'^192\.168\.\d{1,3}\.\d{1,3}$',
          validator: FieldValidators.ipv4,
        )
        .field(
          'macAddress',
          FakerFieldType.custom,
          pattern: FieldPatterns.macAddress,
          validator: FieldValidators.macAddress,
        )
        .field(
          'port',
          FakerFieldType.integer,
          min: 1024,
          max: 65535,
          validator: FieldValidators.range(min: 1024, max: 65535),
        )
        .field(
          'hexColor',
          FakerFieldType.custom,
          pattern: r'^#[A-Fa-f0-9]{6}$',
          validator: FieldValidators.hexColor,
        )
        .build();

    // Custom schema with user-defined pattern
    final customSchema = SchemaDefinitionBuilder('Custom')
        .field(
          'customField',
          FakerFieldType.custom,
          pattern: r'^TEST-\d{4}$',
        )
        .build();

    builder.registerSchema(userSchema);
    builder.registerSchema(orderSchema);
    builder.registerSchema(productSchema);
    builder.registerSchema(networkSchema);
    builder.registerSchema(customSchema);
  }

  void _generateData() {
    setState(() {
      _generatedData = builder.generate(_selectedSchema);
    });
  }

  void _generateCustom() {
    if (_patternController.text.isEmpty) return;

    // Create a temporary schema with the custom pattern
    final customSchema = SchemaDefinitionBuilder('CustomPattern')
        .field(
          'value',
          FakerFieldType.custom,
          pattern: _patternController.text,
          validator: FieldValidators.fromPattern(_patternController.text),
        )
        .build();

    builder.registerSchema(customSchema);

    setState(() {
      try {
        _generatedData = builder.generate('CustomPattern');
      } catch (e) {
        _generatedData = {'error': e.toString()};
      }
    });
  }

  Widget _buildSchemaSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Schema',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'User', label: Text('User')),
                ButtonSegment(value: 'Order', label: Text('Order')),
                ButtonSegment(value: 'Product', label: Text('Product')),
                ButtonSegment(value: 'Network', label: Text('Network')),
                ButtonSegment(value: 'Custom', label: Text('Custom')),
              ],
              selected: {_selectedSchema},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedSchema = newSelection.first;
                  _generateData();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomPatternInput() {
    if (_selectedSchema != 'Custom') return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Regex Pattern',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _patternController,
              decoration: InputDecoration(
                labelText: 'Enter Regex Pattern',
                hintText: r'^[A-Z]{3}-\d{4}$',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: _generateCustom,
                ),
              ),
              onSubmitted: (_) => _generateCustom(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text(r'^[A-Z]{3}-\d{4}$'),
                  onPressed: () {
                    _patternController.text = r'^[A-Z]{3}-\d{4}$';
                    _generateCustom();
                  },
                ),
                ActionChip(
                  label: const Text(r'^09\d{8}$'),
                  onPressed: () {
                    _patternController.text = r'^09\d{8}$';
                    _generateCustom();
                  },
                ),
                ActionChip(
                  label: const Text(r'^#[A-F0-9]{6}$'),
                  onPressed: () {
                    _patternController.text = r'^#[A-F0-9]{6}$';
                    _generateCustom();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedData() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Generated Data',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _selectedSchema == 'Custom' &&
                          _patternController.text.isNotEmpty
                      ? _generateCustom
                      : _generateData,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_generatedData.containsKey('error'))
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _generatedData['error'].toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._generatedData.entries.map((entry) {
                final value = entry.value;
                final displayValue = value is DateTime
                    ? value.toLocal().toString()
                    : value.toString();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          '${entry.key}:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SelectableText(
                          displayValue,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: displayValue));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied ${entry.key}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternExamples() {
    final examples = {
      'User': [
        'Taiwan ID: ^[A-Z][12]\\d{8}\$',
        'Phone: ^09\\d{8}\$',
        'Email: Validated with email validator',
        'Username: 3-20 characters',
      ],
      'Order': [
        'Order #: ^ORD-2025-\\d{6}\$',
        'Invoice: ^[A-Z]{2}-\\d{8}\$',
        'Tracking: ^[A-Z]{2}\\d{9}[A-Z]{2}\$',
        'Credit Card: Visa pattern (^4\\d{15}\$)',
      ],
      'Product': [
        'SKU: ^PRD-[A-Z]{3}-\\d{4}\$',
        'Barcode: ^\\d{13}\$ (EAN-13)',
        'Price: 99-9999 range',
      ],
      'Network': [
        'IP: ^192.168.\\d{1,3}.\\d{1,3}\$',
        'MAC: Standard MAC format',
        'Port: 1024-65535',
        'Hex Color: ^#[A-Fa-f0-9]{6}\$',
      ],
      'Custom': [
        'Define your own regex pattern',
        'Example: ^[A-Z]{3}-\\d{4}\$',
        'Supports any valid regex',
      ],
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pattern Examples',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...examples[_selectedSchema]!.map((example) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          example,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schema Validation Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSchemaSelector(),
          const SizedBox(height: 16),
          _buildCustomPatternInput(),
          const SizedBox(height: 16),
          _buildPatternExamples(),
          const SizedBox(height: 16),
          _buildGeneratedData(),
        ],
      ),
    );
  }
}
