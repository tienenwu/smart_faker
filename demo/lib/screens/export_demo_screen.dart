import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class ExportDemoScreen extends StatefulWidget {
  const ExportDemoScreen({super.key});

  @override
  State<ExportDemoScreen> createState() => _ExportDemoScreenState();
}

class _ExportDemoScreenState extends State<ExportDemoScreen> {
  final faker = SmartFaker(seed: 12345);
  String _exportFormat = 'CSV';
  String _exportedData = '';
  List<Map<String, dynamic>> _generatedData = [];

  @override
  void initState() {
    super.initState();
    _generateSampleData();
  }

  void _generateSampleData() {
    _generatedData = List.generate(
      5,
      (index) => {
        'id': faker.random.uuid(),
        'firstName': faker.person.firstName(),
        'lastName': faker.person.lastName(),
        'email': faker.internet.email(),
        'phone': faker.phone.number(),
        'age': faker.random.integer(min: 18, max: 65),
        'company': faker.company.name(),
        'jobTitle': faker.person.jobTitle(),
        'salary': faker.finance.amount(min: 30000, max: 150000),
        'joinDate': faker.dateTime.past(years: 5).toIso8601String(),
        'isActive': faker.random.boolean(),
      },
    );
    _exportData();
  }

  void _exportData() {
    setState(() {
      switch (_exportFormat) {
        case 'CSV':
          _exportedData = faker.export.toCSV(_generatedData);
          break;
        case 'JSON':
          _exportedData = faker.export.toJSON(_generatedData, pretty: true);
          break;
        case 'SQL':
          _exportedData = faker.export.toSQL(_generatedData, table: 'users');
          break;
        case 'XML':
          _exportedData = faker.export.toXML(
            _generatedData,
            rootElement: 'users',
            itemElement: 'user',
          );
          break;
        case 'YAML':
          _exportedData = faker.export.toYAML(_generatedData);
          break;
        case 'Markdown':
          _exportedData = faker.export.toMarkdown(
            _generatedData,
            headers: ['firstName', 'lastName', 'email', 'jobTitle'],
          );
          break;
        case 'TSV':
          _exportedData = faker.export.toTSV(_generatedData);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Module Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateSampleData,
            tooltip: 'Generate New Data',
          ),
        ],
      ),
      body: Column(
        children: [
          // Format selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Export Format:'),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8,
                      children: [
                        'CSV',
                        'JSON',
                        'SQL',
                        'XML',
                        'YAML',
                        'Markdown',
                        'TSV',
                      ].map((format) {
                        return ChoiceChip(
                          label: Text(format),
                          selected: _exportFormat == format,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _exportFormat = format;
                                _exportData();
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Export preview
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exported Data ($_exportFormat)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _exportedData));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        tooltip: 'Copy to Clipboard',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SelectableText(
                        _exportedData,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info card
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Export Module Features',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Supports multiple export formats\n'
                      '• Memory-efficient streaming for large datasets\n'
                      '• Customizable headers and delimiters\n'
                      '• Handles complex data types (DateTime, Lists, Maps)\n'
                      '• Ready-to-use SQL INSERT statements',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
