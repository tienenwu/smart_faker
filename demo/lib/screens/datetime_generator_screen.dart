import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';
import 'package:intl/intl.dart';

class DateTimeGeneratorScreen extends StatefulWidget {
  const DateTimeGeneratorScreen({super.key});

  @override
  State<DateTimeGeneratorScreen> createState() =>
      _DateTimeGeneratorScreenState();
}

class _DateTimeGeneratorScreenState extends State<DateTimeGeneratorScreen> {
  late SmartFaker faker;
  String currentLocale = 'en_US';

  // Past and Future
  DateTime? pastDate;
  DateTime? futureDate;
  DateTime? recentDate;
  DateTime? soonDate;

  // Between dates
  DateTime? betweenDate;
  final startDate = DateTime(2020, 1, 1);
  final endDate = DateTime(2025, 12, 31);

  // Weekdays and Months
  String weekday = '';
  String weekdayAbbr = '';
  String month = '';
  String monthAbbr = '';

  // Time components
  int hour = 0;
  int minute = 0;
  int second = 0;
  String timeString = '';

  // Timestamps
  int unixTimestamp = 0;
  String iso8601 = '';

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
      // Past and Future
      pastDate = faker.dateTime.past();
      futureDate = faker.dateTime.future();
      recentDate = faker.dateTime.recent();
      soonDate = faker.dateTime.soon();

      // Between dates
      betweenDate = faker.dateTime.between(from: startDate, to: endDate);

      // Weekdays and Months
      weekday = faker.dateTime.weekday();
      weekdayAbbr = faker.dateTime.weekdayAbbr();
      month = faker.dateTime.month();
      monthAbbr = faker.dateTime.monthAbbr();

      // Time components
      hour = faker.dateTime.hour();
      minute = faker.dateTime.minute();
      second = faker.dateTime.second();
      timeString = faker.dateTime.timeString();

      // Timestamps
      unixTimestamp = faker.dateTime.unixTimestamp();
      iso8601 = faker.dateTime.iso8601();
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

  String _formatDateOnly(DateTime? date) {
    if (date == null) return '';
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DateTime Generator'),
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
          _buildPastFutureCard(),
          const SizedBox(height: 16),
          _buildRecentSoonCard(),
          const SizedBox(height: 16),
          _buildBetweenCard(),
          const SizedBox(height: 16),
          _buildWeekdayMonthCard(),
          const SizedBox(height: 16),
          _buildTimeComponentsCard(),
          const SizedBox(height: 16),
          _buildTimestampsCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAllData,
        tooltip: 'Generate New Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildPastFutureCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Past & Future Dates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Past (1 year)', _formatDate(pastDate)),
            _buildField('Future (1 year)', _formatDate(futureDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSoonCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent & Soon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Recent (7 days)', _formatDate(recentDate)),
            _buildField('Soon (7 days)', _formatDate(soonDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildBetweenCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Between Dates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Range: ${_formatDateOnly(startDate)} to ${_formatDateOnly(endDate)}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 12),
            _buildField('Generated Date', _formatDate(betweenDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayMonthCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekdays & Months',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Weekday', weekday),
            _buildField('Weekday (abbr)', weekdayAbbr),
            _buildField('Month', month),
            _buildField('Month (abbr)', monthAbbr),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeComponentsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Components',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Hour', hour.toString()),
            _buildField('Minute', minute.toString()),
            _buildField('Second', second.toString()),
            _buildField('Time String', timeString),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampsCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timestamps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildField('Unix Timestamp', unixTimestamp.toString()),
            _buildField('ISO 8601', iso8601),
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
