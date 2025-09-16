import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:smart_faker/smart_faker.dart';
import 'screens/api_mocking_demo_screen.dart';

void main() {
  runApp(const SmartFakerDemoApp());
}

class SmartFakerDemoApp extends StatelessWidget {
  const SmartFakerDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFaker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFaker Demo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SmartFaker v0.4.0',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'Intelligent Test Data Generator for Flutter/Dart'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildMenuTile(
            context,
            'Basic Demo',
            'Person, Commerce, Taiwan Data',
            Icons.data_usage,
            const BasicDemoScreen(),
          ),
          _buildMenuTile(
            context,
            'API Mocking',
            'Mock Server & Response Generation',
            Icons.api,
            const ApiMockingDemoScreen(),
          ),
          _buildMenuTile(
            context,
            'Schema Generation',
            'Generate data based on schemas',
            Icons.schema,
            const SchemaDemoScreen(),
          ),
          _buildMenuTile(
            context,
            'Export Features',
            'Export to CSV, JSON, SQL',
            Icons.download,
            const ExportDemoScreen(),
          ),
          _buildMenuTile(
            context,
            'Pattern Generation',
            'Generate from regex patterns',
            Icons.pattern,
            const PatternDemoScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, String title, String subtitle,
      IconData icon, Widget screen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}

// Basic Demo Screen
class BasicDemoScreen extends StatefulWidget {
  const BasicDemoScreen({super.key});

  @override
  State<BasicDemoScreen> createState() => _BasicDemoScreenState();
}

class _BasicDemoScreenState extends State<BasicDemoScreen> {
  final SmartFaker faker = SmartFaker();
  final List<String> generatedData = [];

  void _generatePersonData() {
    setState(() {
      generatedData.clear();
      generatedData.addAll([
        'Name: ${faker.person.fullName()}',
        'Email: ${faker.internet.email()}',
        'Phone: ${faker.phone.phoneNumber()}',
        'Job Title: ${faker.person.jobTitle()}',
        'Company: ${faker.company.name()}',
        'Address: ${faker.location.fullAddress()}',
        'City: ${faker.location.city()}',
        'Country: ${faker.location.country()}',
      ]);
    });
  }

  void _generateCommerceData() {
    setState(() {
      generatedData.clear();
      generatedData.addAll([
        'Product: ${faker.commerce.productName()}',
        'Price: \$${faker.commerce.price()}',
        'Category: ${faker.commerce.category()}',
        'Brand: ${faker.commerce.brand()}',
        'SKU: ${faker.commerce.sku()}',
        'Description: ${faker.commerce.productDescription()}',
      ]);
    });
  }

  void _generateTaiwanData() {
    setState(() {
      generatedData.clear();
      generatedData.addAll([
        'Taiwan ID: ${faker.taiwan.idNumber()}',
        'Mobile: ${faker.phone.phoneNumber()}',
        'Landline: ${faker.taiwan.landlineNumber()}',
        'Postal Code: ${faker.taiwan.postalCode()}',
        'License Plate: ${faker.taiwan.licensePlate()}',
        'Bank Account: ${faker.taiwan.bankAccount()}',
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _generatePersonData,
                  icon: const Icon(Icons.person),
                  label: const Text('Person'),
                ),
                ElevatedButton.icon(
                  onPressed: _generateCommerceData,
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Commerce'),
                ),
                ElevatedButton.icon(
                  onPressed: _generateTaiwanData,
                  icon: const Icon(Icons.flag),
                  label: const Text('Taiwan'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: generatedData.isEmpty
                      ? const Center(
                          child: Text(
                            'Select a category to generate data',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: generatedData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(generatedData[index]),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Schema Demo Screen
class SchemaDemoScreen extends StatefulWidget {
  const SchemaDemoScreen({super.key});

  @override
  State<SchemaDemoScreen> createState() => _SchemaDemoScreenState();
}

class _SchemaDemoScreenState extends State<SchemaDemoScreen> {
  final SmartFaker faker = SmartFaker();
  String generatedJson = '';

  final userSchema = {
    'id': '@uuid',
    'name': '@person.fullName',
    'email': '@internet.email',
    'age': '@number.int:65',
    'address': {
      'street': '@location.street',
      'city': '@location.city',
      'country': '@location.country',
      'zipCode': '@location.zipCode',
    },
    'tags': ['@array:3', '@lorem.word'],
  };

  void _generateFromSchema() {
    final generator = ResponseGenerator();
    final data = generator.generate(userSchema);
    setState(() {
      generatedJson = _formatJson(data);
    });
  }

  String _formatJson(dynamic data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schema Generation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Schema Template',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '''
{
  'id': '@uuid',
  'name': '@person.fullName',
  'email': '@internet.email',
  'age': '@number.int:65',
  'address': { ... },
  'tags': ['@array:3', '@lorem.word']
}''',
                        style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generateFromSchema,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Generate from Schema'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: generatedJson.isEmpty
                    ? const Center(
                        child: Text(
                          'Click button to generate data',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          generatedJson,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Export Demo Screen
class ExportDemoScreen extends StatefulWidget {
  const ExportDemoScreen({super.key});

  @override
  State<ExportDemoScreen> createState() => _ExportDemoScreenState();
}

class _ExportDemoScreenState extends State<ExportDemoScreen> {
  final SmartFaker faker = SmartFaker();
  String exportedData = '';
  String currentFormat = 'CSV';

  void _exportData(String format) {
    final users = List.generate(
        5,
        (i) => {
              'id': faker.datatype.uuid(),
              'name': faker.person.fullName(),
              'email': faker.internet.email(),
              'age': faker.datatype.number(min: 18, max: 65),
              'city': faker.location.city(),
            });

    final exporter = ExportModule();
    String result = '';
    switch (format) {
      case 'CSV':
        result = exporter.toCSV(users);
        break;
      case 'JSON':
        result = exporter.toJSON(users, pretty: true);
        break;
      case 'SQL':
        result = exporter.toSQL(users, table: 'users');
        break;
    }

    setState(() {
      currentFormat = format;
      exportedData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Features'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Format',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => _exportData('CSV'),
                          child: const Text('CSV'),
                        ),
                        ElevatedButton(
                          onPressed: () => _exportData('JSON'),
                          child: const Text('JSON'),
                        ),
                        ElevatedButton(
                          onPressed: () => _exportData('SQL'),
                          child: const Text('SQL'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[100],
                      child: Text(
                        'Exported Data ($currentFormat)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      child: exportedData.isEmpty
                          ? const Center(
                              child: Text(
                                'Select a format to export data',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                exportedData,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pattern Demo Screen
class PatternDemoScreen extends StatefulWidget {
  const PatternDemoScreen({super.key});

  @override
  State<PatternDemoScreen> createState() => _PatternDemoScreenState();
}

class _PatternDemoScreenState extends State<PatternDemoScreen> {
  final SmartFaker faker = SmartFaker();
  final List<Map<String, String>> results = [];

  void _generatePatterns() {
    setState(() {
      results.clear();
      results.addAll([
        {
          'pattern': r'^[A-Z]{3}-\d{4}$',
          'result': faker.pattern.fromRegex(r'^[A-Z]{3}-\d{4}$'),
          'description': 'License Plate',
        },
        {
          'pattern': r'^\d{4}-\d{2}-\d{2}$',
          'result': faker.pattern.fromRegex(r'^\d{4}-\d{2}-\d{2}$'),
          'description': 'Date Format',
        },
        {
          'pattern': r'^[A-Z][a-z]{2,7}$',
          'result': faker.pattern.fromRegex(r'^[A-Z][a-z]{2,7}$'),
          'description': 'Name Pattern',
        },
        {
          'pattern': r'^\+1-\d{3}-\d{3}-\d{4}$',
          'result': faker.pattern.fromRegex(r'^\+1-\d{3}-\d{3}-\d{4}$'),
          'description': 'US Phone',
        },
        {
          'pattern': r'^[A-F0-9]{8}$',
          'result': faker.pattern.fromRegex(r'^[A-F0-9]{8}$'),
          'description': 'Hex Code',
        },
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pattern Generation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Regex Pattern Generation',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Generate data matching specific regex patterns',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generatePatterns,
              icon: const Icon(Icons.pattern),
              label: const Text('Generate Pattern Examples'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        'Click button to generate patterns',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['description']!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pattern: ${item['pattern']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Result: ${item['result']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
