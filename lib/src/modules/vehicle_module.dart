import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating vehicle-related data.
class VehicleModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;
  
  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [VehicleModule].
  /// 
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of vehicle data.
  VehicleModule(this.random, this.localeManager);

  /// Gets the current locale code.
  String get currentLocale => localeManager.currentLocale;

  /// Generates a vehicle manufacturer name.
  String manufacturer() {
    final manufacturers = _getLocaleData('manufacturers');
    return random.element(manufacturers);
  }

  /// Generates a vehicle model name.
  String model() {
    final models = _getLocaleData('models');
    return random.element(models);
  }

  /// Generates a vehicle type.
  String type() {
    final types = ['Sedan', 'SUV', 'Truck', 'Van', 'Coupe', 'Convertible', 'Hatchback'];
    return random.element(types);
  }

  /// Generates a fuel type.
  String fuel() {
    final fuels = ['Gasoline', 'Diesel', 'Electric', 'Hybrid', 'Hydrogen'];
    return random.element(fuels);
  }

  /// Generates a vehicle color.
  String color() {
    final colors = _getLocaleData('colors');
    return random.element(colors);
  }

  /// Generates a transmission type.
  String transmission() {
    final transmissions = ['Manual', 'Automatic', 'CVT', 'Semi-Automatic'];
    return random.element(transmissions);
  }

  /// Generates a VIN (Vehicle Identification Number).
  String vin() {
    // VIN excludes I, O, Q to avoid confusion with 1, 0
    const chars = 'ABCDEFGHJKLMNPRSTUVWXYZ0123456789';
    
    // Generate WMI (World Manufacturer Identifier) - first 3 characters
    final wmi = List.generate(3, (_) => 
      chars[random.nextInt(chars.length)]).join();
    
    // Generate VDS (Vehicle Descriptor Section) - characters 4-9
    final vds = List.generate(6, (_) => 
      chars[random.nextInt(chars.length)]).join();
    
    // Generate VIS (Vehicle Identifier Section) - characters 10-17
    final vis = List.generate(8, (_) => 
      chars[random.nextInt(chars.length)]).join();
    
    return wmi + vds + vis;
  }

  /// Generates a license plate number.
  String licensePlate() {
    switch (currentLocale) {
      case 'zh_TW':
        // Taiwan format: ABC-1234
        final letters = List.generate(3, (_) => 
          String.fromCharCode(65 + random.nextInt(26))).join();
        final numbers = random.nextInt(9999).toString().padLeft(4, '0');
        return '$letters-$numbers';
        
      case 'ja_JP':
        // Japanese format: 品川 50-12
        final regions = ['品川', '練馬', '足立', '世田谷', '杉並'];
        final region = random.element(regions);
        final num1 = random.nextInt(99).toString().padLeft(2, '0');
        final num2 = random.nextInt(99).toString().padLeft(2, '0');
        return '$region $num1-$num2';
        
      default:
        // US format: ABC-1234
        final letters = List.generate(3, (_) => 
          String.fromCharCode(65 + random.nextInt(26))).join();
        final numbers = random.nextInt(9999).toString().padLeft(4, '0');
        return '$letters-$numbers';
    }
  }

  /// Generates a vehicle registration number.
  String registration() {
    final numbers = random.nextInt(99999999).toString().padLeft(8, '0');
    return 'REG$numbers';
  }

  /// Generates a manufacture year.
  int year() {
    final currentYear = DateTime.now().year;
    return random.integer(min: 1990, max: currentYear + 1);
  }

  /// Generates an engine type.
  String engine() {
    final engines = _getLocaleData('engines');
    return random.element(engines);
  }

  /// Generates a drive type.
  String drive() {
    final drives = ['FWD', 'RWD', 'AWD', '4WD'];
    return random.element(drives);
  }

  /// Generates number of doors.
  int doors() {
    final doorOptions = [2, 3, 4, 5];
    return random.element(doorOptions);
  }

  /// Generates number of seats.
  int seats() {
    return random.integer(min: 2, max: 9);
  }

  /// Generates mileage.
  int mileage() {
    return random.integer(min: 0, max: 300000);
  }

  List<String> _getLocaleData(String key) {
    switch (currentLocale) {
      case 'zh_TW':
        return _zhTWData[key] ?? _enUSData[key] ?? [];
      case 'ja_JP':
        return _jaJPData[key] ?? _enUSData[key] ?? [];
      default:
        return _enUSData[key] ?? [];
    }
  }

  static final Map<String, List<String>> _enUSData = {
    'manufacturers': [
      'Toyota', 'Honda', 'Ford', 'Chevrolet', 'Tesla', 'BMW', 'Mercedes-Benz',
      'Audi', 'Volkswagen', 'Nissan', 'Hyundai', 'Kia', 'Mazda', 'Subaru',
      'Jeep', 'Ram', 'GMC', 'Lexus', 'Porsche', 'Ferrari', 'Lamborghini',
    ],
    'models': [
      'Accord', 'Camry', 'Civic', 'Corolla', 'Model 3', 'Model S', 'F-150',
      'Silverado', 'RAV4', 'CR-V', 'Explorer', 'Highlander', 'Pilot',
      'Wrangler', 'Cherokee', 'Grand Cherokee', 'Mustang', 'Challenger',
      'Charger', '911', '488', 'Aventador', 'Huracan',
    ],
    'colors': [
      'Black', 'White', 'Silver', 'Gray', 'Red', 'Blue', 'Green',
      'Yellow', 'Orange', 'Brown', 'Pearl White', 'Metallic Blue',
      'Midnight Black', 'Racing Red', 'Forest Green',
    ],
    'engines': [
      '2.0L 4-Cylinder', '2.5L 4-Cylinder', '3.0L V6', '3.5L V6',
      '5.0L V8', '6.2L V8', '1.5L Turbo', '2.0L Turbo', 'Electric',
      '3.0L Hybrid', '2.5L Hybrid', '4.0L Twin-Turbo V8',
    ],
  };

  static final Map<String, List<String>> _zhTWData = {
    'manufacturers': [
      '豐田', '本田', '福特', '日產', '三菱', '馬自達', 'BMW', '賓士',
      '奧迪', '福斯', '現代', '起亞', '速霸陸', '特斯拉', '保時捷',
    ],
    'models': [
      'Altis', 'Vios', 'RAV4', 'Camry', 'CR-V', 'HR-V', 'Fit', 'City',
      'Kicks', 'X-Trail', 'Sentra', 'CX-5', 'Mazda3', 'Focus', 'Kuga',
    ],
    'colors': [
      '黑色', '白色', '銀色', '灰色', '紅色', '藍色', '綠色',
      '黃色', '橙色', '棕色', '珍珠白', '金屬藍', '午夜黑', '競速紅',
    ],
    'engines': [
      '1.5L 四缸', '1.8L 四缸', '2.0L 四缸', '2.5L 四缸',
      '3.0L V6', '3.5L V6', '1.5L 渦輪', '2.0L 渦輪',
      '電動', '2.5L 油電混合', '1.8L 油電混合',
    ],
  };

  static final Map<String, List<String>> _jaJPData = {
    'manufacturers': [
      'トヨタ', 'ホンダ', '日産', 'マツダ', 'スバル', '三菱', 'スズキ',
      'ダイハツ', 'レクサス', 'BMW', 'メルセデス', 'アウディ', 'フォルクスワーゲン',
    ],
    'models': [
      'プリウス', 'アクア', 'ヴォクシー', 'アルファード', 'カローラ',
      'フィット', 'ヴェゼル', 'フリード', 'ノート', 'セレナ', 'エクストレイル',
      'CX-5', 'デミオ', 'インプレッサ', 'レヴォーグ',
    ],
    'colors': [
      'ブラック', 'ホワイト', 'シルバー', 'グレー', 'レッド', 'ブルー',
      'グリーン', 'イエロー', 'オレンジ', 'ブラウン', 'パールホワイト',
      'メタリックブルー', 'ミッドナイトブラック',
    ],
    'engines': [
      '1.5L 直4', '2.0L 直4', '2.5L 直4', '3.0L V6', '3.5L V6',
      '1.5L ターボ', '2.0L ターボ', '電気', '2.5L ハイブリッド',
      '1.8L ハイブリッド', '3.0L ツインターボ',
    ],
  };
}