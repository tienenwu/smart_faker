import 'package:flutter/material.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  runApp(const SmartFakerSimpleDemo());
}

class SmartFakerSimpleDemo extends StatelessWidget {
  const SmartFakerSimpleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFaker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DemoHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoHomeScreen extends StatefulWidget {
  const DemoHomeScreen({super.key});

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  final SmartFaker faker = SmartFaker();
  final List<String> generatedData = [];

  void _generatePersonData() {
    setState(() {
      generatedData.clear();
      generatedData.addAll([
        'Name: ${faker.person.fullName()}',
        'Email: ${faker.person.email()}',
        'Phone: ${faker.person.phoneNumber()}',
        'Age: ${faker.person.age()}',
        'Address: ${faker.location.address()}',
      ]);
    });
  }

  void _generateCommerceData() {
    setState(() {
      generatedData.clear();
      generatedData.addAll([
        'Product: ${faker.commerce.productName()}',
        'Price: \$${faker.commerce.price()}',
        'Category: ${faker.commerce.category()}',
        'Brand: ${faker.commerce.brand()}',
        'SKU: ${faker.commerce.sku()}',
      ]);
    });
  }

  void _generateTaiwanData() {
    setState(() {
      generatedData.clear();
      generatedData.addAll([
        'Taiwan ID: ${faker.taiwan.nationalId()}',
        'Taiwan Phone: ${faker.taiwan.mobileNumber()}',
        'Taiwan Address: ${faker.taiwan.address()}',
        'Taiwan Company: ${faker.taiwan.companyName()}',
        'Taiwan District: ${faker.taiwan.district()}',
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFaker Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'SmartFaker - Intelligent Test Data Generator',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generatePersonData,
                    child: const Text('Person Data'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generateCommerceData,
                    child: const Text('Commerce Data'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generateTaiwanData,
                    child: const Text('Taiwan Data'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: generatedData.isEmpty
                    ? const Center(
                        child: Text(
                          'Press a button above to generate sample data',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: generatedData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              generatedData[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Features:\n'
              '• Multi-language support (English, Chinese, Japanese)\n'
              '• Taiwan-specific data generation\n'
              '• Commerce and e-commerce data\n'
              '• Person and location data\n'
              '• Schema-based generation\n'
              '• Export to multiple formats',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
