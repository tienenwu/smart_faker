import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class TaiwanDemoScreen extends StatefulWidget {
  const TaiwanDemoScreen({super.key});

  @override
  State<TaiwanDemoScreen> createState() => _TaiwanDemoScreenState();
}

class _TaiwanDemoScreenState extends State<TaiwanDemoScreen> {
  final faker = SmartFaker(locale: 'zh_TW', seed: 12345);
  
  // Generated data
  String _idNumber = '';
  String _companyTaxId = '';
  String _landlineNumber = '';
  String _mobileNumber = '';
  String _postalCode3 = '';
  String _postalCode5 = '';
  String _carPlate = '';
  String _motorcyclePlate = '';
  String _electricPlate = '';
  String _bankAccount = '';
  String _healthInsurance = '';
  
  // Person data
  String _fullName = '';
  String _firstName = '';
  String _lastName = '';
  String _jobTitle = '';
  int _age = 0;
  
  // Company data
  String _companyName = '';
  String _industry = '';
  
  // Location data
  String _city = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      // Taiwan-specific IDs
      _idNumber = faker.taiwan.idNumber(male: true);
      _companyTaxId = faker.taiwan.companyTaxId();
      _healthInsurance = faker.taiwan.healthInsuranceNumber();
      
      // Phone numbers
      _landlineNumber = faker.taiwan.landlineNumber();
      _mobileNumber = faker.phone.number();
      
      // Postal codes
      _postalCode3 = faker.taiwan.postalCode();
      _postalCode5 = faker.taiwan.postalCode(fiveDigit: true);
      
      // License plates
      _carPlate = faker.taiwan.licensePlate(type: 'car');
      _motorcyclePlate = faker.taiwan.licensePlate(type: 'motorcycle');
      _electricPlate = faker.taiwan.licensePlate(type: 'electric');
      
      // Financial
      _bankAccount = faker.taiwan.bankAccount();
      
      // Person data
      _fullName = faker.person.fullName();
      _firstName = faker.person.firstName();
      _lastName = faker.person.lastName();
      _jobTitle = faker.person.jobTitle();
      _age = faker.person.age();
      
      // Company
      _companyName = faker.company.name();
      _industry = faker.company.industry();
      
      // Location
      _city = faker.location.city();
      _address = faker.location.streetAddress();
    });
  }

  Widget _buildDataCard(String title, List<DataItem> items) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SelectableText(
                      item.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: item.value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.label} copied'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🇹🇼 Taiwan Module Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateAll,
            tooltip: 'Generate New Data',
          ),
        ],
      ),
      body: ListView(
        children: [
          // Info banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Generates valid Taiwan-specific data with proper checksums and formats',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          _buildDataCard(
            '🆔 身分證明 Identification',
            [
              DataItem('身分證字號 (男)', _idNumber),
              DataItem('身分證字號 (女)', faker.taiwan.idNumber(male: false)),
              DataItem('統一編號', _companyTaxId),
              DataItem('健保卡號', _healthInsurance),
            ],
          ),
          
          _buildDataCard(
            '📱 電話號碼 Phone Numbers',
            [
              DataItem('手機號碼', _mobileNumber),
              DataItem('市話號碼', _landlineNumber),
            ],
          ),
          
          _buildDataCard(
            '📮 郵遞區號 Postal Codes',
            [
              DataItem('郵遞區號 (3碼)', _postalCode3),
              DataItem('郵遞區號 (5碼)', _postalCode5),
            ],
          ),
          
          _buildDataCard(
            '🚗 車牌號碼 License Plates',
            [
              DataItem('汽車牌照', _carPlate),
              DataItem('機車牌照', _motorcyclePlate),
              DataItem('電動車牌照', _electricPlate),
            ],
          ),
          
          _buildDataCard(
            '💳 金融資訊 Financial',
            [
              DataItem('銀行帳號', _bankAccount),
              DataItem('信用卡號', faker.finance.creditCardNumber()),
            ],
          ),
          
          _buildDataCard(
            '👤 個人資料 Person Data',
            [
              DataItem('姓名', _fullName),
              DataItem('名字', _firstName),
              DataItem('姓氏', _lastName),
              DataItem('職稱', _jobTitle),
              DataItem('年齡', _age.toString()),
            ],
          ),
          
          _buildDataCard(
            '🏢 公司資料 Company Data',
            [
              DataItem('公司名稱', _companyName),
              DataItem('產業', _industry),
            ],
          ),
          
          _buildDataCard(
            '🏠 地址資料 Address Data',
            [
              DataItem('城市', _city),
              DataItem('地址', _address),
            ],
          ),
          
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Generate batch data for export
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
            },
          );
          
          final csv = faker.export.toCSV(users);
          Clipboard.setData(ClipboardData(text: csv));
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Batch data exported to clipboard as CSV'),
            ),
          );
        },
        label: const Text('Export Batch'),
        icon: const Icon(Icons.download),
      ),
    );
  }
}

class DataItem {
  final String label;
  final String value;
  
  DataItem(this.label, this.value);
}