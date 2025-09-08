import '../core/locale_manager.dart';
import '../core/random_generator.dart';
import '../core/smart_faker.dart';
import 'person_module.dart';
import 'internet_module.dart';
import 'location_module.dart';
import 'datetime_module.dart';
import 'commerce_module.dart';
import 'company_module.dart';
import 'finance_module.dart';
import 'vehicle_module.dart';
import 'lorem_module.dart';
import 'system_module.dart';
import 'image_module.dart';
import 'phone_module.dart';
import 'color_module.dart';
import 'crypto_module.dart';
import 'food_module.dart';
import 'music_module.dart';

/// Registry for all data generation modules.
class ModuleRegistry {
  /// Creates a new module registry.
  ModuleRegistry({
    required this.faker,
    required this.randomGenerator,
    required this.localeManager,
  }) {
    _initializeModules();
  }

  final SmartFaker faker;
  final RandomGenerator randomGenerator;
  final LocaleManager localeManager;

  // Module instances will be stored here
  late PersonModule _person;
  late InternetModule _internet;
  late LocationModule _location;
  late DateTimeModule _dateTime;
  late CommerceModule _commerce;
  late CompanyModule _company;
  late FinanceModule _finance;
  late VehicleModule _vehicle;
  late LoremModule _lorem;
  late SystemModule _system;
  late ImageModule _image;
  late PhoneModule _phone;
  late ColorModule _color;
  late CryptoModule _crypto;
  late FoodModule _food;
  late MusicModule _music;

  // Module getters
  PersonModule get person => _person;
  InternetModule get internet => _internet;
  LocationModule get location => _location;
  DateTimeModule get dateTime => _dateTime;
  CommerceModule get commerce => _commerce;
  CompanyModule get company => _company;
  FinanceModule get finance => _finance;
  VehicleModule get vehicle => _vehicle;
  LoremModule get lorem => _lorem;
  SystemModule get system => _system;
  ImageModule get image => _image;
  PhoneModule get phone => _phone;
  ColorModule get color => _color;
  CryptoModule get crypto => _crypto;
  FoodModule get food => _food;
  MusicModule get music => _music;

  void _initializeModules() {
    // Initialize all modules here
    _person = PersonModule(
        randomGenerator: randomGenerator, localeManager: localeManager);
    _internet = InternetModule(
        randomGenerator: randomGenerator, localeManager: localeManager);
    _location = LocationModule(randomGenerator, localeManager);
    _dateTime = DateTimeModule(randomGenerator, localeManager);
    _commerce = CommerceModule(randomGenerator, localeManager);
    _company = CompanyModule(randomGenerator, localeManager);
    _finance = FinanceModule(randomGenerator, localeManager);
    _vehicle = VehicleModule(randomGenerator, localeManager);
    _lorem = LoremModule(randomGenerator, localeManager);
    _system = SystemModule(randomGenerator, localeManager);
    _image = ImageModule(randomGenerator, localeManager);
    _phone = PhoneModule(randomGenerator, localeManager);
    _color = ColorModule(randomGenerator, localeManager);
    _crypto = CryptoModule(randomGenerator, localeManager);
    _food = FoodModule(randomGenerator, localeManager);
    _music = MusicModule(randomGenerator, localeManager);
  }

  /// Reinitializes all modules (useful when locale changes).
  void reinitialize() {
    _initializeModules();
  }
}
