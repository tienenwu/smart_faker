import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class MusicGeneratorScreen extends StatefulWidget {
  const MusicGeneratorScreen({super.key});

  @override
  State<MusicGeneratorScreen> createState() => _MusicGeneratorScreenState();
}

class _MusicGeneratorScreenState extends State<MusicGeneratorScreen> {
  late SmartFaker faker;
  final Map<String, String> _values = {};

  @override
  void initState() {
    super.initState();
    faker = SmartFaker();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      _values['Song Name'] = faker.music.songName();
      _values['Artist Name'] = faker.music.artistName();
      _values['Album Name'] = faker.music.albumName();
      _values['Band Name'] = faker.music.bandName();
      _values['Genre'] = faker.music.genre();
      _values['Sub-Genre'] = faker.music.subGenre();
      _values['Instrument'] = faker.music.instrument();
      _values['Composer'] = faker.music.composer();
      _values['Duration'] = faker.music.duration();
      _values['BPM'] = faker.music.bpm().toString();
      _values['Key Signature'] = faker.music.keySignature();
      _values['Time Signature'] = faker.music.timeSignature();
      _values['Record Label'] = faker.music.recordLabel();
      _values['Producer'] = faker.music.producer();
      _values['Studio'] = faker.music.studio();
      _values['Release Year'] = faker.music.releaseYear().toString();
      _values['Chart Position'] = faker.music.chartPosition();
      _values['Award'] = faker.music.award();
    });
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateAll,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _values.entries
            .map((entry) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text(
                      entry.value,
                      style: const TextStyle(fontFamily: 'monospace'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () => _copyToClipboard(entry.value),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
