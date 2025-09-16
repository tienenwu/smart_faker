import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class PatternDemoScreen extends StatefulWidget {
  const PatternDemoScreen({super.key});

  @override
  State<PatternDemoScreen> createState() => _PatternDemoScreenState();
}

class _PatternDemoScreenState extends State<PatternDemoScreen> {
  final SmartFaker faker = SmartFaker();
  final TextEditingController _regexController = TextEditingController();
  String _customResult = '';
  String _errorMessage = '';

  @override
  void dispose() {
    _regexController.dispose();
    super.dispose();
  }

  void _generateCustomPattern() {
    setState(() {
      _errorMessage = '';
      _customResult = '';
      try {
        if (_regexController.text.isNotEmpty) {
          _customResult = faker.pattern.fromRegex(_regexController.text);
        }
      } catch (e) {
        _errorMessage = 'Error: ${e.toString()}';
      }
    });
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildPatternItem({
    required String label,
    required String Function() generator,
    IconData? icon,
  }) {
    final value = generator();
    return Card(
      color: Colors.grey.shade200,
      child: ListTile(
        leading: Icon(icon ?? Icons.pattern),
        title: Text(label),
        subtitle: Text(
          value,
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied $label'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pattern Module Demo'),
      ),
      body: ListView(
        children: [
          // Custom Pattern Section
          _buildSection(
            'Custom Regex Pattern',
            [
              TextField(
                controller: _regexController,
                decoration: InputDecoration(
                  labelText: 'Enter Regex Pattern',
                  hintText: r'^[A-Z]{3}-\d{4}$',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: _generateCustomPattern,
                  ),
                ),
                onSubmitted: (_) => _generateCustomPattern(),
              ),
              if (_customResult.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Result: $_customResult',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
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
                      Expanded(child: Text(_errorMessage)),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Phone Numbers
          _buildSection(
            'Phone Numbers',
            [
              _buildPatternItem(
                label: 'Taiwan Phone',
                generator: () => faker.pattern.taiwanPhone(),
                icon: Icons.phone,
              ),
              _buildPatternItem(
                label: 'US Phone',
                generator: () => faker.pattern.usPhone(),
                icon: Icons.phone,
              ),
              _buildPatternItem(
                label: 'Japan Phone',
                generator: () => faker.pattern.japanPhone(),
                icon: Icons.phone,
              ),
            ],
          ),

          // Identity & IDs
          _buildSection(
            'Identity & IDs',
            [
              _buildPatternItem(
                label: 'Taiwan ID Format',
                generator: () => faker.pattern.taiwanIdFormat(),
                icon: Icons.badge,
              ),
              _buildPatternItem(
                label: 'Order ID',
                generator: () => faker.pattern.orderIdFormat(),
                icon: Icons.receipt,
              ),
              _buildPatternItem(
                label: 'Invoice (2025)',
                generator: () => faker.pattern.invoiceFormat(year: 2025),
                icon: Icons.description,
              ),
              _buildPatternItem(
                label: 'SKU',
                generator: () => faker.pattern.skuFormat(),
                icon: Icons.inventory_2,
              ),
              _buildPatternItem(
                label: 'Tracking Number',
                generator: () => faker.pattern.trackingNumberFormat(),
                icon: Icons.local_shipping,
              ),
              _buildPatternItem(
                label: 'UUID',
                generator: () => faker.pattern.uuidFormat(),
                icon: Icons.fingerprint,
              ),
            ],
          ),

          // Financial
          _buildSection(
            'Financial',
            [
              _buildPatternItem(
                label: 'Visa Card',
                generator: () => faker.pattern.visaFormat(),
                icon: Icons.credit_card,
              ),
              _buildPatternItem(
                label: 'Mastercard',
                generator: () => faker.pattern.mastercardFormat(),
                icon: Icons.credit_card,
              ),
            ],
          ),

          // Technical
          _buildSection(
            'Technical',
            [
              _buildPatternItem(
                label: 'Email Format',
                generator: () => faker.pattern.emailFormat(),
                icon: Icons.email,
              ),
              _buildPatternItem(
                label: 'IPv4 Address',
                generator: () => faker.pattern.ipv4Format(),
                icon: Icons.network_wifi,
              ),
              _buildPatternItem(
                label: 'MAC Address',
                generator: () => faker.pattern.macAddressFormat(),
                icon: Icons.router,
              ),
              _buildPatternItem(
                label: 'Hex Color',
                generator: () => faker.pattern.hexColorFormat(),
                icon: Icons.palette,
              ),
            ],
          ),

          // Other
          _buildSection(
            'Other Patterns',
            [
              _buildPatternItem(
                label: 'License Plate',
                generator: () => faker.pattern.licensePlateFormat(),
                icon: Icons.directions_car,
              ),
            ],
          ),

          // Examples
          _buildSection(
            'Regex Examples',
            [
              const Text('Common patterns you can try:'),
              const SizedBox(height: 8),
              ...[
                r'^\d{5}$  — 5 digits',
                r'^[A-Z]{3}-\d{4}$  — AAA-1234',
                r'^09\d{8}$  — Taiwan mobile',
                r'^(RED|BLUE|GREEN)$  — Color choice',
                r'^[a-z]+@(gmail|yahoo)\.com$  — Email',
                r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$  — IP',
              ].map((example) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              example,
                              style: const TextStyle(
                                  fontFamily: 'monospace', fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.content_copy, size: 16),
                            onPressed: () {
                              final pattern = example.split('  —')[0].trim();
                              _regexController.text = pattern;
                              _generateCustomPattern();
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
