import 'dart:io';
import 'package:smart_faker/smart_faker.dart';

void main() async {
  final faker = SmartFaker(seed: 12345);

  // Generate sample user data
  final users = List.generate(
      10,
      (index) => {
            'id': faker.random.uuid(),
            'firstName': faker.person.firstName(),
            'lastName': faker.person.lastName(),
            'email': faker.internet.email(),
            'phone': faker.phone.number(),
            'age': faker.random.integer(min: 18, max: 65),
            'company': faker.company.name(),
            'jobTitle': faker.person.jobTitle(),
            'salary': faker.finance.amount(min: 30000, max: 150000),
            'joinDate': faker.dateTime.past(years: 5),
            'isActive': faker.random.boolean(),
          });

  print('🔍 Generated ${users.length} users\n');

  // Export to CSV
  print('📊 CSV Export:');
  print('=' * 60);
  final csv = faker.export.toCSV(users);
  print(csv);
  // Save to file
  await File('users.csv').writeAsString(csv);
  print('✅ Saved to users.csv\n');

  // Export to JSON
  print('📝 JSON Export (Pretty):');
  print('=' * 60);
  final json = faker.export.toJSON(users, pretty: true);
  print(json.substring(0, 500) + '...\n');
  // Save to file
  await File('users.json').writeAsString(json);
  print('✅ Saved to users.json\n');

  // Export to SQL
  print('🗄️ SQL Export:');
  print('=' * 60);
  final sql = faker.export.toSQL(users, table: 'users');
  print(sql.split('\n').take(3).join('\n'));
  print('...\n');
  // Save to file
  await File('users.sql').writeAsString(sql);
  print('✅ Saved to users.sql\n');

  // Export to Markdown
  print('📋 Markdown Table:');
  print('=' * 60);
  final markdown = faker.export.toMarkdown(
    users.take(3).toList(), // Just show first 3 for demo
    headers: ['firstName', 'lastName', 'email', 'jobTitle'],
  );
  print(markdown);

  // Export to XML
  print('📄 XML Export:');
  print('=' * 60);
  final xml = faker.export.toXML(
    users.take(2).toList(), // Just show first 2 for demo
    rootElement: 'users',
    itemElement: 'user',
  );
  print(xml);

  // Export to YAML
  print('📑 YAML Export:');
  print('=' * 60);
  final yaml = faker.export.toYAML(users.take(2).toList());
  print(yaml);

  // Stream large datasets (memory efficient)
  print('🌊 Streaming CSV for large datasets:');
  print('=' * 60);
  final largeDataStream = Stream.fromIterable(
    List.generate(
        5,
        (i) => {
              'id': i + 1,
              'name': faker.person.fullName(),
              'email': faker.internet.email(),
            }),
  );

  await for (final chunk in faker.export.streamCSV(largeDataStream)) {
    print(chunk.trim());
  }

  print('\n✨ Export examples completed!');
}
