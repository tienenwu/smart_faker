/// Manages locale settings and data loading for internationalization.
class LocaleManager {
  /// Creates a new locale manager.
  LocaleManager(String locale) : _currentLocale = locale {
    _loadLocale(locale);
  }

  String _currentLocale;
  final Map<String, LocaleData> _loadedLocales = {};

  /// Gets the current locale.
  String get currentLocale => _currentLocale;

  /// Gets the list of supported locales.
  static const List<String> supportedLocales = [
    'en_US', // English (United States)
    'zh_TW', // Traditional Chinese (Taiwan)
    'ja_JP', // Japanese (Japan)
  ];

  /// Sets the current locale.
  void setLocale(String locale) {
    if (!supportedLocales.contains(locale)) {
      throw ArgumentError('Unsupported locale: $locale');
    }
    _currentLocale = locale;
    _loadLocale(locale);
  }

  /// Gets locale data for a specific locale.
  LocaleData? getLocaleData(String locale) {
    return _loadedLocales[locale];
  }

  /// Gets data with fallback support.
  T? getData<T>(String category, String field, {String? locale}) {
    locale ??= _currentLocale;

    // Try exact locale first
    var data = _loadedLocales[locale]?.getData(category, field);
    if (data != null) return data as T;

    // Try language without region (e.g., 'en' from 'en_US')
    final language = locale.split('_').first;
    for (final loadedLocale in _loadedLocales.keys) {
      if (loadedLocale.startsWith(language)) {
        data = _loadedLocales[loadedLocale]?.getData(category, field);
        if (data != null) return data as T;
      }
    }

    // Fallback to English
    return _loadedLocales['en_US']?.getData(category, field) as T?;
  }

  void _loadLocale(String locale) {
    if (_loadedLocales.containsKey(locale)) return;

    // In Phase 4, we'll implement actual locale loading
    // For now, we'll create a placeholder
    _loadedLocales[locale] = LocaleData(locale);
  }
}

/// Container for locale-specific data.
class LocaleData {
  /// Creates locale data for a specific locale.
  LocaleData(this.locale);

  final String locale;
  final Map<String, Map<String, dynamic>> _data = {};

  /// Gets data for a specific category and field.
  dynamic getData(String category, String field) {
    return _data[category]?[field];
  }

  /// Sets data for a specific category and field.
  void setData(String category, String field, dynamic value) {
    _data[category] ??= {};
    _data[category]![field] = value;
  }

  /// Loads data for a category.
  void loadCategory(String category, Map<String, dynamic> data) {
    _data[category] = data;
  }
}
