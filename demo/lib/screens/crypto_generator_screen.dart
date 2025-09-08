import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class CryptoGeneratorScreen extends StatefulWidget {
  const CryptoGeneratorScreen({super.key});

  @override
  State<CryptoGeneratorScreen> createState() => _CryptoGeneratorScreenState();
}

class _CryptoGeneratorScreenState extends State<CryptoGeneratorScreen> {
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
      _values['Bitcoin Address'] = faker.crypto.bitcoinAddress();
      _values['Ethereum Address'] = faker.crypto.ethereumAddress();
      _values['Private Key'] = faker.crypto.privateKey();
      _values['Public Key'] = faker.crypto.publicKey();
      _values['Seed Phrase'] = faker.crypto.seedPhrase();
      _values['Block Number'] = faker.crypto.blockNumber().toString();
      _values['Gas Price'] = faker.crypto.gasPrice();
      _values['NFT Collection'] = faker.crypto.nftCollection();
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
        title: const Text('Crypto Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateAll,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _values.entries.map((entry) => Card(
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
        )).toList(),
      ),
    );
  }
}