import 'package:smart_faker/smart_faker.dart';

void main() {
  // Create faker with Taiwan locale
  final faker = SmartFaker(locale: 'zh_TW', seed: 12345);

  print('🇹🇼 Taiwan-Specific Data Generation Examples');
  print('=' * 60);

  // Person data in Traditional Chinese
  print('\n👤 Person Data:');
  print('姓名: ${faker.person.fullName()}');
  print('名字: ${faker.person.firstName()}');
  print('姓氏: ${faker.person.lastName()}');
  print('職稱: ${faker.person.jobTitle()}');
  print('年齡: ${faker.person.age()}');

  // Taiwan phone numbers
  print('\n📱 Phone Numbers:');
  print('手機: ${faker.phone.number()}');
  print('市話: ${faker.taiwan.landlineNumber()}');

  // Taiwan-specific IDs
  print('\n🆔 Identification:');
  print('身分證字號 (男): ${faker.taiwan.idNumber(male: true)}');
  print('身分證字號 (女): ${faker.taiwan.idNumber(male: false)}');
  print('統一編號: ${faker.taiwan.companyTaxId()}');
  print('健保卡號: ${faker.taiwan.healthInsuranceNumber()}');

  // Taiwan addresses
  print('\n🏠 Addresses:');
  print('城市: ${faker.location.city()}');
  print('完整地址: ${faker.location.streetAddress()}');
  print('郵遞區號 (3碼): ${faker.taiwan.postalCode()}');
  print('郵遞區號 (5碼): ${faker.taiwan.postalCode(fiveDigit: true)}');

  // Taiwan companies
  print('\n🏢 Companies:');
  print('公司名稱: ${faker.company.name()}');
  print('產業: ${faker.company.industry()}');
  print('口號: ${faker.company.catchphrase()}');

  // Taiwan vehicles
  print('\n🚗 Vehicles:');
  print('汽車牌照: ${faker.taiwan.licensePlate(type: 'car')}');
  print('機車牌照: ${faker.taiwan.licensePlate(type: 'motorcycle')}');
  print('電動車牌照: ${faker.taiwan.licensePlate(type: 'electric')}');

  // Taiwan financial
  print('\n💳 Financial:');
  print('銀行帳號: ${faker.taiwan.bankAccount()}');
  print('信用卡: ${faker.finance.creditCardNumber()}');

  // Generate multiple Taiwan users for testing
  print('\n📊 Batch Generation Example:');
  print('-' * 40);

  final users = List.generate(
      3,
      (index) => {
            'id': faker.taiwan.idNumber(),
            'name': faker.person.fullName(),
            'phone': faker.phone.number(),
            'email': faker.internet.email(),
            'address': faker.location.streetAddress(),
            'company': faker.company.name(),
            'taxId': faker.taiwan.companyTaxId(),
          });

  // Export to CSV
  final csv = faker.export.toCSV(users);
  print('CSV Export of Taiwan Users:');
  print(csv);

  // Export to JSON
  print('\nJSON Export (first user only):');
  final firstUser = faker.export.toJSON(users[0], pretty: true);
  print(firstUser);

  print('\n✨ Taiwan module examples completed!');
}
