import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
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
        'URLs': {
          'Random Image': faker.image.url(),
          'Placeholder': faker.image.placeholder(),
          'Avatar': faker.image.avatar(),
          'Data URI': faker.image.dataUri().substring(0, 50) + '...',
        },
        'Local Avatars': {
          'Circle Small (48px)':
              faker.image.localAvatar(size: 48, shape: 'circle'),
          'Circle Medium (128px)':
              faker.image.localAvatar(size: 128, shape: 'circle'),
          'Circle Large (256px)':
              faker.image.localAvatar(size: 256, shape: 'circle'),
          'Square Small (64px)':
              faker.image.localAvatar(size: 64, shape: 'square'),
          'Square Medium (128px)':
              faker.image.localAvatar(size: 128, shape: 'square'),
          'Custom Name': faker.image.localAvatar(name: 'JD', size: 128),
        },
        'Categories': {
          'Nature': faker.image.nature(width: 400, height: 300),
          'People': faker.image.people(width: 400, height: 300),
          'Technology': faker.image.technology(width: 400, height: 300),
          'Food': faker.image.food(width: 400, height: 300),
          'Transport': faker.image.transport(width: 400, height: 300),
          'Animals': faker.image.animals(width: 400, height: 300),
          'Business': faker.image.business(width: 400, height: 300),
          'Fashion': faker.image.fashion(width: 400, height: 300),
          'Sports': faker.image.sports(width: 400, height: 300),
          'Abstract': faker.image.abstract(width: 400, height: 300),
        },
        'Colors': {
          'Hex Color': faker.image.hexColor(),
          'RGB Color': faker.image.rgbColor(),
          'HSL Color': faker.image.hslColor(),
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

  Widget _buildColorPreview(String colorString) {
    Color? color;

    if (colorString.startsWith('#')) {
      // Hex color
      final hex = colorString.substring(1);
      color = Color(int.parse('FF$hex', radix: 16));
    } else if (colorString.startsWith('rgb')) {
      // RGB color
      final match =
          RegExp(r'rgb\((\d+), (\d+), (\d+)\)').firstMatch(colorString);
      if (match != null) {
        final r = int.parse(match.group(1)!);
        final g = int.parse(match.group(2)!);
        final b = int.parse(match.group(3)!);
        color = Color.fromRGBO(r, g, b, 1);
      }
    } else if (colorString.startsWith('hsl')) {
      // HSL color - simplified conversion
      final match =
          RegExp(r'hsl\((\d+), (\d+)%, (\d+)%\)').firstMatch(colorString);
      if (match != null) {
        final h = double.parse(match.group(1)!) / 360;
        final s = double.parse(match.group(2)!) / 100;
        final l = double.parse(match.group(3)!) / 100;
        color = HSLColor.fromAHSL(1, h * 360, s, l).toColor();
      }
    }

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color ?? Colors.grey,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            colorString,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  Widget _buildDataItem(String label, dynamic value,
      {bool isColor = false, bool isAvatar = false}) {
    final displayValue = value.toString();

    if (isAvatar && displayValue.startsWith('data:image/svg+xml;base64,')) {
      // Decode and display SVG avatar
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Display the avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildSvgPreview(displayValue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SVG Data URI',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(displayValue),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: isColor
            ? _buildColorPreview(displayValue)
            : Text(
                displayValue,
                style: const TextStyle(fontFamily: 'monospace'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => _copyToClipboard(displayValue),
        ),
      ),
    );
  }

  Widget _buildSvgPreview(String dataUri) {
    try {
      // Extract base64 part
      final base64Start = dataUri.indexOf(',') + 1;
      final base64String = dataUri.substring(base64Start);

      // Decode base64 to get SVG string
      final svgBytes = base64Decode(base64String);
      final svgString = utf8.decode(svgBytes);

      // Parse SVG to extract key information
      final bgColorMatch =
          RegExp(r'fill="(#[0-9A-Fa-f]{6})"').firstMatch(svgString);
      final textMatch =
          RegExp(r'<text[^>]*>([^<]+)</text>').firstMatch(svgString);
      final isCircle = svgString.contains('<circle');

      final bgColor = bgColorMatch?.group(1) ?? '#4ECDC4';
      final text = textMatch?.group(1) ?? 'A';

      // Convert hex to Color
      final color = Color(int.parse(bgColor.replaceAll('#', 'FF'), radix: 16));

      // Calculate text color based on background
      final luminance =
          (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
      final textColor = luminance > 0.5 ? Colors.grey.shade800 : Colors.white;

      // Render as native Flutter widget
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.error_outline),
      );
    }
  }

  Widget _buildSection(String title, Map<String, dynamic> data,
      {bool isColor = false, bool isAvatar = false}) {
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
            child: _buildDataItem(entry.key, entry.value,
                isColor: isColor, isAvatar: isAvatar),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Generator'),
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
          _buildSection('Image URLs', generatedData['URLs'] ?? {}),
          _buildSection('Local Avatars', generatedData['Local Avatars'] ?? {},
              isAvatar: true),
          _buildSection('Image Categories', generatedData['Categories'] ?? {}),
          _buildSection('Colors', generatedData['Colors'] ?? {}, isColor: true),
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
