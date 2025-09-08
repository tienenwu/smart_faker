import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class ColorGeneratorScreen extends StatefulWidget {
  const ColorGeneratorScreen({super.key});

  @override
  State<ColorGeneratorScreen> createState() => _ColorGeneratorScreenState();
}

class _ColorGeneratorScreenState extends State<ColorGeneratorScreen> {
  late SmartFaker faker;

  // Color formats
  String hexColor = '';
  String hexColorWithAlpha = '';
  String rgbColor = '';
  String rgbaColor = '';
  String hslColor = '';
  String hslaColor = '';
  String hsvColor = '';
  String cmykColor = '';

  // Named colors
  String cssName = '';
  String materialColor = '';
  String tailwindColor = '';

  // Color properties
  String randomColor = '';
  String warmColor = '';
  String coolColor = '';
  String pastelColor = '';
  String vibrantColor = '';
  String darkColor = '';
  String lightColor = '';

  // Color schemes
  List<String> monochromaticScheme = [];
  List<String> analogousScheme = [];
  List<String> complementaryScheme = [];
  List<String> triadicScheme = [];
  List<String> tetradicScheme = [];
  List<String> splitComplementaryScheme = [];

  @override
  void initState() {
    super.initState();
    faker = SmartFaker();
    _generateAllData();
  }

  void _generateAllData() {
    setState(() {
      // Color formats
      hexColor = faker.color.hex();
      hexColorWithAlpha = faker.color.hex(includeAlpha: true);
      rgbColor = faker.color.rgb();
      rgbaColor = faker.color.rgba();
      hslColor = faker.color.hsl();
      hslaColor = faker.color.hsla();
      hsvColor = faker.color.hsv();
      cmykColor = faker.color.cmyk();

      // Named colors
      cssName = faker.color.cssName();
      materialColor = faker.color.material();
      tailwindColor = faker.color.tailwind();

      // Color properties
      randomColor = faker.color.randomColor();
      warmColor = faker.color.warm();
      coolColor = faker.color.cool();
      pastelColor = faker.color.pastel();
      vibrantColor = faker.color.vibrant();
      darkColor = faker.color.dark();
      lightColor = faker.color.light();

      // Color schemes
      monochromaticScheme = faker.color.monochromatic();
      analogousScheme = faker.color.analogous();
      complementaryScheme = faker.color.complementary();
      triadicScheme = faker.color.triadic();
      tetradicScheme = faker.color.tetradic();
      splitComplementaryScheme = faker.color.splitComplementary();
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

  Color? _parseHexColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 7) {
        buffer.write('ff');
        buffer.write(hex.substring(1));
      } else if (hex.length == 9) {
        buffer.write(hex.substring(7, 9));
        buffer.write(hex.substring(1, 7));
      } else {
        return null;
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Color Formats Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color Formats',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildColorItem('Hex', hexColor),
                  _buildColorItem('Hex with Alpha', hexColorWithAlpha),
                  _buildColorItem('RGB', rgbColor),
                  _buildColorItem('RGBA', rgbaColor),
                  _buildColorItem('HSL', hslColor),
                  _buildColorItem('HSLA', hslaColor),
                  _buildColorItem('HSV', hsvColor),
                  _buildColorItem('CMYK', cmykColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Named Colors Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Named Colors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildNamedColorItem('CSS Name', cssName),
                  _buildNamedColorItem('Material', materialColor),
                  _buildNamedColorItem('Tailwind', tailwindColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Color Properties Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color Properties',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildColorItem('Random', randomColor),
                  _buildColorItem('Warm', warmColor),
                  _buildColorItem('Cool', coolColor),
                  _buildColorItem('Pastel', pastelColor),
                  _buildColorItem('Vibrant', vibrantColor),
                  _buildColorItem('Dark', darkColor),
                  _buildColorItem('Light', lightColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Color Schemes Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color Schemes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSchemeItem('Monochromatic', monochromaticScheme),
                  _buildSchemeItem('Analogous', analogousScheme),
                  _buildSchemeItem('Complementary', complementaryScheme),
                  _buildSchemeItem('Triadic', triadicScheme),
                  _buildSchemeItem('Tetradic', tetradicScheme),
                  _buildSchemeItem(
                      'Split Complementary', splitComplementaryScheme),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Colors',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildColorItem(String label, String value) {
    Color? color;
    if (value.startsWith('#')) {
      color = _parseHexColor(value);
    }

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
              if (color != null)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.green, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
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

  Widget _buildNamedColorItem(String label, String value) {
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
              const Icon(Icons.palette, size: 20, color: Colors.blue),
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

  Widget _buildSchemeItem(String label, List<String> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: colors.map((color) {
              final parsedColor = _parseHexColor(color);
              return Expanded(
                child: InkWell(
                  onTap: () => _copyToClipboard(color, label),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: parsedColor ?? Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        color.substring(1, 4),
                        style: TextStyle(
                          color: parsedColor != null
                              ? (parsedColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white)
                              : Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
