import 'dart:math';
import '../core/random_generator.dart';
import '../core/locale_manager.dart';
import '../locales/en_us/location_data.dart';
import '../locales/zh_tw/location_data.dart';
import '../locales/ja_jp/location_data.dart';
import 'models/coordinates.dart';

/// Module for generating location-related fake data.
class LocationModule {
  final RandomGenerator _random;
  final LocaleManager _localeManager;

  LocationModule(this._random, this._localeManager);

  String get currentLocale => _localeManager.currentLocale;

  /// Generates a street address.
  String streetAddress() {
    final buildingNumber = this.buildingNumber();
    final streetName = this.streetName();
    
    switch (currentLocale) {
      case 'zh_TW':
        final district = _random.element(TraditionalChineseLocationData.districts);
        final road = _random.element(TraditionalChineseLocationData.roadNames);
        final roadType = _random.element(TraditionalChineseLocationData.roadTypes);
        final section = _random.nextBool() 
            ? _random.element(TraditionalChineseLocationData.sections)
            : '';
        final number = '${_random.integer(min: 1, max: 500)}號';
        return '$district$road$roadType$section$number';
        
      case 'ja_JP':
        final district = _random.element(JapaneseLocationData.districts);
        final number = '${_random.integer(min: 1, max: 20)}-${_random.integer(min: 1, max: 30)}-${_random.integer(min: 1, max: 20)}';
        return '$district$number';
        
      default: // en_US
        return '$buildingNumber $streetName';
    }
  }

  /// Generates a street name.
  String streetName() {
    switch (currentLocale) {
      case 'zh_TW':
        final road = _random.element(TraditionalChineseLocationData.roadNames);
        final roadType = _random.element(TraditionalChineseLocationData.roadTypes);
        return '$road$roadType';
        
      case 'ja_JP':
        final district = _random.element(JapaneseLocationData.districts);
        return district;
        
      default: // en_US
        final name = _random.element(EnglishLocationData.streetNames);
        final suffix = _random.element(EnglishLocationData.streetSuffixes);
        return '$name $suffix';
    }
  }

  /// Generates a building number.
  String buildingNumber() {
    switch (currentLocale) {
      case 'zh_TW':
        return '${_random.integer(min: 1, max: 500)}號';
        
      case 'ja_JP':
        return '${_random.integer(min: 1, max: 20)}-${_random.integer(min: 1, max: 30)}';
        
      default: // en_US
        return _random.integer(min: 100, max: 9999).toString();
    }
  }

  /// Generates a secondary address (apartment, suite, etc.).
  String secondaryAddress() {
    switch (currentLocale) {
      case 'zh_TW':
        final floor = _random.integer(min: 1, max: 30);
        final room = _random.integer(min: 1, max: 10);
        return '${floor}樓之$room';
        
      case 'ja_JP':
        final buildingName = _random.element(JapaneseLocationData.buildingNames);
        final buildingType = _random.element(JapaneseLocationData.buildingTypes);
        final floor = _random.integer(min: 1, max: 20);
        final room = _random.integer(min: 101, max: 999);
        return '$buildingName$buildingType ${floor}F-$room';
        
      default: // en_US
        final types = ['Apt.', 'Suite', 'Unit'];
        final type = _random.element(types);
        final number = type == 'Suite' 
            ? _random.integer(min: 100, max: 999).toString()
            : '${_random.integer(min: 1, max: 20)}${String.fromCharCode(65 + _random.integer(min: 0, max: 25))}';
        return '$type $number';
    }
  }

  /// Generates a full address.
  String fullAddress() {
    switch (currentLocale) {
      case 'zh_TW':
        final postalCode = this.postalCode();
        final city = this.city();
        final streetAddr = streetAddress();
        final secondary = _random.nextBool() ? ', ${secondaryAddress()}' : '';
        return '$postalCode $city$streetAddr$secondary';
        
      case 'ja_JP':
        final postalCode = this.postalCode();
        final prefecture = _random.element(JapaneseLocationData.prefectures);
        final city = this.city();
        final streetAddr = streetAddress();
        final secondary = _random.nextBool() ? ' ${secondaryAddress()}' : '';
        return '〒$postalCode $prefecture$city$streetAddr$secondary';
        
      default: // en_US
        final streetAddr = streetAddress();
        final secondary = _random.nextBool() ? secondaryAddress() : null;
        final cityName = city();
        final stateAbbr = this.stateAbbr();
        final zip = zipCode();
        
        if (secondary != null) {
          return '$streetAddr, $secondary, $cityName, $stateAbbr $zip';
        } else {
          return '$streetAddr, $cityName, $stateAbbr $zip';
        }
    }
  }

  /// Generates a city name.
  String city() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.nextBool()
            ? _random.element(TraditionalChineseLocationData.cities)
            : _random.element(TraditionalChineseLocationData.counties);
        
      case 'ja_JP':
        return _random.element(JapaneseLocationData.cities);
        
      default: // en_US
        return _random.element(EnglishLocationData.cities);
    }
  }

  /// Generates a state name.
  String state() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.nextBool()
            ? _random.element(TraditionalChineseLocationData.cities)
            : _random.element(TraditionalChineseLocationData.counties);
        
      case 'ja_JP':
        return _random.element(JapaneseLocationData.prefectures);
        
      default: // en_US
        return EnglishLocationData.states.keys.elementAt(
          _random.integer(min: 0, max: EnglishLocationData.states.length - 1)
        );
    }
  }

  /// Generates a state abbreviation.
  String stateAbbr() {
    switch (currentLocale) {
      case 'zh_TW':
        // Return short form for Taiwan regions
        final city = _random.element(TraditionalChineseLocationData.cities);
        if (city.contains('台北')) return '北';
        if (city.contains('台中')) return '中';
        if (city.contains('台南')) return '南';
        if (city.contains('高雄')) return '高';
        return city.substring(0, min(2, city.length));
        
      case 'ja_JP':
        // Return short form for Japanese prefectures
        final prefecture = _random.element(JapaneseLocationData.prefectures);
        if (prefecture == '東京都') return '東京';
        if (prefecture == '大阪府') return '大阪';
        if (prefecture == '京都府') return '京都';
        return prefecture.replaceAll('県', '').substring(0, min(2, prefecture.length));
        
      default: // en_US
        return EnglishLocationData.states.values.elementAt(
          _random.integer(min: 0, max: EnglishLocationData.states.length - 1)
        );
    }
  }

  /// Generates a country name.
  String country() {
    switch (currentLocale) {
      case 'zh_TW':
        final countries = ['台灣', '中國', '日本', '韓國', '美國', 
                          '英國', '法國', '德國', '加拿大', '澳洲'];
        return _random.element(countries);
        
      case 'ja_JP':
        final countries = ['日本', 'アメリカ', 'イギリス', 'フランス', 'ドイツ',
                          '中国', '韓国', 'カナダ', 'オーストラリア', 'イタリア'];
        return _random.element(countries);
        
      default: // en_US
        return _random.element(EnglishLocationData.countries);
    }
  }

  /// Generates a country code.
  String countryCode() {
    switch (currentLocale) {
      case 'zh_TW':
        final codes = ['TW', 'CN', 'JP', 'KR', 'US', 'GB', 'FR', 'DE', 'CA', 'AU'];
        return _random.element(codes);
        
      case 'ja_JP':
        final codes = ['JP', 'US', 'GB', 'FR', 'DE', 'CN', 'KR', 'CA', 'AU', 'IT'];
        return _random.element(codes);
        
      default: // en_US
        return EnglishLocationData.countryCodes.values.elementAt(
          _random.integer(min: 0, max: EnglishLocationData.countryCodes.length - 1)
        );
    }
  }

  /// Generates a zip code.
  String zipCode() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseLocationData.postalCodes);
        
      case 'ja_JP':
        return _random.element(JapaneseLocationData.postalCodes);
        
      default: // en_US
        final basic = _random.integer(min: 10000, max: 99999).toString();
        if (_random.nextBool()) {
          final extended = _random.integer(min: 1000, max: 9999).toString();
          return '$basic-$extended';
        }
        return basic;
    }
  }

  /// Generates a postal code (alias for zipCode).
  String postalCode() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseLocationData.postalCodes);
        
      case 'ja_JP':
        final code = _random.element(JapaneseLocationData.postalCodes);
        return code.replaceAll('-', '');
        
      default: // en_US
        return zipCode();
    }
  }

  /// Generates a latitude coordinate.
  double latitude({double? min, double? max}) {
    min ??= -90.0;
    max ??= 90.0;
    return min + _random.nextDouble() * (max - min);
  }

  /// Generates a longitude coordinate.
  double longitude({double? min, double? max}) {
    min ??= -180.0;
    max ??= 180.0;
    return min + _random.nextDouble() * (max - min);
  }

  /// Generates a coordinate pair.
  Coordinates coordinates({
    double? minLat,
    double? maxLat,
    double? minLon,
    double? maxLon,
  }) {
    return Coordinates(
      latitude: latitude(min: minLat, max: maxLat),
      longitude: longitude(min: minLon, max: maxLon),
    );
  }

  /// Generates coordinates near a given point.
  Coordinates nearbyCoordinates({
    required double latitude,
    required double longitude,
    double radius = 10, // km
  }) {
    // Convert radius from km to degrees (rough approximation)
    // 1 degree latitude ≈ 111 km
    final radiusInDegrees = radius / 111.0;
    
    // Generate random angle and distance
    final angle = _random.nextDouble() * 2 * pi;
    final distance = _random.nextDouble() * radiusInDegrees;
    
    // Calculate new coordinates
    final newLat = latitude + distance * cos(angle);
    final newLon = longitude + distance * sin(angle);
    
    // Ensure coordinates are within valid ranges
    final clampedLat = newLat.clamp(-90.0, 90.0);
    final clampedLon = newLon.clamp(-180.0, 180.0);
    
    return Coordinates(
      latitude: clampedLat,
      longitude: clampedLon,
    );
  }

  /// Generates a timezone.
  String timezone() {
    switch (currentLocale) {
      case 'zh_TW':
        return 'Asia/Taipei';
        
      case 'ja_JP':
        return 'Asia/Tokyo';
        
      default: // en_US
        return _random.element(EnglishLocationData.timezones);
    }
  }

  /// Generates a compass direction.
  String direction() {
    final directions = ['North', 'South', 'East', 'West',
                       'Northeast', 'Northwest', 'Southeast', 'Southwest'];
    
    switch (currentLocale) {
      case 'zh_TW':
        final zhDirections = ['北', '南', '東', '西', '東北', '西北', '東南', '西南'];
        return _random.element(zhDirections);
        
      case 'ja_JP':
        final jaDirections = ['北', '南', '東', '西', '北東', '北西', '南東', '南西'];
        return _random.element(jaDirections);
        
      default: // en_US
        return _random.element(directions);
    }
  }

  /// Generates a cardinal direction abbreviation.
  String cardinalDirection() {
    final cardinals = ['N', 'S', 'E', 'W', 'NE', 'NW', 'SE', 'SW'];
    return _random.element(cardinals);
  }
}