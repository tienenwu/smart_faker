import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class LocationGeneratorScreen extends StatefulWidget {
  const LocationGeneratorScreen({super.key});

  @override
  State<LocationGeneratorScreen> createState() =>
      _LocationGeneratorScreenState();
}

class _LocationGeneratorScreenState extends State<LocationGeneratorScreen> {
  late SmartFaker faker;
  String currentLocale = 'en_US';

  // Address fields
  String streetAddress = '';
  String streetName = '';
  String buildingNumber = '';
  String secondaryAddress = '';
  String fullAddress = '';

  // City and State
  String city = '';
  String state = '';
  String stateAbbr = '';
  String country = '';
  String countryCode = '';

  // Postal
  String zipCode = '';
  String postalCode = '';

  // Coordinates
  double latitude = 0.0;
  double longitude = 0.0;
  Coordinates? coordinates;
  Coordinates? nearbyCoordinates;

  // Other
  String timezone = '';
  String direction = '';
  String cardinalDirection = '';

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
      // Address fields
      streetAddress = faker.location.streetAddress();
      streetName = faker.location.streetName();
      buildingNumber = faker.location.buildingNumber();
      secondaryAddress = faker.location.secondaryAddress();
      fullAddress = faker.location.fullAddress();

      // City and State
      city = faker.location.city();
      state = faker.location.state();
      stateAbbr = faker.location.stateAbbr();
      country = faker.location.country();
      countryCode = faker.location.countryCode();

      // Postal
      zipCode = faker.location.zipCode();
      postalCode = faker.location.postalCode();

      // Coordinates
      latitude = faker.location.latitude();
      longitude = faker.location.longitude();
      coordinates = faker.location.coordinates();
      nearbyCoordinates = faker.location.nearbyCoordinates(
        latitude: coordinates!.latitude,
        longitude: coordinates!.longitude,
        radius: 10,
      );

      // Other
      timezone = faker.location.timezone();
      direction = faker.location.direction();
      cardinalDirection = faker.location.cardinalDirection();
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
        title: const Text('Location Generator'),
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
          _buildAddressCard(),
          const SizedBox(height: 16),
          _buildCityStateCard(),
          const SizedBox(height: 16),
          _buildPostalCard(),
          const SizedBox(height: 16),
          _buildCoordinatesCard(),
          const SizedBox(height: 16),
          _buildOtherCard(),
          const SizedBox(height: 16),
          _buildFullAddressCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address Components',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Street Address', streetAddress),
            _buildField('Street Name', streetName),
            _buildField('Building Number', buildingNumber),
            _buildField('Secondary Address', secondaryAddress),
          ],
        ),
      ),
    );
  }

  Widget _buildCityStateCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'City & State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('City', city),
            _buildField('State/Prefecture', state),
            _buildField('State Abbreviation', stateAbbr),
            _buildField('Country', country),
            _buildField('Country Code', countryCode),
          ],
        ),
      ),
    );
  }

  Widget _buildPostalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Postal Codes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('ZIP Code', zipCode),
            _buildField('Postal Code', postalCode),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Coordinates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Latitude', latitude.toStringAsFixed(6)),
            _buildField('Longitude', longitude.toStringAsFixed(6)),
            if (coordinates != null)
              _buildField(
                'Coordinates',
                '(${coordinates!.latitude.toStringAsFixed(6)}, ${coordinates!.longitude.toStringAsFixed(6)})',
              ),
            if (nearbyCoordinates != null)
              _buildField(
                'Nearby (10km)',
                '(${nearbyCoordinates!.latitude.toStringAsFixed(6)}, ${nearbyCoordinates!.longitude.toStringAsFixed(6)})',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Other Location Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Timezone', timezone),
            _buildField('Direction', direction),
            _buildField('Cardinal Direction', cardinalDirection),
          ],
        ),
      ),
    );
  }

  Widget _buildFullAddressCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Full Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () =>
                      _copyToClipboard(fullAddress, 'Full address'),
                  tooltip: 'Copy to clipboard',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              fullAddress,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _copyToClipboard(value, label),
              child: Text(
                value,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
