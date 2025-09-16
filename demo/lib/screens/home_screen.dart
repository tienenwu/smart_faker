import 'package:flutter/material.dart';
import 'core_features_screen.dart';
import 'person_generator_screen.dart';
import 'internet_generator_screen.dart';
import 'location_generator_screen.dart';
import 'datetime_generator_screen.dart';
import 'commerce_generator_screen.dart';
import 'company_generator_screen.dart';
import 'finance_generator_screen.dart';
import 'vehicle_generator_screen.dart';
import 'lorem_generator_screen.dart';
import 'system_generator_screen.dart';
import 'image_generator_screen.dart';
import 'phone_generator_screen.dart';
import 'color_generator_screen.dart';
import 'crypto_generator_screen.dart';
import 'food_generator_screen.dart';
import 'music_generator_screen.dart';
import 'schema_demo_screen.dart';
import 'smart_relationships_screen.dart';
import 'export_demo_screen.dart';
import 'taiwan_demo_screen.dart';
import 'social_media_demo_screen.dart';
import 'ecommerce_demo_screen.dart';
import 'healthcare_demo_screen.dart';
import 'pattern_demo_screen.dart';
import 'schema_validation_demo_screen.dart';
import 'api_mocking_demo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFaker Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(context),
          const SizedBox(height: 16),
          _buildFeatureSection(
            context,
            title: 'Core Features',
            features: [
              FeatureTile(
                title: 'Core Configuration',
                subtitle: 'Random generation, seeding, and configuration',
                icon: Icons.settings,
                onTap: () => _navigateToScreen(
                  context,
                  const CoreFeaturesScreen(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureSection(
            context,
            title: 'Data Generators',
            features: [
              FeatureTile(
                title: 'Person Generator',
                subtitle: 'Names, ages, job titles, and more',
                icon: Icons.person,
                onTap: () => _navigateToScreen(
                  context,
                  const PersonGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Internet Data',
                subtitle: 'Emails, URLs, IP addresses, passwords',
                icon: Icons.language,
                onTap: () => _navigateToScreen(
                  context,
                  const InternetGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Location Generator',
                subtitle: 'Addresses, cities, coordinates',
                icon: Icons.location_on,
                onTap: () => _navigateToScreen(
                  context,
                  const LocationGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'DateTime Generator',
                subtitle: 'Dates, times, timestamps',
                icon: Icons.calendar_today,
                onTap: () => _navigateToScreen(
                  context,
                  const DateTimeGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Commerce Generator',
                subtitle: 'Products, prices, SKUs, colors',
                icon: Icons.shopping_cart,
                onTap: () => _navigateToScreen(
                  context,
                  const CommerceGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Company Generator',
                subtitle: 'Companies, industries, missions',
                icon: Icons.business,
                onTap: () => _navigateToScreen(
                  context,
                  const CompanyGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Finance Generator',
                subtitle: 'Cards, accounts, crypto, transactions',
                icon: Icons.account_balance,
                onTap: () => _navigateToScreen(
                  context,
                  const FinanceGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Vehicle Generator',
                subtitle: 'Vehicles, VINs, license plates',
                icon: Icons.directions_car,
                onTap: () => _navigateToScreen(
                  context,
                  const VehicleGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Lorem Generator',
                subtitle: 'Lorem ipsum text in multiple languages',
                icon: Icons.text_fields,
                onTap: () => _navigateToScreen(
                  context,
                  const LoremGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'System Generator',
                subtitle: 'Files, paths, versions, processes',
                icon: Icons.computer,
                onTap: () => _navigateToScreen(
                  context,
                  const SystemGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Image Generator',
                subtitle: 'Image URLs, colors, placeholders',
                icon: Icons.image,
                onTap: () => _navigateToScreen(
                  context,
                  const ImageGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Phone Generator',
                subtitle: 'Phone numbers, IMEI, devices',
                icon: Icons.phone,
                onTap: () => _navigateToScreen(
                  context,
                  const PhoneGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Color Generator',
                subtitle: 'Colors, schemes, palettes',
                icon: Icons.color_lens,
                onTap: () => _navigateToScreen(
                  context,
                  const ColorGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Crypto Generator',
                subtitle: 'Cryptocurrency and blockchain data',
                icon: Icons.currency_bitcoin,
                onTap: () => _navigateToScreen(
                  context,
                  const CryptoGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Food Generator',
                subtitle: 'Food, recipes, restaurants',
                icon: Icons.restaurant,
                onTap: () => _navigateToScreen(
                  context,
                  const FoodGeneratorScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Music Generator',
                subtitle: 'Music industry data',
                icon: Icons.music_note,
                onTap: () => _navigateToScreen(
                  context,
                  const MusicGeneratorScreen(),
                ),
                enabled: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureSection(
            context,
            title: 'Advanced Features',
            features: [
              FeatureTile(
                title: 'API Mocking (v0.4.0)',
                subtitle: 'Mock server with response templates',
                icon: Icons.api,
                onTap: () => _navigateToScreen(
                  context,
                  const ApiMockingDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Schema Builder',
                subtitle: 'Define custom data schemas',
                icon: Icons.account_tree,
                onTap: () => _navigateToScreen(
                  context,
                  const SchemaDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Schema Validation',
                subtitle: 'Custom regex patterns for field validation',
                icon: Icons.verified_user,
                onTap: () => _navigateToScreen(
                  context,
                  const SchemaValidationDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Smart Relationships',
                subtitle: 'Context-aware data generation',
                icon: Icons.link,
                onTap: () => _navigateToScreen(
                  context,
                  const SmartRelationshipsScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Export Module',
                subtitle: 'Export data to CSV, JSON, SQL, XML, YAML',
                icon: Icons.download,
                onTap: () => _navigateToScreen(
                  context,
                  const ExportDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Taiwan Module',
                subtitle: 'Taiwan-specific data generation',
                icon: Icons.flag,
                onTap: () => _navigateToScreen(
                  context,
                  const TaiwanDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Social Media Module',
                subtitle: 'Social media profiles, posts, and engagement',
                icon: Icons.share,
                onTap: () => _navigateToScreen(
                  context,
                  const SocialMediaDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'E-commerce Module',
                subtitle: 'Orders, products, shipping, and reviews',
                icon: Icons.shopping_cart,
                onTap: () => _navigateToScreen(
                  context,
                  const EcommerceDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Healthcare Module',
                subtitle: 'Medical records, appointments, and healthcare data',
                icon: Icons.local_hospital,
                onTap: () => _navigateToScreen(
                  context,
                  const HealthcareDemoScreen(),
                ),
                enabled: true,
              ),
              FeatureTile(
                title: 'Pattern Module',
                subtitle: 'Generate data from regex patterns',
                icon: Icons.pattern,
                onTap: () => _navigateToScreen(
                  context,
                  const PatternDemoScreen(),
                ),
                enabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Welcome to SmartFaker',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'An intelligent test data generator for Flutter/Dart with advanced features like schema-based generation, smart relationships, and comprehensive internationalization support.',
            ),
            const SizedBox(height: 8),
            Text(
              'Version: 0.4.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection(
    BuildContext context, {
    required String title,
    required List<FeatureTile> features,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...features.map((feature) => feature),
      ],
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'SmartFaker Demo',
      applicationVersion: '0.4.0',
      applicationLegalese: '© 2024 SmartFaker',
      children: const [
        SizedBox(height: 16),
        Text(
          'SmartFaker is an intelligent test data generator for Flutter/Dart, '
          'inspired by Faker.js but with advanced features tailored for Flutter development.',
        ),
      ],
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: enabled
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).disabledColor.withOpacity(0.12),
          child: Icon(
            icon,
            color: enabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).disabledColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: enabled ? null : Theme.of(context).disabledColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: enabled ? null : Theme.of(context).disabledColor,
          ),
        ),
        trailing: Icon(
          enabled ? Icons.arrow_forward_ios : Icons.lock_outline,
          size: 16,
        ),
        enabled: enabled,
        onTap: onTap,
      ),
    );
  }
}
