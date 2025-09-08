/// Configuration options for SmartFaker.
class FakerConfig {
  /// Creates a new configuration instance.
  FakerConfig({
    this.defaultLocale = 'en_US',
    this.fallbackLocale = 'en_US',
    this.strictMode = false,
    this.cacheEnabled = true,
    this.maxCacheSize = 1000,
  });

  /// The default locale to use for data generation.
  final String defaultLocale;

  /// The fallback locale when data is not available in the requested locale.
  final String fallbackLocale;

  /// Whether to throw errors for missing data (strict) or fallback gracefully.
  final bool strictMode;

  /// Whether to cache generated locale data for performance.
  final bool cacheEnabled;

  /// Maximum number of cached items per module.
  final int maxCacheSize;

  /// Creates a copy of this config with optional overrides.
  FakerConfig copyWith({
    String? defaultLocale,
    String? fallbackLocale,
    bool? strictMode,
    bool? cacheEnabled,
    int? maxCacheSize,
  }) {
    return FakerConfig(
      defaultLocale: defaultLocale ?? this.defaultLocale,
      fallbackLocale: fallbackLocale ?? this.fallbackLocale,
      strictMode: strictMode ?? this.strictMode,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
      maxCacheSize: maxCacheSize ?? this.maxCacheSize,
    );
  }
}