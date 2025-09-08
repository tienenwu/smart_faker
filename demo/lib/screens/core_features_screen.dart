import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';
import '../widgets/code_viewer.dart';
import '../widgets/copy_button.dart';

class CoreFeaturesScreen extends StatefulWidget {
  const CoreFeaturesScreen({super.key});

  @override
  State<CoreFeaturesScreen> createState() => _CoreFeaturesScreenState();
}

class _CoreFeaturesScreenState extends State<CoreFeaturesScreen> {
  late SmartFaker faker;
  int? currentSeed;
  final List<GeneratedData> generatedData = [];

  @override
  void initState() {
    super.initState();
    faker = SmartFaker();
  }

  void _generateWithSeed() {
    final seed = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      currentSeed = seed;
      faker = SmartFaker(seed: seed);
      _generateRandomData();
    });
  }

  void _generateWithoutSeed() {
    setState(() {
      currentSeed = null;
      faker = SmartFaker();
      _generateRandomData();
    });
  }

  void _generateRandomData() {
    setState(() {
      generatedData.clear();
      generatedData.addAll([
        GeneratedData(
          label: 'UUID',
          value: faker.random.uuid(),
          code: 'faker.random.uuid()',
        ),
        GeneratedData(
          label: 'Integer (0-100)',
          value: faker.random.integer(max: 100).toString(),
          code: 'faker.random.integer(max: 100)',
        ),
        GeneratedData(
          label: 'Decimal (0.0-10.0)',
          value: faker.random.decimal(max: 10.0).toStringAsFixed(2),
          code: 'faker.random.decimal(max: 10.0)',
        ),
        GeneratedData(
          label: 'Boolean',
          value: faker.random.boolean().toString(),
          code: 'faker.random.boolean()',
        ),
        GeneratedData(
          label: 'Random String',
          value: faker.random.string(length: 12),
          code: 'faker.random.string(length: 12)',
        ),
        GeneratedData(
          label: 'Hex Color',
          value: faker.random.hexColor(),
          code: 'faker.random.hexColor()',
        ),
        GeneratedData(
          label: 'List Element',
          value: faker.random.element(['Apple', 'Banana', 'Cherry', 'Date']),
          code: "faker.random.element(['Apple', 'Banana', 'Cherry', 'Date'])",
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Core Features'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSeedSection(),
          const SizedBox(height: 16),
          _buildLocaleSection(),
          const SizedBox(height: 16),
          _buildRandomGeneratorSection(),
          const SizedBox(height: 16),
          _buildCodeExampleSection(),
        ],
      ),
    );
  }

  Widget _buildSeedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seed Control',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Use seeds for reproducible random generation. Same seed = same results.',
            ),
            const SizedBox(height: 16),
            if (currentSeed != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Current Seed: $currentSeed'),
                    ),
                    CopyButton(text: currentSeed.toString()),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _generateWithSeed,
                    icon: const Icon(Icons.lock),
                    label: const Text('Generate with Seed'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _generateWithoutSeed,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Random (No Seed)'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocaleSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Locale Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Current locale affects data generation for names, addresses, and more.',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 20),
                  const SizedBox(width: 8),
                  Text('Current Locale: ${faker.locale}'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supported locales: ${LocaleManager.supportedLocales.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomGeneratorSection() {
    if (generatedData.isEmpty) return const SizedBox();

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
                  onPressed: _generateRandomData,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Regenerate',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...generatedData.map((data) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _buildDataRow(data),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(GeneratedData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              CopyButton(text: data.value),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            data.value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'monospace',
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExampleSection() {
    const code = '''// Basic usage
final faker = SmartFaker();

// With seed for reproducibility
final seededFaker = SmartFaker(seed: 12345);

// Generate random data
final uuid = faker.random.uuid();
final number = faker.random.integer(max: 100);
final decimal = faker.random.decimal(min: 1.0, max: 10.0);
final boolean = faker.random.boolean();
final color = faker.random.hexColor();

// Pick from lists
final fruits = ['Apple', 'Banana', 'Cherry'];
final fruit = faker.random.element(fruits);

// Weighted selection
final weighted = {'common': 70, 'rare': 25, 'epic': 5};
final rarity = faker.random.weightedElement(weighted);''';

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
                  'Code Example',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                CopyButton(text: code),
              ],
            ),
            const SizedBox(height: 8),
            CodeViewer(code: code),
          ],
        ),
      ),
    );
  }
}

class GeneratedData {
  final String label;
  final String value;
  final String code;

  GeneratedData({
    required this.label,
    required this.value,
    required this.code,
  });
}
