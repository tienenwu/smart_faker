import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class LoremGeneratorScreen extends StatefulWidget {
  const LoremGeneratorScreen({super.key});

  @override
  State<LoremGeneratorScreen> createState() => _LoremGeneratorScreenState();
}

class _LoremGeneratorScreenState extends State<LoremGeneratorScreen> {
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
        'Words': {
          'Single Word': faker.lorem.word(),
          '5 Words': faker.lorem.words(count: 5),
          '10 Words': faker.lorem.words(count: 10),
        },
        'Sentences': {
          'Short Sentence': faker.lorem.sentence(wordCount: 5),
          'Medium Sentence': faker.lorem.sentence(wordCount: 10),
          'Long Sentence': faker.lorem.sentence(wordCount: 20),
          'Multiple Sentences': faker.lorem.sentences(count: 3),
        },
        'Paragraphs': {
          'Short Paragraph': faker.lorem.paragraph(sentenceCount: 2),
          'Medium Paragraph': faker.lorem.paragraph(sentenceCount: 4),
          'Long Paragraph': faker.lorem.paragraph(sentenceCount: 6),
          'Multiple Paragraphs': faker.lorem.paragraphs(count: 2),
        },
        'Text': {
          'Small Text (50 chars)': faker.lorem.text(maxLength: 50),
          'Medium Text (100 chars)': faker.lorem.text(maxLength: 100),
          'Large Text (200 chars)': faker.lorem.text(maxLength: 200),
        },
        'Specialized': {
          'Slug': faker.lorem.slug(wordCount: 3),
          'Lines': faker.lorem.lines(count: 3),
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

  Widget _buildDataItem(String label, dynamic value) {
    final displayValue = value.toString();

    return Card(
      child: ExpansionTile(
        title: Text(label),
        subtitle: Text(
          displayValue,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    displayValue,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${displayValue.length} characters',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy'),
                      onPressed: () => _copyToClipboard(displayValue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...data.entries.map(
          (entry) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: _buildDataItem(entry.key, entry.value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lorem Generator'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeLocale,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en_US', child: Text('English Lorem')),
              const PopupMenuItem(value: 'zh_TW', child: Text('繁體中文文字')),
              const PopupMenuItem(value: 'ja_JP', child: Text('日本語テキスト')),
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
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedLocale == 'en_US'
                        ? 'Generating Lorem Ipsum text'
                        : selectedLocale == 'zh_TW'
                            ? '生成繁體中文示例文字'
                            : '日本語のサンプルテキストを生成',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildSection('Words', generatedData['Words'] ?? {}),
          _buildSection('Sentences', generatedData['Sentences'] ?? {}),
          _buildSection('Paragraphs', generatedData['Paragraphs'] ?? {}),
          _buildSection('Text', generatedData['Text'] ?? {}),
          _buildSection('Specialized', generatedData['Specialized'] ?? {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateData,
        tooltip: 'Generate New Text',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
