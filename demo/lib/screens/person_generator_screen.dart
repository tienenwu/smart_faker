import 'package:flutter/material.dart';
import 'package:smart_faker/smart_faker.dart';
import 'package:smart_faker/src/modules/models/gender.dart';

class PersonGeneratorScreen extends StatefulWidget {
  const PersonGeneratorScreen({super.key});

  @override
  State<PersonGeneratorScreen> createState() => _PersonGeneratorScreenState();
}

class _PersonGeneratorScreenState extends State<PersonGeneratorScreen> {
  SmartFaker faker = SmartFaker();
  String currentLocale = 'en_US';

  String firstName = '';
  String lastName = '';
  String fullName = '';
  int age = 0;
  Gender? gender;
  String jobTitle = '';
  String jobDepartment = '';
  String completePerson = '';

  @override
  void initState() {
    super.initState();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      // Generate individual fields that are related
      gender = faker.person.gender();
      firstName = faker.person.firstName(gender: gender);
      lastName = faker.person.lastName();

      // Combine firstName and lastName based on locale
      if (currentLocale == 'zh_TW' || currentLocale == 'ja_JP') {
        fullName = '$lastName$firstName'; // Asian name order
      } else {
        fullName = '$firstName $lastName'; // Western name order
      }

      age = faker.person.age();
      jobTitle = faker.person.jobTitle();
      jobDepartment = faker.person.jobDepartment();

      // Generate a completely separate person for the Complete Person card
      final person = faker.person.generatePerson();
      completePerson = '''
Name: ${person.fullName}
Age: ${person.age}
Gender: ${person.gender == Gender.male ? 'Male' : 'Female'}
Job: ${person.jobTitle}
Email: ${person.email}
Phone: ${person.phone}
''';
    });
  }

  void _changeLocale(String locale) {
    setState(() {
      currentLocale = locale;
      faker = SmartFaker(locale: locale);
      _generateAll();
    });
  }

  String _getLocaleName(String locale) {
    switch (locale) {
      case 'en_US':
        return 'English';
      case 'zh_TW':
        return '繁體中文';
      case 'ja_JP':
        return '日本語';
      default:
        return locale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: _changeLocale,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en_US',
                child: Row(
                  children: [
                    currentLocale == 'en_US'
                        ? const Icon(Icons.check, size: 20)
                        : const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    const Text('English'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'zh_TW',
                child: Row(
                  children: [
                    currentLocale == 'zh_TW'
                        ? const Icon(Icons.check, size: 20)
                        : const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    const Text('繁體中文'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ja_JP',
                child: Row(
                  children: [
                    currentLocale == 'ja_JP'
                        ? const Icon(Icons.check, size: 20)
                        : const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    const Text('日本語'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current Locale: ${_getLocaleName(currentLocale)} ($currentLocale)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '— Individual Field Generation (Related) —',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name Generation',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDataRow('First Name', firstName),
                    _buildDataRow('Last Name', lastName),
                    _buildDataRow('Full Name', fullName),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              gender = Gender.male;
                              firstName =
                                  faker.person.firstName(gender: Gender.male);
                              // Keep the same lastName
                              // Update fullName with new combination
                              if (currentLocale == 'zh_TW' ||
                                  currentLocale == 'ja_JP') {
                                fullName = '$lastName$firstName';
                              } else {
                                fullName = '$firstName $lastName';
                              }
                            });
                          },
                          icon: const Icon(Icons.man),
                          label: const Text('Male Name'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              gender = Gender.female;
                              firstName =
                                  faker.person.firstName(gender: Gender.female);
                              // Keep the same lastName
                              // Update fullName with new combination
                              if (currentLocale == 'zh_TW' ||
                                  currentLocale == 'ja_JP') {
                                fullName = '$lastName$firstName';
                              } else {
                                fullName = '$firstName $lastName';
                              }
                            });
                          },
                          icon: const Icon(Icons.woman),
                          label: const Text('Female Name'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demographics',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDataRow('Age', age.toString()),
                    _buildDataRow(
                        'Gender', gender == Gender.male ? 'Male' : 'Female'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              age = faker.person.age(min: 18, max: 25);
                            });
                          },
                          child: const Text('Young (18-25)'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              age = faker.person.age(min: 30, max: 45);
                            });
                          },
                          child: const Text('Middle (30-45)'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              age = faker.person.age(min: 50, max: 70);
                            });
                          },
                          child: const Text('Senior (50-70)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDataRow('Job Title', jobTitle),
                    _buildDataRow('Department', jobDepartment),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '— Separate Complete Person Generation —',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Complete Person (Independent)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        completePerson,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateAll,
        label: const Text('Generate New'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
