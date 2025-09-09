import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class VehicleGeneratorScreen extends StatefulWidget {
  const VehicleGeneratorScreen({super.key});

  @override
  State<VehicleGeneratorScreen> createState() => _VehicleGeneratorScreenState();
}

class _VehicleGeneratorScreenState extends State<VehicleGeneratorScreen> {
  late SmartFaker faker;
  String currentLocale = 'en_US';

  // Vehicle info
  String manufacturer = '';
  String model = '';
  String type = '';
  String fuel = '';
  String color = '';
  String transmission = '';

  // Identifiers
  String vin = '';
  String licensePlate = '';
  String registration = '';

  // Specifications
  int year = 0;
  String engine = '';
  String drive = '';
  int doors = 0;
  int seats = 0;
  int mileage = 0;

  @override
  void initState() {
    super.initState();
    faker = SmartFaker(locale: currentLocale);
    _generateAllData();
  }

  void _setLocale(String locale) {
    setState(() {
      currentLocale = locale;
      faker.setLocale(locale);
      _generateAllData();
    });
  }

  void _generateAllData() {
    setState(() {
      // Vehicle info
      manufacturer = faker.vehicle.manufacturer();
      model = faker.vehicle.model();
      type = faker.vehicle.type();
      fuel = faker.vehicle.fuel();
      color = faker.vehicle.color();
      transmission = faker.vehicle.transmission();

      // Identifiers
      vin = faker.vehicle.vin();
      licensePlate = faker.vehicle.licensePlate();
      registration = faker.vehicle.registration();

      // Specifications
      year = faker.vehicle.year();
      engine = faker.vehicle.engine();
      drive = faker.vehicle.drive();
      doors = faker.vehicle.doors();
      seats = faker.vehicle.seats();
      mileage = faker.vehicle.mileage();
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: currentLocale,
              underline: Container(),
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Theme.of(context).colorScheme.primary,
              items: const [
                DropdownMenuItem(
                  value: 'en_US',
                  child: Text('🇺🇸 English',
                      style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'zh_TW',
                  child:
                      Text('🇹🇼 繁體中文', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'ja_JP',
                  child:
                      Text('🇯🇵 日本語', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _setLocale(value);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildVehicleCard(),
          const SizedBox(height: 16),
          _buildIdentifiersCard(),
          const SizedBox(height: 16),
          _buildSpecificationsCard(),
          const SizedBox(height: 16),
          _buildFeaturesCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Card(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          manufacturer,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          model,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      year.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildChip(type, Icons.directions_car),
                  const SizedBox(width: 8),
                  _buildChip(color, Icons.palette),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentifiersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Identifiers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildIdentifierField('VIN', vin),
            _buildIdentifierField('License Plate', licensePlate),
            _buildIdentifierField('Registration', registration),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Specifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSpecRow('Engine', engine),
            _buildSpecRow('Transmission', transmission),
            _buildSpecRow('Drive Type', drive),
            _buildSpecRow('Fuel Type', fuel),
            const Divider(),
            _buildSpecRow('Mileage', '${mileage.toString()} km'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureItem(Icons.sensor_door, '$doors Doors'),
                _buildFeatureItem(Icons.event_seat, '$seats Seats'),
                _buildFeatureItem(Icons.local_gas_station, fuel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildIdentifierField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _copyToClipboard(value, label),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.copy,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
