import 'package:smart_faker/smart_faker.dart';

void main() {
  // Initialize SmartFaker with Traditional Chinese locale
  final faker = SmartFaker(locale: 'zh_TW');

  print('=== SmartFaker Demo - 智能測試數據生成器 ===\n');

  // Person Data Generation
  print('📋 Person Data (人員資料):');
  print('Name: ${faker.person.fullName()}');
  print('First Name: ${faker.person.firstName()}');
  print('Last Name: ${faker.person.lastName()}');
  print('Job Title: ${faker.person.jobTitle()}');
  print('Department: ${faker.person.jobDepartment()}');
  print('');

  // Location Data
  print('🌍 Location Data (地點資料):');
  print('Full Address: ${faker.location.fullAddress()}');
  print('Street Address: ${faker.location.streetAddress()}');
  print('City: ${faker.location.city()}');
  print('State: ${faker.location.state()}');
  print('Postal Code: ${faker.location.postalCode()}');
  print('Country: ${faker.location.country()}');
  print('');

  // Commerce Data
  print('🛒 Commerce Data (商務資料):');
  print('Product: ${faker.commerce.productName()}');
  print('Price: \$${faker.commerce.price()}');
  print('Category: ${faker.commerce.category()}');
  print('Brand: ${faker.commerce.brand()}');
  print('SKU: ${faker.commerce.sku()}');
  print('');

  // Taiwan-specific Data
  print('🇹🇼 Taiwan Data (台灣專用資料):');
  print('ID Number: ${faker.taiwan.idNumber()}');
  print('Landline: ${faker.taiwan.landlineNumber()}');
  print('Postal Code: ${faker.taiwan.postalCode()}');
  print('License Plate: ${faker.taiwan.licensePlate()}');
  print('Bank Account: ${faker.taiwan.bankAccount()}');
  print('Health Insurance: ${faker.taiwan.healthInsuranceNumber()}');
  print('');

  // Color Data
  print('🎨 Color Data (顏色資料):');
  print('Color Hex: ${faker.color.hex()}');
  print('Color RGB: ${faker.color.rgb()}');
  print('');

  // Date & Time
  print('📅 Date & Time (日期時間):');
  print('Future Date: ${faker.dateTime.future()}');
  print('Past Date: ${faker.dateTime.past()}');
  print('Weekday: ${faker.dateTime.weekday()}');
  print('Month: ${faker.dateTime.month()}');
  print('');

  // System Data
  print('💻 System Data (系統資料):');
  print('File Name: ${faker.system.fileName()}');
  print('File Extension: ${faker.system.fileExtension()}');
  print('Mime Type: ${faker.system.mimeType()}');
  print('');

  // Internet Data
  print('🌐 Internet Data (網路資料):');
  print('Domain: ${faker.internet.domainName()}');
  print('Email: ${faker.internet.email()}');
  print('Username: ${faker.internet.username()}');
  print('URL: ${faker.internet.url()}');
  print('IP Address: ${faker.internet.ipv4()}');
  print('');

  print('=== Demo Complete - Features Demonstrated ===');
  print('✅ Multi-language support (EN/ZH_TW/JA)');
  print('✅ Taiwan-specific data generation');
  print('✅ Commerce and e-commerce data');
  print('✅ Person and location data');
  print('✅ System and internet data');
  print('✅ Color and datetime data');
  print('✅ Schema-based generation (available)');
  print('✅ Export functionality (available)');
  print('');
  print('🚀 Ready for integration into your Flutter apps!');
}
