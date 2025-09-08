/// Common field validators for schema validation.
class FieldValidators {
  /// Validates email format.
  static bool email(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(value);
  }

  /// Validates phone number format.
  static bool phone(dynamic value) {
    if (value is! String) return false;
    // Accepts various phone formats
    final regex = RegExp(
        r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$');
    return regex.hasMatch(value);
  }

  /// Validates URL format.
  static bool url(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return regex.hasMatch(value);
  }

  /// Validates credit card format.
  static bool creditCard(dynamic value) {
    if (value is! String) return false;
    final cleanValue = value.replaceAll(RegExp(r'\s|-'), '');
    if (cleanValue.length < 13 || cleanValue.length > 19) return false;
    return RegExp(r'^\d+$').hasMatch(cleanValue);
  }

  /// Validates UUID format.
  static bool uuid(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return regex.hasMatch(value);
  }

  /// Validates postal code (US format).
  static bool zipCode(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(r'^\d{5}(-\d{4})?$');
    return regex.hasMatch(value);
  }

  /// Validates Taiwan ID format.
  static bool taiwanId(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(r'^[A-Z][12]\d{8}$');
    return regex.hasMatch(value);
  }

  /// Validates IP address (IPv4).
  static bool ipv4(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return regex.hasMatch(value);
  }

  /// Validates MAC address.
  static bool macAddress(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(
      r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$',
    );
    return regex.hasMatch(value);
  }

  /// Validates hex color code.
  static bool hexColor(dynamic value) {
    if (value is! String) return false;
    final regex = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
    return regex.hasMatch(value);
  }

  /// Creates a custom regex validator.
  static bool Function(dynamic) regex(String pattern) {
    final regex = RegExp(pattern);
    return (dynamic value) {
      if (value is! String) return false;
      return regex.hasMatch(value);
    };
  }

  /// Creates a length validator.
  static bool Function(dynamic) length({int? min, int? max, int? exact}) {
    return (dynamic value) {
      if (value is! String) return false;
      if (exact != null) {
        return value.length == exact;
      }
      if (min != null && value.length < min) return false;
      if (max != null && value.length > max) return false;
      return true;
    };
  }

  /// Creates a range validator for numbers.
  static bool Function(dynamic) range({num? min, num? max}) {
    return (dynamic value) {
      if (value is! num) return false;
      if (min != null && value < min) return false;
      if (max != null && value > max) return false;
      return true;
    };
  }

  /// Creates a list contains validator.
  static bool Function(dynamic) inList(List<dynamic> validValues) {
    return (dynamic value) => validValues.contains(value);
  }

  /// Combines multiple validators (AND logic).
  static bool Function(dynamic) combine(
      List<bool Function(dynamic)> validators) {
    return (dynamic value) {
      for (final validator in validators) {
        if (!validator(value)) return false;
      }
      return true;
    };
  }

  /// Creates a custom validator from a regex pattern string.
  static bool Function(dynamic) fromPattern(String regexPattern) {
    final regex = RegExp(regexPattern);
    return (dynamic value) {
      if (value is! String) return false;
      return regex.hasMatch(value);
    };
  }
}

/// Common regex patterns for field generation.
class FieldPatterns {
  // Identity patterns
  static const String taiwanId = r'^[A-Z][12]\d{8}$';
  static const String usSSN = r'^\d{3}-\d{2}-\d{4}$';

  // Phone patterns
  static const String taiwanPhone = r'^09\d{8}$';
  static const String taiwanLandline = r'^0[2-9]-?\d{7,8}$';
  static const String usPhone = r'^\(\d{3}\) \d{3}-\d{4}$';
  static const String internationalPhone = r'^\+\d{1,3}-\d{1,4}-\d{4,10}$';

  // Financial patterns
  static const String visa = r'^4\d{15}$';
  static const String mastercard = r'^5[1-5]\d{14}$';
  static const String amex = r'^3[47]\d{13}$';
  static const String iban =
      r'^[A-Z]{2}\d{2}[A-Z0-9]{4}\d{7}([A-Z0-9]?){0,16}$';

  // Product patterns
  static const String sku = r'^[A-Z]{3}-\d{4}-[A-Z0-9]{4}$';
  static const String barcode = r'^\d{8}|\d{12}|\d{13}$';
  static const String isbn = r'^(97[89])?\d{10}$';

  // Network patterns
  static const String ipv4 =
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';
  static const String ipv6 = r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|::)$';
  static const String macAddress = r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$';

  // Web patterns
  static const String email = r'^[\w\.-]+@[\w\.-]+\.\w+$';
  static const String url = r'^https?:\/\/(www\.)?[\w\-]+(\.[\w\-]+)+[/#?]?.*$';
  static const String slug = r'^[a-z0-9]+(?:-[a-z0-9]+)*$';

  // Document patterns
  static const String uuid =
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$';
  static const String hexColor = r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$';
  static const String base64 = r'^[A-Za-z0-9+/]*={0,2}$';

  // Date/Time patterns
  static const String isoDate = r'^\d{4}-\d{2}-\d{2}$';
  static const String isoDateTime =
      r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z?$';
  static const String time24h = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$';

  // Custom patterns
  static const String orderNumber = r'^ORD-\d{4}-\d{6}$';
  static const String invoiceNumber = r'^INV-\d{4}/\d{4}$';
  static const String trackingNumber = r'^[A-Z]{2}\d{9}[A-Z]{2}$';
}
