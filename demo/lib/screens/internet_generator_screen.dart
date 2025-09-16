import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class InternetGeneratorScreen extends StatefulWidget {
  const InternetGeneratorScreen({super.key});

  @override
  State<InternetGeneratorScreen> createState() =>
      _InternetGeneratorScreenState();
}

class _InternetGeneratorScreenState extends State<InternetGeneratorScreen> {
  final SmartFaker faker = SmartFaker();

  // Email data
  String email = '';
  String safeEmail = '';
  String companyEmail = '';

  // Account data
  String username = '';
  String password = '';
  String strongPassword = '';

  // Web data
  String url = '';
  String domain = '';
  String ipv4 = '';
  String ipv6 = '';
  String macAddress = '';

  // User agent
  String userAgent = '';

  @override
  void initState() {
    super.initState();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      // Email generation
      email = faker.internet.email();
      safeEmail = faker.internet.safeEmail();
      companyEmail = faker.internet.companyEmail(companyName: 'TechCorp');

      // Account generation
      username = faker.internet.username();
      password = faker.internet.password();
      strongPassword = faker.internet.password(
        length: 16,
        includeSpecial: true,
      );

      // Web generation
      url = faker.internet.url(includePath: true);
      domain = faker.internet.domainName();
      ipv4 = faker.internet.ipv4();
      ipv6 = faker.internet.ipv6();
      macAddress = faker.internet.macAddress();

      // User agent
      userAgent = faker.internet.userAgent();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internet Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              title: 'Email Addresses',
              icon: Icons.email,
              children: [
                _buildCopiableRow('Email', email),
                _buildCopiableRow('Safe Email', safeEmail),
                _buildCopiableRow('Company Email', companyEmail),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: 'Account Credentials',
              icon: Icons.account_circle,
              children: [
                _buildCopiableRow('Username', username),
                _buildCopiableRow('Password', password),
                _buildCopiableRow('Strong Password', strongPassword),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: 'Web & Network',
              icon: Icons.language,
              children: [
                _buildCopiableRow('URL', url),
                _buildCopiableRow('Domain', domain),
                _buildCopiableRow('IPv4', ipv4),
                _buildCopiableRow('IPv6', ipv6),
                _buildCopiableRow('MAC Address', macAddress),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: 'User Agent',
              icon: Icons.devices,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userAgent,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            onPressed: () => _copyToClipboard(userAgent),
                            tooltip: 'Copy',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('Chrome'),
                      onPressed: () {
                        setState(() {
                          userAgent =
                              faker.internet.userAgent(browser: 'chrome');
                        });
                      },
                    ),
                    ActionChip(
                      label: const Text('Firefox'),
                      onPressed: () {
                        setState(() {
                          userAgent =
                              faker.internet.userAgent(browser: 'firefox');
                        });
                      },
                    ),
                    ActionChip(
                      label: const Text('Safari'),
                      onPressed: () {
                        setState(() {
                          userAgent =
                              faker.internet.userAgent(browser: 'safari');
                        });
                      },
                    ),
                    ActionChip(
                      label: const Text('Edge'),
                      onPressed: () {
                        setState(() {
                          userAgent = faker.internet.userAgent(browser: 'edge');
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateAll,
        label: const Text('Generate New'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildCopiableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () => _copyToClipboard(value),
            tooltip: 'Copy $label',
          ),
        ],
      ),
    );
  }
}
