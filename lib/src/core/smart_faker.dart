import 'package:meta/meta.dart';

import 'faker_config.dart';
import 'locale_manager.dart';
import 'random_generator.dart';
import '../modules/module_registry.dart';
import '../modules/person_module.dart';
import '../modules/internet_module.dart';
import '../modules/location_module.dart';
import '../modules/datetime_module.dart';
import '../modules/commerce_module.dart';
import '../modules/company_module.dart';
import '../modules/finance_module.dart';
import '../modules/vehicle_module.dart';
import '../modules/lorem_module.dart';
import '../modules/system_module.dart';
import '../modules/image_module.dart';
import '../modules/phone_module.dart';
import '../modules/color_module.dart';
import '../modules/crypto_module.dart';
import '../modules/food_module.dart';
import '../modules/music_module.dart';
import '../modules/export_module.dart';
import '../modules/taiwan_module.dart';
import '../modules/social_media_module.dart';
import '../modules/ecommerce_module.dart';
import '../modules/healthcare_module.dart';
import '../modules/pattern_module.dart';

/// The main SmartFaker class that provides access to all data generation modules.
///
/// Example usage:
/// ```dart
/// final faker = SmartFaker();
/// final name = faker.person.fullName();
/// final email = faker.internet.email();
/// ```
class SmartFaker {
  /// Creates a new instance of SmartFaker.
  ///
  /// [seed] - Optional seed for reproducible random generation.
  /// [locale] - The locale to use for data generation (default: 'en_US').
  /// [config] - Optional configuration for customizing behavior.
  SmartFaker({
    int? seed,
    String locale = 'en_US',
    FakerConfig? config,
  })  : _config = config ?? FakerConfig(),
        _randomGenerator = RandomGenerator(seed: seed),
        _localeManager = LocaleManager(locale) {
    _initializeModules();
  }

  /// Singleton instance for convenience.
  static SmartFaker? _instance;

  /// Gets the singleton instance of SmartFaker.
  static SmartFaker get instance {
    _instance ??= SmartFaker();
    return _instance!;
  }

  final FakerConfig _config;
  final RandomGenerator _randomGenerator;
  final LocaleManager _localeManager;
  late final ModuleRegistry _moduleRegistry;

  /// Gets the random generator for direct access to random utilities.
  RandomGenerator get random => _randomGenerator;

  /// Gets the current locale.
  String get locale => _localeManager.currentLocale;

  /// Gets the configuration.
  FakerConfig get config => _config;

  /// Sets the locale for data generation.
  ///
  /// [locale] - The locale code (e.g., 'en_US', 'de_DE', 'ja_JP').
  void setLocale(String locale) {
    _localeManager.setLocale(locale);
    _reinitializeModules();
  }

  /// Sets a seed for reproducible random generation.
  ///
  /// [seed] - The seed value.
  void seed(int seed) {
    _randomGenerator.seed(seed);
  }

  /// Generates data from a schema definition.
  ///
  /// This is for future schema-based generation support.
  @experimental
  T generate<T>() {
    throw UnimplementedError(
        'Schema-based generation will be implemented in Phase 3');
  }

  /// Generates a list of data from a schema definition.
  ///
  /// This is for future schema-based generation support.
  @experimental
  List<T> generateList<T>({required int count}) {
    throw UnimplementedError(
        'Schema-based generation will be implemented in Phase 3');
  }

  void _initializeModules() {
    _moduleRegistry = ModuleRegistry(
      faker: this,
      randomGenerator: _randomGenerator,
      localeManager: _localeManager,
    );
  }

  void _reinitializeModules() {
    _moduleRegistry.reinitialize();
  }

  // Module getters
  /// Gets the person module for generating person-related data.
  PersonModule get person => _moduleRegistry.person;

  /// Gets the internet module for generating internet-related data.
  InternetModule get internet => _moduleRegistry.internet;

  /// Gets the location module for generating location-related data.
  LocationModule get location => _moduleRegistry.location;

  /// Gets the datetime module for generating date and time related data.
  DateTimeModule get dateTime => _moduleRegistry.dateTime;

  /// Gets the commerce module for generating commerce-related data.
  CommerceModule get commerce => _moduleRegistry.commerce;

  /// Gets the company module for generating company-related data.
  CompanyModule get company => _moduleRegistry.company;

  /// Gets the finance module for generating finance-related data.
  FinanceModule get finance => _moduleRegistry.finance;

  /// Gets the vehicle module for generating vehicle-related data.
  VehicleModule get vehicle => _moduleRegistry.vehicle;

  /// Gets the lorem module for generating lorem ipsum text.
  LoremModule get lorem => _moduleRegistry.lorem;

  /// Gets the system module for generating system-related data.
  SystemModule get system => _moduleRegistry.system;

  /// Gets the image module for generating image-related data.
  ImageModule get image => _moduleRegistry.image;

  /// Gets the phone module for generating phone-related data.
  PhoneModule get phone => _moduleRegistry.phone;

  /// Gets the color module for generating color-related data.
  ColorModule get color => _moduleRegistry.color;

  /// Gets the crypto module for generating cryptocurrency-related data.
  CryptoModule get crypto => _moduleRegistry.crypto;

  /// Gets the food module for generating food-related data.
  FoodModule get food => _moduleRegistry.food;

  /// Gets the music module for generating music-related data.
  MusicModule get music => _moduleRegistry.music;

  /// Gets the export module for exporting data to various formats.
  ExportModule get export => const ExportModule();

  /// Gets the Taiwan module for generating Taiwan-specific data.
  /// Only available when locale is set to 'zh_TW'.
  TaiwanModule get taiwan {
    if (locale != 'zh_TW') {
      throw StateError('Taiwan module is only available for zh_TW locale');
    }
    return TaiwanModule(_randomGenerator);
  }

  /// Gets the social media module for generating social media-related data.
  SocialMediaModule get social =>
      SocialMediaModule(_randomGenerator, _localeManager);

  /// Gets the e-commerce module for generating e-commerce related data.
  EcommerceModule get ecommerce =>
      EcommerceModule(_randomGenerator, _localeManager);

  /// Gets the healthcare module for generating healthcare-related data.
  HealthcareModule get healthcare =>
      HealthcareModule(_randomGenerator, _localeManager);

  /// Gets the pattern module for generating data from regex patterns.
  PatternModule get pattern => PatternModule(_randomGenerator, _localeManager);
}
