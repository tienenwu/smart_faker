import '../core/random_generator.dart';
import '../core/locale_manager.dart';
import '../locales/en_us/commerce_data.dart';
import '../locales/zh_tw/commerce_data.dart';
import '../locales/ja_jp/commerce_data.dart';

/// Module for generating commerce-related fake data.
class CommerceModule {
  /// Random generator instance for generating random values.
  final RandomGenerator _random;

  /// Locale manager for handling localization.
  final LocaleManager _localeManager;

  /// Creates a new instance of [CommerceModule].
  ///
  /// [_random] is used for generating random values.
  /// [_localeManager] handles localization of commerce data.
  CommerceModule(this._random, this._localeManager);

  /// Gets the current locale code.
  String get currentLocale => _localeManager.currentLocale;

  /// Generates a product name.
  String productName() {
    final adjective = productAdjective();
    final material = productMaterial();
    final product = _getProductName();

    // Sometimes use adjective, sometimes material, sometimes both
    final choice = _random.integer(min: 0, max: 3);
    switch (choice) {
      case 0:
        return '$adjective $product';
      case 1:
        return '$material $product';
      case 2:
        return '$adjective $material $product';
      default:
        return product;
    }
  }

  String _getProductName() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseCommerceData.productNames);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.productNames);
      default: // en_US
        return _random.element(EnglishCommerceData.productNames);
    }
  }

  /// Generates a product category.
  String category() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseCommerceData.categories);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.categories);
      default: // en_US
        return _random.element(EnglishCommerceData.categories);
    }
  }

  /// Generates a department name.
  String department() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseCommerceData.departments);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.departments);
      default: // en_US
        return _random.element(EnglishCommerceData.departments);
    }
  }

  /// Generates a product material.
  String productMaterial() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseCommerceData.productMaterials);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.productMaterials);
      default: // en_US
        return _random.element(EnglishCommerceData.productMaterials);
    }
  }

  /// Generates a product adjective.
  String productAdjective() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random
            .element(TraditionalChineseCommerceData.productAdjectives);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.productAdjectives);
      default: // en_US
        return _random.element(EnglishCommerceData.productAdjectives);
    }
  }

  /// Generates a product description.
  String productDescription() {
    final name = productName();
    final category = this.category();
    final material = productMaterial();

    switch (currentLocale) {
      case 'zh_TW':
        return '這個$name是我們$category系列中最受歡迎的產品之一。採用優質$material製成，確保持久耐用。';
      case 'ja_JP':
        return 'この$nameは、私たちの$categoryシリーズで最も人気のある製品の一つです。高品質の$materialで作られ、長持ちします。';
      default: // en_US
        return 'This $name is one of our most popular products in the $category category. Made with premium $material, ensuring long-lasting durability.';
    }
  }

  /// Generates a price.
  double price({double min = 1.0, double max = 1000.0}) {
    final value = min + _random.nextDouble() * (max - min);
    // Round to 2 decimal places
    return (value * 100).round() / 100;
  }

  /// Generates a price string with currency.
  String priceString({double min = 1.0, double max = 1000.0}) {
    final priceValue = price(min: min, max: max);
    final symbol = _getCurrencySymbol();

    switch (currentLocale) {
      case 'ja_JP':
        // Japanese Yen doesn't use decimals
        return '$symbol${priceValue.round()}';
      default:
        return '$symbol${priceValue.toStringAsFixed(2)}';
    }
  }

  String _getCurrencySymbol() {
    switch (currentLocale) {
      case 'zh_TW':
        return TraditionalChineseCommerceData.currencySymbol;
      case 'ja_JP':
        return JapaneseCommerceData.currencySymbol;
      default: // en_US
        return EnglishCommerceData.currencySymbol;
    }
  }

  /// Generates a discount percentage.
  int discountPercentage({int min = 5, int max = 90}) {
    return _random.integer(min: min, max: max);
  }

  /// Generates a SKU (Stock Keeping Unit).
  String sku() {
    final letters = List.generate(3,
            (_) => String.fromCharCode(65 + _random.integer(min: 0, max: 25)))
        .join();
    final numbers = _random.integer(min: 100000, max: 999999);
    return '$letters-$numbers';
  }

  /// Generates a barcode (EAN-13).
  String barcode() {
    // Generate first 12 digits
    final digits = List.generate(12, (_) => _random.integer(min: 0, max: 9));

    // Calculate EAN-13 checksum
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += (i % 2 == 0) ? digits[i] : digits[i] * 3;
    }
    int checkDigit = (10 - (sum % 10)) % 10;

    return digits.join() + checkDigit.toString();
  }

  /// Generates an ISBN.
  String isbn() {
    // ISBN-13 format: 978-X-XXXXX-XXX-X
    final group = _random.integer(min: 0, max: 9);
    final publisher = _random.integer(min: 10000, max: 99999);
    final title = _random.integer(min: 100, max: 999);

    // Calculate check digit (simplified)
    final checkDigit = _random.integer(min: 0, max: 9);

    return '978-$group-$publisher-$title-$checkDigit';
  }

  /// Generates a color name.
  String color() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseCommerceData.colors);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.colors);
      default: // en_US
        return _random.element(EnglishCommerceData.colors);
    }
  }

  /// Generates a hex color code.
  String hexColor() {
    final r = _random.integer(min: 0, max: 255);
    final g = _random.integer(min: 0, max: 255);
    final b = _random.integer(min: 0, max: 255);

    return '#${r.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${g.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  /// Generates an RGB color string.
  String rgbColor() {
    final r = _random.integer(min: 0, max: 255);
    final g = _random.integer(min: 0, max: 255);
    final b = _random.integer(min: 0, max: 255);

    return 'rgb($r, $g, $b)';
  }

  /// Generates a store name.
  String storeName() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseCommerceData.storeNames);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.storeNames);
      default: // en_US
        return _random.element(EnglishCommerceData.storeNames);
    }
  }

  /// Generates a brand name.
  String brand() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseCommerceData.brands);
      case 'ja_JP':
        return _random.element(JapaneseCommerceData.brands);
      default: // en_US
        return _random.element(EnglishCommerceData.brands);
    }
  }

  /// Generates a company type.
  String companyType() {
    final types = ['Inc.', 'LLC', 'Corp.', 'Ltd.', 'Group'];
    return _random.element(types);
  }
}
