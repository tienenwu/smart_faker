import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class PhoneGeneratorScreen extends StatefulWidget {
  const PhoneGeneratorScreen({super.key});

  @override
  State<PhoneGeneratorScreen> createState() => _PhoneGeneratorScreenState();
}

class _PhoneGeneratorScreenState extends State<PhoneGeneratorScreen> {
  late SmartFaker faker;
  String currentLocale = 'en_US';

  // Phone data
  String phoneNumber = '';
  String mobileNumber = '';
  String internationalNumber = '';
  String tollFreeNumber = '';
  String formattedNumber = '';
  String phoneExtension = '';

  // Device data
  String imei = '';
  String imsi = '';
  String phoneModel = '';
  String manufacturer = '';
  String osVersion = '';

  // Code data
  String countryCode = '';
  String areaCode = '';

  @override
  void initState() {
    super.initState();
    faker = SmartFaker(locale: currentLocale);
    _generateAllData();
  }

  void _generateAllData() {
    setState(() {
      // Phone numbers
      phoneNumber = faker.phone.number();
      mobileNumber = faker.phone.mobile();
      internationalNumber = faker.phone.international();
      tollFreeNumber = faker.phone.tollFree();
      formattedNumber = faker.phone.formatted();
      phoneExtension = faker.phone.extension();

      // Device info
      imei = faker.phone.imei();
      imsi = faker.phone.imsi();
      phoneModel = faker.phone.model();
      manufacturer = faker.phone.manufacturer();
      osVersion = faker.phone.osVersion();

      // Codes
      countryCode = faker.phone.countryCode();
      areaCode = faker.phone.areaCode();
    });
  }

  void _changeLocale(String locale) {
    setState(() {
      currentLocale = locale;
      faker.setLocale(locale);
      _generateAllData();
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Locale Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Locale Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('English (US)'),
                        selected: currentLocale == 'en_US',
                        onSelected: (_) => _changeLocale('en_US'),
                      ),
                      ChoiceChip(
                        label: const Text('中文 (繁體)'),
                        selected: currentLocale == 'zh_TW',
                        onSelected: (_) => _changeLocale('zh_TW'),
                      ),
                      ChoiceChip(
                        label: const Text('日本語'),
                        selected: currentLocale == 'ja_JP',
                        onSelected: (_) => _changeLocale('ja_JP'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Phone Numbers Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Numbers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneItem('Phone Number', phoneNumber, Icons.phone),
                  _buildPhoneItem('Mobile', mobileNumber, Icons.phone_android),
                  _buildPhoneItem(
                      'International', internationalNumber, Icons.language),
                  _buildPhoneItem(
                      'Toll-Free', tollFreeNumber, Icons.phone_forwarded),
                  _buildPhoneItem(
                      'Formatted', formattedNumber, Icons.format_list_numbered),
                  _buildPhoneItem('Extension', phoneExtension, Icons.dialpad),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Device Information Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Device Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneItem('IMEI', imei, Icons.sim_card),
                  _buildPhoneItem('IMSI', imsi, Icons.sim_card_alert),
                  _buildPhoneItem('Model', phoneModel, Icons.phone_iphone),
                  _buildPhoneItem('Manufacturer', manufacturer, Icons.business),
                  _buildPhoneItem('OS Version', osVersion, Icons.system_update),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Codes Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Codes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneItem('Country Code', countryCode, Icons.flag),
                  _buildPhoneItem('Area Code', areaCode, Icons.location_on),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildPhoneItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _copyToClipboard(value, label),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.copy, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
