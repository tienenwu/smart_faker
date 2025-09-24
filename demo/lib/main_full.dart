import 'package:flutter/material.dart';
import 'package:smart_faker/smart_faker.dart';
import 'dart:convert';

// Import all screens
import 'screens/api_mocking_demo_screen.dart';
import 'screens/person_generator_screen.dart';
import 'screens/internet_generator_screen.dart';
import 'screens/location_generator_screen.dart';
import 'screens/company_generator_screen.dart';
import 'screens/commerce_generator_screen.dart';
import 'screens/finance_generator_screen.dart';
import 'screens/datetime_generator_screen.dart';
import 'screens/lorem_generator_screen.dart';
import 'screens/color_generator_screen.dart';
import 'screens/image_generator_screen.dart';
import 'screens/food_generator_screen.dart';
import 'screens/vehicle_generator_screen.dart';
import 'screens/music_generator_screen.dart';
import 'screens/movie_generator_screen.dart';
import 'screens/book_generator_screen.dart';
import 'screens/game_generator_screen.dart';
import 'screens/phone_generator_screen.dart';
import 'screens/healthcare_generator_screen.dart';
import 'screens/education_generator_screen.dart';
import 'screens/system_generator_screen.dart';
import 'screens/taiwan_generator_screen.dart';
import 'screens/core_features_screen.dart';
import 'screens/smart_relationships_screen.dart';
import 'screens/schema_demo_screen.dart';
import 'screens/export_demo_screen.dart';
import 'screens/pattern_demo_screen.dart';
import 'screens/social_media_demo_screen.dart';
import 'screens/schema_validation_demo_screen.dart';

void main() {
  runApp(const SmartFakerFullDemoApp());
}

class SmartFakerFullDemoApp extends StatefulWidget {
  const SmartFakerFullDemoApp({super.key});

  @override
  State<SmartFakerFullDemoApp> createState() => _SmartFakerFullDemoAppState();
}

class _SmartFakerFullDemoAppState extends State<SmartFakerFullDemoApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
      // Update SmartFaker locale
      SmartFaker().setLocale(locale.languageCode == 'zh'
          ? 'zh_TW'
          : locale.languageCode == 'ja'
              ? 'ja'
              : 'en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFaker Demo',
      locale: _locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: FullMenuScreen(
          onLanguageChange: _changeLanguage, currentLocale: _locale),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FullMenuScreen extends StatelessWidget {
  final Function(Locale) onLanguageChange;
  final Locale currentLocale;

  const FullMenuScreen({
    super.key,
    required this.onLanguageChange,
    required this.currentLocale,
  });

  String _getTitle() {
    switch (currentLocale.languageCode) {
      case 'zh':
        return 'SmartFaker 示範';
      case 'ja':
        return 'SmartFaker デモ';
      default:
        return 'SmartFaker Demo';
    }
  }

  String _getSubtitle() {
    switch (currentLocale.languageCode) {
      case 'zh':
        return '智慧測試資料生成器';
      case 'ja':
        return 'インテリジェントテストデータジェネレーター';
      default:
        return 'Intelligent Test Data Generator';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: onLanguageChange,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Row(
                  children: [
                    Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('English'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('zh'),
                child: Row(
                  children: [
                    Text('🇹🇼', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('繁體中文'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('ja'),
                child: Row(
                  children: [
                    Text('🇯🇵', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('日本語'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SmartFaker v0.5.0',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_getSubtitle()),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('English')),
                      Chip(label: Text('繁體中文')),
                      Chip(label: Text('日本語')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Core Features Section
          _buildSectionTitle(context, _getSectionTitle('core')),
          _buildMenuTile(
              context, 'Core Features', Icons.settings, SimplifiedCoreScreen()),
          _buildMenuTile(context, 'Smart Relationships', Icons.link,
              SimplifiedSmartRelationshipsScreen()),
          _buildMenuTile(context, 'Schema Generation', Icons.schema,
              SimplifiedSchemaScreen()),

          // NEW in v0.5.0
          _buildSectionTitle(context, _getSectionTitle('new')),
          _buildMenuTile(
              context, 'API Mocking', Icons.api, const ApiMockingDemoScreen()),

          // v0.3.0 Features
          _buildSectionTitle(context, _getSectionTitle('v03')),
          _buildMenuTile(context, 'Pattern Generation', Icons.pattern,
              SimplifiedPatternScreen()),
          _buildMenuTile(context, 'Schema Validation', Icons.verified,
              SimplifiedSchemaValidationScreen()),

          // v0.2.0 Features
          _buildSectionTitle(context, _getSectionTitle('v02')),
          _buildMenuTile(context, 'Export Module', Icons.download,
              SimplifiedExportScreen()),
          _buildMenuTile(
              context, 'Taiwan Module', Icons.flag, SimplifiedTaiwanScreen()),

          // Data Generators
          _buildSectionTitle(context, _getSectionTitle('generators')),
          _buildMenuTile(
              context, 'Person', Icons.person, SimplifiedPersonScreen()),
          _buildMenuTile(
              context, 'Internet', Icons.wifi, SimplifiedInternetScreen()),
          _buildMenuTile(context, 'Location', Icons.location_on,
              SimplifiedLocationScreen()),
          _buildMenuTile(
              context, 'Company', Icons.business, SimplifiedCompanyScreen()),
          _buildMenuTile(context, 'Commerce', Icons.shopping_cart,
              SimplifiedCommerceScreen()),
          _buildMenuTile(context, 'Finance', Icons.attach_money,
              SimplifiedFinanceScreen()),
          _buildMenuTile(context, 'DateTime', Icons.access_time,
              SimplifiedDateTimeScreen()),
          _buildMenuTile(
              context, 'Lorem', Icons.text_fields, SimplifiedLoremScreen()),
          _buildMenuTile(context, 'Healthcare', Icons.local_hospital,
              SimplifiedHealthcareScreen()),
          _buildMenuTile(
              context, 'Phone', Icons.phone, SimplifiedPhoneScreen()),
          _buildMenuTile(context, 'Social Media', Icons.share,
              SimplifiedSocialMediaScreen()),
        ],
      ),
    );
  }

  String _getSectionTitle(String section) {
    switch (currentLocale.languageCode) {
      case 'zh':
        switch (section) {
          case 'core':
            return '🎯 核心功能';
          case 'new':
            return '🚀 v0.5.0 新功能';
          case 'v03':
            return '✨ v0.3.0 功能';
          case 'v02':
            return '📦 v0.2.0 功能';
          case 'generators':
            return '📊 資料生成器';
          default:
            return section;
        }
      case 'ja':
        switch (section) {
          case 'core':
            return '🎯 コア機能';
          case 'new':
            return '🚀 v0.5.0 新機能';
          case 'v03':
            return '✨ v0.3.0 機能';
          case 'v02':
            return '📦 v0.2.0 機能';
          case 'generators':
            return '📊 データジェネレーター';
          default:
            return section;
        }
      default:
        switch (section) {
          case 'core':
            return '🎯 Core Features';
          case 'new':
            return '🚀 New in v0.5.0';
          case 'v03':
            return '✨ v0.3.0 Features';
          case 'v02':
            return '📦 v0.2.0 Features';
          case 'generators':
            return '📊 Data Generators';
          default:
            return section;
        }
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _buildMenuTile(
      BuildContext context, String title, IconData icon, Widget screen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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

// Simplified screens that work with Flutter 3.0
class SimplifiedCoreScreen extends StatelessWidget {
  final SmartFaker faker = SmartFaker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Core Features')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text('Seed: ${faker.seed}'),
              subtitle: const Text('Reproducible random data'),
              trailing: ElevatedButton(
                onPressed: () {
                  faker.setSeed(DateTime.now().millisecondsSinceEpoch);
                },
                child: const Text('New Seed'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimplifiedSmartRelationshipsScreen extends StatefulWidget {
  @override
  State<SimplifiedSmartRelationshipsScreen> createState() =>
      _SimplifiedSmartRelationshipsScreenState();
}

class _SimplifiedSmartRelationshipsScreenState
    extends State<SimplifiedSmartRelationshipsScreen> {
  final SmartFaker faker = SmartFaker();
  Map<String, dynamic> familyData = {};

  void _generateFamily() {
    setState(() {
      final parent = faker.person.fullName();
      familyData = {
        'Parent': parent,
        'Child 1': faker.person.fullName(),
        'Child 2': faker.person.fullName(),
        'Address': faker.location.fullAddress(),
        'Phone': faker.phone.phoneNumber(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Relationships')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generateFamily,
              icon: const Icon(Icons.family_restroom),
              label: const Text('Generate Family'),
            ),
            const SizedBox(height: 16),
            if (familyData.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: familyData.entries
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text('${e.key}: ${e.value}'),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SimplifiedSchemaScreen extends StatefulWidget {
  @override
  State<SimplifiedSchemaScreen> createState() => _SimplifiedSchemaScreenState();
}

class _SimplifiedSchemaScreenState extends State<SimplifiedSchemaScreen> {
  String generatedJson = '';

  void _generateFromSchema() {
    final generator = ResponseGenerator();
    final schema = {
      'id': '@uuid',
      'name': '@person.fullName',
      'email': '@internet.email',
      'age': '@number.int:65',
    };

    final data = generator.generate(schema);
    setState(() {
      generatedJson = const JsonEncoder.withIndent('  ').convert(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schema Generation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generateFromSchema,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Generate from Schema'),
            ),
            const SizedBox(height: 16),
            if (generatedJson.isNotEmpty)
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      generatedJson,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12),
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

class SimplifiedPatternScreen extends StatefulWidget {
  @override
  State<SimplifiedPatternScreen> createState() =>
      _SimplifiedPatternScreenState();
}

class _SimplifiedPatternScreenState extends State<SimplifiedPatternScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> results = [];

  void _generatePatterns() {
    setState(() {
      results = [
        'License: ${faker.pattern.fromRegex(r'^[A-Z]{3}-\d{4}$')}',
        'Date: ${faker.pattern.fromRegex(r'^\d{4}-\d{2}-\d{2}$')}',
        'Phone: ${faker.pattern.fromRegex(r'^\+1-\d{3}-\d{3}-\d{4}$')}',
        'Hex: ${faker.pattern.fromRegex(r'^[A-F0-9]{8}$')}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pattern Generation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generatePatterns,
              icon: const Icon(Icons.pattern),
              label: const Text('Generate Patterns'),
            ),
            const SizedBox(height: 16),
            ...results.map((r) => Card(
                  child: ListTile(title: Text(r)),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedSchemaValidationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schema Validation')),
      body: Center(
        child: Text('Schema validation features'),
      ),
    );
  }
}

class SimplifiedExportScreen extends StatefulWidget {
  @override
  State<SimplifiedExportScreen> createState() => _SimplifiedExportScreenState();
}

class _SimplifiedExportScreenState extends State<SimplifiedExportScreen> {
  final SmartFaker faker = SmartFaker();
  String exportedData = '';
  String format = 'JSON';

  void _export(String fmt) {
    final data = List.generate(
        3,
        (i) => {
              'id': faker.datatype.uuid(),
              'name': faker.person.fullName(),
              'email': faker.internet.email(),
            });

    final exporter = ExportModule();
    setState(() {
      format = fmt;
      switch (fmt) {
        case 'CSV':
          exportedData = exporter.toCSV(data);
          break;
        case 'JSON':
          exportedData = exporter.toJSON(data, pretty: true);
          break;
        case 'SQL':
          exportedData = exporter.toSQL(data, table: 'users');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Module')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _export('JSON'),
                  child: const Text('JSON'),
                ),
                ElevatedButton(
                  onPressed: () => _export('CSV'),
                  child: const Text('CSV'),
                ),
                ElevatedButton(
                  onPressed: () => _export('SQL'),
                  child: const Text('SQL'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (exportedData.isNotEmpty)
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      exportedData,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 10),
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

class SimplifiedTaiwanScreen extends StatefulWidget {
  @override
  State<SimplifiedTaiwanScreen> createState() => _SimplifiedTaiwanScreenState();
}

class _SimplifiedTaiwanScreenState extends State<SimplifiedTaiwanScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        '身分證: ${faker.taiwan.idNumber()}',
        '統編: ${faker.taiwan.companyId()}',
        '手機: ${faker.phone.phoneNumber()}',
        '市話: ${faker.taiwan.landlineNumber()}',
        '郵遞區號: ${faker.taiwan.postalCode()}',
        '車牌: ${faker.taiwan.licensePlate()}',
        '銀行帳號: ${faker.taiwan.bankAccount()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taiwan Module')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.flag),
              label: const Text('Generate Taiwan Data'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// Other simplified generator screens
class SimplifiedPersonScreen extends StatefulWidget {
  @override
  State<SimplifiedPersonScreen> createState() => _SimplifiedPersonScreenState();
}

class _SimplifiedPersonScreenState extends State<SimplifiedPersonScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Name: ${faker.person.fullName()}',
        'First: ${faker.person.firstName()}',
        'Last: ${faker.person.lastName()}',
        'Job: ${faker.person.jobTitle()}',
        'Bio: ${faker.person.bio()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Person Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.person),
              label: const Text('Generate Person'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(d),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedInternetScreen extends StatefulWidget {
  @override
  State<SimplifiedInternetScreen> createState() =>
      _SimplifiedInternetScreenState();
}

class _SimplifiedInternetScreenState extends State<SimplifiedInternetScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Email: ${faker.internet.email()}',
        'Username: ${faker.internet.username()}',
        'Password: ${faker.internet.password()}',
        'URL: ${faker.internet.url()}',
        'Domain: ${faker.internet.domainName()}',
        'IP: ${faker.internet.ipAddress()}',
        'IPv6: ${faker.internet.ipv6Address()}',
        'MAC: ${faker.internet.macAddress()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Internet Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.wifi),
              label: const Text('Generate Internet Data'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedLocationScreen extends StatefulWidget {
  @override
  State<SimplifiedLocationScreen> createState() =>
      _SimplifiedLocationScreenState();
}

class _SimplifiedLocationScreenState extends State<SimplifiedLocationScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Address: ${faker.location.fullAddress()}',
        'Street: ${faker.location.street()}',
        'City: ${faker.location.city()}',
        'State: ${faker.location.state()}',
        'Country: ${faker.location.country()}',
        'Zip: ${faker.location.zipCode()}',
        'Lat: ${faker.location.latitude()}',
        'Lng: ${faker.location.longitude()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.location_on),
              label: const Text('Generate Location'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedCompanyScreen extends StatefulWidget {
  @override
  State<SimplifiedCompanyScreen> createState() =>
      _SimplifiedCompanyScreenState();
}

class _SimplifiedCompanyScreenState extends State<SimplifiedCompanyScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Name: ${faker.company.name()}',
        'Slogan: ${faker.company.catchPhrase()}',
        'Industry: ${faker.company.industry()}',
        'Type: ${faker.company.companyType()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.business),
              label: const Text('Generate Company'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedCommerceScreen extends StatefulWidget {
  @override
  State<SimplifiedCommerceScreen> createState() =>
      _SimplifiedCommerceScreenState();
}

class _SimplifiedCommerceScreenState extends State<SimplifiedCommerceScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Product: ${faker.commerce.productName()}',
        'Price: \$${faker.commerce.price()}',
        'Category: ${faker.commerce.category()}',
        'Brand: ${faker.commerce.brand()}',
        'SKU: ${faker.commerce.sku()}',
        'Description: ${faker.commerce.productDescription()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commerce Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Generate Commerce'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(d),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedFinanceScreen extends StatefulWidget {
  @override
  State<SimplifiedFinanceScreen> createState() =>
      _SimplifiedFinanceScreenState();
}

class _SimplifiedFinanceScreenState extends State<SimplifiedFinanceScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Account: ${faker.finance.accountNumber()}',
        'IBAN: ${faker.finance.iban()}',
        'BIC: ${faker.finance.bic()}',
        'Currency: ${faker.finance.currencyCode()}',
        'Amount: ${faker.finance.amount()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.attach_money),
              label: const Text('Generate Finance'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedDateTimeScreen extends StatefulWidget {
  @override
  State<SimplifiedDateTimeScreen> createState() =>
      _SimplifiedDateTimeScreenState();
}

class _SimplifiedDateTimeScreenState extends State<SimplifiedDateTimeScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Recent: ${faker.date.recent()}',
        'Past: ${faker.date.past()}',
        'Future: ${faker.date.future()}',
        'Between: ${faker.date.between(DateTime(2020, 1, 1), DateTime(2025, 12, 31))}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DateTime Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.access_time),
              label: const Text('Generate DateTime'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedLoremScreen extends StatefulWidget {
  @override
  State<SimplifiedLoremScreen> createState() => _SimplifiedLoremScreenState();
}

class _SimplifiedLoremScreenState extends State<SimplifiedLoremScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Word: ${faker.lorem.word()}',
        'Words: ${faker.lorem.words(5)}',
        'Sentence: ${faker.lorem.sentence()}',
        'Paragraph: ${faker.lorem.paragraph()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lorem Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.text_fields),
              label: const Text('Generate Lorem'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(d),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedHealthcareScreen extends StatefulWidget {
  @override
  State<SimplifiedHealthcareScreen> createState() =>
      _SimplifiedHealthcareScreenState();
}

class _SimplifiedHealthcareScreenState
    extends State<SimplifiedHealthcareScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Patient ID: ${faker.healthcare.patientId()}',
        'MRN: ${faker.healthcare.medicalRecordNumber()}',
        'Blood Type: ${faker.healthcare.bloodType()}',
        'Condition: ${faker.healthcare.medicalCondition()}',
        'Medication: ${faker.healthcare.medication()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Healthcare Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.local_hospital),
              label: const Text('Generate Healthcare'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedPhoneScreen extends StatefulWidget {
  @override
  State<SimplifiedPhoneScreen> createState() => _SimplifiedPhoneScreenState();
}

class _SimplifiedPhoneScreenState extends State<SimplifiedPhoneScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Phone: ${faker.phone.phoneNumber()}',
        'Format: ${faker.phone.phoneNumberFormat()}',
        'IMEI: ${faker.phone.imei()}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.phone),
              label: const Text('Generate Phone'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SimplifiedSocialMediaScreen extends StatefulWidget {
  @override
  State<SimplifiedSocialMediaScreen> createState() =>
      _SimplifiedSocialMediaScreenState();
}

class _SimplifiedSocialMediaScreenState
    extends State<SimplifiedSocialMediaScreen> {
  final SmartFaker faker = SmartFaker();
  List<String> data = [];

  void _generate() {
    setState(() {
      data = [
        'Post: Lorem ipsum...',
        'Hashtags: #faker #demo #flutter',
        'Likes: ${faker.datatype.number(min: 0, max: 10000)}',
        'Comments: ${faker.datatype.number(min: 0, max: 500)}',
        'Shares: ${faker.datatype.number(min: 0, max: 1000)}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Media Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.share),
              label: const Text('Generate Social Media'),
            ),
            const SizedBox(height: 16),
            ...data.map((d) => Card(
                  child: ListTile(
                    title: Text(d),
                    dense: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
