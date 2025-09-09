import 'package:flutter/material.dart';
import 'package:smart_faker/smart_faker.dart';
import 'package:intl/intl.dart';

class HealthcareDemoScreen extends StatefulWidget {
  const HealthcareDemoScreen({super.key});

  @override
  State<HealthcareDemoScreen> createState() => _HealthcareDemoScreenState();
}

class _HealthcareDemoScreenState extends State<HealthcareDemoScreen> {
  SmartFaker faker = SmartFaker(locale: 'en_US', seed: 12345);
  String _currentLocale = 'en_US';

  // Patient data
  String _patientId = '';
  String _mrn = '';
  String _bloodType = '';

  // Doctor & Hospital
  String _doctorName = '';
  String _specialty = '';
  String _hospitalName = '';

  // Vital Signs
  String _bloodPressure = '';
  int _heartRate = 0;
  String _temperature = '';
  double _bmi = 0.0;

  // Medical Info
  String _diagnosis = '';
  String _medication = '';
  String _dosage = '';
  String _medicalTest = '';

  // Allergies & Vaccinations
  List<String> _allergies = [];
  List<String> _vaccinations = [];

  // Insurance
  String _insuranceProvider = '';
  String _policyNumber = '';

  // Appointment
  DateTime _appointmentTime = DateTime.now();
  String _appointmentStatus = '';

  @override
  void initState() {
    super.initState();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      // Patient
      _patientId = faker.healthcare.patientId();
      _mrn = faker.healthcare.medicalRecordNumber();
      _bloodType = faker.healthcare.bloodType();

      // Doctor & Hospital
      _doctorName = faker.healthcare.doctorName();
      _specialty = faker.healthcare.specialty();
      _hospitalName = faker.healthcare.hospitalName();

      // Vital Signs
      _bloodPressure = faker.healthcare.bloodPressure();
      _heartRate = faker.healthcare.heartRate();
      _temperature = faker.healthcare.temperature();
      _bmi = faker.healthcare.bmi();

      // Medical Info
      _diagnosis = faker.healthcare.diagnosis();
      _medication = faker.healthcare.medication();
      _dosage = faker.healthcare.dosage();
      _medicalTest = faker.healthcare.medicalTest();

      // Allergies & Vaccinations
      _allergies = List.generate(3, (_) => faker.healthcare.allergy());
      _vaccinations = List.generate(3, (_) => faker.healthcare.vaccination());

      // Insurance
      _insuranceProvider = faker.healthcare.insuranceProvider();
      _policyNumber = faker.healthcare.insurancePolicyNumber();

      // Appointment
      _appointmentTime = faker.healthcare.appointmentTime();
      _appointmentStatus = faker.healthcare.appointmentStatus();
    });
  }

  Widget _buildPatientCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Patient ID', _patientId),
            _buildInfoRow('MRN', _mrn),
            _buildInfoRow('Blood Type', _bloodType),
            const Divider(height: 24),
            _buildInfoRow('Primary Doctor', _doctorName),
            _buildInfoRow('Specialty', _specialty),
            _buildInfoRow('Hospital', _hospitalName),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSignsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vital Signs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildVitalColumn(
                    'Blood Pressure', _bloodPressure, Icons.favorite),
                _buildVitalColumn(
                    'Heart Rate', '$_heartRate bpm', Icons.timeline),
                _buildVitalColumn(
                    'Temperature', _temperature, Icons.thermostat),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: _buildVitalColumn(
                  'BMI', _bmi.toStringAsFixed(1), Icons.monitor_weight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMedicalInfoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Diagnosis', _diagnosis),
            _buildInfoRow('Medication', _medication),
            _buildInfoRow('Dosage', _dosage),
            _buildInfoRow('Test Required', _medicalTest),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Allergies & Vaccinations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(Icons.warning, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Allergies:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ..._allergies.map((allergy) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(allergy),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            Text(
              'Vaccinations:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ..._vaccinations.map((vaccine) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(vaccine),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Next Appointment',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                _buildStatusChip(_appointmentStatus),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, MMM dd, yyyy').format(_appointmentTime),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('HH:mm').format(_appointmentTime),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _doctorName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.local_hospital,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _hospitalName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        color = Colors.green;
        break;
      case 'scheduled':
        color = Colors.blue;
        break;
      case 'cancelled':
      case 'no-show':
        color = Colors.red;
        break;
      case 'rescheduled':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.2),
      labelStyle:
          TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
    );
  }

  Widget _buildInsuranceCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insurance Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Provider', _insuranceProvider),
            _buildInfoRow('Policy Number', _policyNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          SelectableText(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _changeLocale(String locale) {
    setState(() {
      _currentLocale = locale;
      faker = SmartFaker(locale: locale, seed: 12345);
      _generateAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏥 Healthcare Module'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: _changeLocale,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en_US',
                child: Row(
                  children: [
                    Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('English'),
                    if (_currentLocale == 'en_US') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'zh_TW',
                child: Row(
                  children: [
                    Text('🇹🇼', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('繁體中文'),
                    if (_currentLocale == 'zh_TW') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ja_JP',
                child: Row(
                  children: [
                    Text('🇯🇵', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('日本語'),
                    if (_currentLocale == 'ja_JP') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateAll,
            tooltip: 'Generate New Data',
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildPatientCard(),
          _buildVitalSignsCard(),
          _buildMedicalInfoCard(),
          _buildAllergiesCard(),
          _buildAppointmentCard(),
          _buildInsuranceCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
