import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class SystemGeneratorScreen extends StatefulWidget {
  const SystemGeneratorScreen({super.key});

  @override
  State<SystemGeneratorScreen> createState() => _SystemGeneratorScreenState();
}

class _SystemGeneratorScreenState extends State<SystemGeneratorScreen> {
  late SmartFaker faker;
  String selectedLocale = 'en_US';
  Map<String, dynamic> generatedData = {};

  @override
  void initState() {
    super.initState();
    faker = SmartFaker(locale: selectedLocale);
    _generateData();
  }

  void _generateData() {
    setState(() {
      generatedData = {
        'File System': {
          'File Name': faker.system.fileName(),
          'File Extension': faker.system.fileExtension(),
          'File Path': faker.system.filePath(),
          'Directory Path': faker.system.directoryPath(),
          'MIME Type': faker.system.mimeType(),
        },
        'Versions': {
          'Semantic Version': faker.system.semver(),
          'Prerelease Version': faker.system.semverPrerelease(),
        },
        'System Info': {
          'Process Name': faker.system.processName(),
          'Cron Expression': faker.system.cron(),
          'Environment Variable': faker.system.environmentVariable(),
          'Operating System': faker.system.operatingSystem(),
        },
      };
    });
  }

  void _changeLocale(String locale) {
    setState(() {
      selectedLocale = locale;
      faker = SmartFaker(locale: locale);
      _generateData();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  Widget _buildDataItem(String label, dynamic value, {IconData? icon}) {
    final displayValue = value.toString();
    
    return Card(
      child: ListTile(
        leading: icon != null
            ? Icon(icon, color: Theme.of(context).colorScheme.primary)
            : null,
        title: Text(label),
        subtitle: Text(
          displayValue,
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => _copyToClipboard(displayValue),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, dynamic> data, {IconData? sectionIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (sectionIcon != null) ...[
                Icon(sectionIcon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        ...data.entries.map((entry) {
          IconData? itemIcon;
          if (entry.key.contains('File')) itemIcon = Icons.insert_drive_file;
          if (entry.key.contains('Directory')) itemIcon = Icons.folder;
          if (entry.key.contains('Process')) itemIcon = Icons.memory;
          if (entry.key.contains('Operating')) itemIcon = Icons.computer;
          if (entry.key.contains('Version')) itemIcon = Icons.label;
          if (entry.key.contains('Cron')) itemIcon = Icons.schedule;
          if (entry.key.contains('Environment')) itemIcon = Icons.settings_system_daydream;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: _buildDataItem(entry.key, entry.value, icon: itemIcon),
          );
        }),
      ],
    );
  }

  Widget _buildCronExplanation(String cron) {
    final parts = cron.split(' ');
    if (parts.length != 5) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cron Expression Breakdown',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cron,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          _buildCronPart('Minute', parts[0], '0-59 or *'),
          _buildCronPart('Hour', parts[1], '0-23 or *'),
          _buildCronPart('Day of Month', parts[2], '1-31 or *'),
          _buildCronPart('Month', parts[3], '1-12 or *'),
          _buildCronPart('Day of Week', parts[4], '0-6 or *'),
        ],
      ),
    );
  }

  Widget _buildCronPart(String label, String value, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            range,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cronExpression = generatedData['System Info']?['Cron Expression'] ?? '';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Generator'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeLocale,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en_US', child: Text('English')),
              const PopupMenuItem(value: 'zh_TW', child: Text('繁體中文')),
              const PopupMenuItem(value: 'ja_JP', child: Text('日本語')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.language),
                  const SizedBox(width: 8),
                  Text(selectedLocale),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSection('File System', generatedData['File System'] ?? {}, sectionIcon: Icons.folder_open),
          _buildSection('Versions', generatedData['Versions'] ?? {}, sectionIcon: Icons.new_releases),
          _buildSection('System Info', generatedData['System Info'] ?? {}, sectionIcon: Icons.computer),
          if (cronExpression.isNotEmpty) _buildCronExplanation(cronExpression),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}