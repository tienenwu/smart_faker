import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class CompanyGeneratorScreen extends StatefulWidget {
  const CompanyGeneratorScreen({super.key});

  @override
  State<CompanyGeneratorScreen> createState() => _CompanyGeneratorScreenState();
}

class _CompanyGeneratorScreenState extends State<CompanyGeneratorScreen> {
  late SmartFaker faker;
  String currentLocale = 'en_US';
  
  // Company basics
  String companyName = '';
  String companySuffix = '';
  String companyNameWithSuffix = '';
  
  // Company details
  String catchphrase = '';
  String buzzword = '';
  String bs = '';
  String industry = '';
  String department = '';
  
  // Company identifiers
  String ein = '';
  String dunsNumber = '';
  String sicCode = '';
  String naicsCode = '';
  
  // Company size
  String companySize = '';
  int employeeCount = 0;
  String employeeCountRange = '';
  String revenueRange = '';
  
  // Mission and values
  String missionStatement = '';
  List<String> companyValues = [];

  @override
  void initState() {
    super.initState();
    faker = SmartFaker(locale: currentLocale);
    _generateAllData();
  }

  void _setLocale(String locale) {
    setState(() {
      currentLocale = locale;
      faker.setLocale(locale);
      _generateAllData();
    });
  }

  void _generateAllData() {
    setState(() {
      // Company basics
      companyName = faker.company.name();
      companySuffix = faker.company.suffix();
      companyNameWithSuffix = faker.company.nameWithSuffix();
      
      // Company details
      catchphrase = faker.company.catchphrase();
      buzzword = faker.company.buzzword();
      bs = faker.company.bs();
      industry = faker.company.industry();
      department = faker.company.department();
      
      // Company identifiers
      ein = faker.company.ein();
      dunsNumber = faker.company.dunsNumber();
      sicCode = faker.company.sicCode();
      naicsCode = faker.company.naicsCode();
      
      // Company size
      companySize = faker.company.companySize();
      employeeCount = faker.company.employeeCount();
      employeeCountRange = faker.company.employeeCountRange();
      revenueRange = faker.company.revenueRange();
      
      // Mission and values
      missionStatement = faker.company.missionStatement();
      companyValues = faker.company.values();
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: currentLocale,
              underline: Container(),
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Theme.of(context).colorScheme.primary,
              items: const [
                DropdownMenuItem(
                  value: 'en_US',
                  child: Text('🇺🇸 English', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'zh_TW',
                  child: Text('🇹🇼 繁體中文', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'ja_JP',
                  child: Text('🇯🇵 日本語', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _setLocale(value);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCompanyBasicsCard(),
          const SizedBox(height: 16),
          _buildCompanyDetailsCard(),
          const SizedBox(height: 16),
          _buildIdentifiersCard(),
          const SizedBox(height: 16),
          _buildCompanySizeCard(),
          const SizedBox(height: 16),
          _buildCatchphraseCard(),
          const SizedBox(height: 16),
          _buildMissionCard(),
          const SizedBox(height: 16),
          _buildValuesCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCompanyBasicsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Name', companyName),
            _buildField('Suffix', companySuffix),
            _buildField('Full Name', companyNameWithSuffix),
            _buildField('Industry', industry),
            _buildField('Department', department),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Speak',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Buzzword', buzzword),
            _buildField('BS', bs),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentifiersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Identifiers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('EIN', ein),
            _buildField('DUNS', dunsNumber),
            _buildField('SIC Code', sicCode),
            _buildField('NAICS Code', naicsCode),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanySizeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Size Category', companySize),
            _buildField('Employee Count', employeeCount.toString()),
            _buildField('Employee Range', employeeCountRange),
            _buildField('Revenue Range', revenueRange),
            const SizedBox(height: 8),
            _buildSizeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeIndicator() {
    final sizes = ['Startup', 'Small', 'Medium', 'Large', 'Enterprise'];
    final index = sizes.indexOf(companySize);
    final progress = index >= 0 ? (index + 1) / sizes.length : 0.0;
    
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: sizes.map((size) {
            return Text(
              size,
              style: TextStyle(
                fontSize: 10,
                fontWeight: size == companySize ? FontWeight.bold : FontWeight.normal,
                color: size == companySize 
                    ? Theme.of(context).colorScheme.secondary 
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCatchphraseCard() {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Company Catchphrase',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(catchphrase, 'Catchphrase'),
                  tooltip: 'Copy to clipboard',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '"$catchphrase"',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mission Statement',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(missionStatement, 'Mission'),
                  tooltip: 'Copy to clipboard',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              missionStatement,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValuesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Values',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: companyValues.map((value) {
                return Chip(
                  label: Text(value),
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _copyToClipboard(value, label),
              child: Text(
                value,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}