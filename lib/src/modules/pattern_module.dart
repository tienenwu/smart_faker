import '../core/random_generator.dart';
import '../core/locale_manager.dart';

/// Module for generating data from regular expression patterns.
///
/// This module allows generating strings that match specific regex patterns,
/// useful for creating data that must pass validation rules.
///
/// Example:
/// ```dart
/// final faker = SmartFaker();
/// // Generate Taiwan phone number
/// final phone = faker.pattern.fromRegex(r'^09\d{8}$');
/// // Generate order ID
/// final orderId = faker.pattern.fromRegex(r'^ORD-2024\d{6}$');
/// ```
class PatternModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Maximum attempts to generate a valid pattern
  static const int maxAttempts = 1000;

  /// Maximum depth for nested groups
  static const int maxDepth = 10;

  /// Creates a new instance of [PatternModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of pattern data.
  PatternModule(this.random, this.localeManager);

  /// Generates a string from a regular expression pattern.
  ///
  /// Supports basic regex features:
  /// - Character classes: [a-z], [A-Z], [0-9], \d, \w, \s
  /// - Quantifiers: {n}, {n,m}, +, *, ?
  /// - Anchors: ^, $
  /// - Groups: (...)
  /// - Alternation: |
  /// - Escape sequences: \., \[, etc.
  ///
  /// [pattern] The regex pattern to generate from
  /// [experimental] Whether this is experimental (shows warning)
  /// Returns a string matching the pattern
  String fromRegex(String pattern, {bool experimental = true}) {
    if (experimental) {
      // In production, this would log a warning
    }

    try {
      // Remove anchors as they don't affect generation
      String cleanPattern = pattern;
      if (cleanPattern.startsWith('^')) {
        cleanPattern = cleanPattern.substring(1);
      }
      if (cleanPattern.endsWith(r'$')) {
        cleanPattern = cleanPattern.substring(0, cleanPattern.length - 1);
      }

      return _generateFromPattern(cleanPattern, 0);
    } catch (e) {
      throw FormatException('Failed to generate from pattern: $pattern', e);
    }
  }

  /// Internal method to generate string from pattern
  String _generateFromPattern(String pattern, int depth) {
    if (depth > maxDepth) {
      throw FormatException('Pattern too complex (max depth exceeded)');
    }

    // First check for alternation at this level
    if (pattern.contains('|')) {
      // Split by alternation, but respect groups
      final alternatives = _splitAlternatives(pattern);
      if (alternatives.length > 1) {
        final choice = random.element(alternatives);
        return _generateFromPattern(choice, depth);
      }
    }

    final result = StringBuffer();
    int i = 0;

    while (i < pattern.length) {
      final char = pattern[i];

      if (char == '\\') {
        // Handle escape sequences
        if (i + 1 < pattern.length) {
          final next = pattern[i + 1];
          String escapeResult = _handleEscapeSequence(next);

          // Check for quantifier after escape sequence
          if (i + 2 < pattern.length && '{?*+'.contains(pattern[i + 2])) {
            escapeResult = _applyQuantifier(escapeResult, pattern, i + 2);
            i = _skipQuantifier(pattern, i + 2) + 1;
          } else {
            i += 2;
          }
          result.write(escapeResult);
        } else {
          throw FormatException('Invalid escape sequence at end of pattern');
        }
      } else if (char == '[') {
        // Handle character class
        final endIndex = pattern.indexOf(']', i);
        if (endIndex == -1) {
          throw FormatException('Unclosed character class');
        }
        final charClass = pattern.substring(i + 1, endIndex);
        String charResult = _generateFromCharClass(charClass);

        // Check for quantifier after character class
        if (endIndex + 1 < pattern.length &&
            '{?*+'.contains(pattern[endIndex + 1])) {
          charResult = _applyQuantifier(charResult, pattern, endIndex + 1);
          i = _skipQuantifier(pattern, endIndex + 1) + 1;
        } else {
          i = endIndex + 1;
        }
        result.write(charResult);
      } else if (char == '(') {
        // Handle groups (simplified - just process content)
        int groupEnd = _findGroupEnd(pattern, i);
        final groupContent = pattern.substring(i + 1, groupEnd);

        // Check for quantifier after group
        String groupResult = _generateFromPattern(groupContent, depth + 1);
        if (groupEnd + 1 < pattern.length) {
          final nextChar = pattern[groupEnd + 1];
          if ('{?*+'.contains(nextChar)) {
            groupResult = _applyQuantifier(groupResult, pattern, groupEnd + 1);
            i = _skipQuantifier(pattern, groupEnd + 1) + 1;
          } else {
            i = groupEnd + 1;
          }
        } else {
          i = groupEnd + 1;
        }
        result.write(groupResult);
      } else if ('{'.contains(char)) {
        // Handle quantifier without preceding element (error case)
        throw FormatException('Quantifier without preceding element');
      } else if (i + 1 < pattern.length && '{?*+'.contains(pattern[i + 1])) {
        // Handle quantifiers
        final quantified = _applyQuantifier(char, pattern, i + 1);
        result.write(quantified);
        i = _skipQuantifier(pattern, i + 1) + 1;
      } else {
        // Literal character
        result.write(char);
        i++;
      }
    }

    return result.toString();
  }

  /// Handle escape sequences like \d, \w, \s
  String _handleEscapeSequence(String escape) {
    switch (escape) {
      case 'd':
        return random.integer(min: 0, max: 9).toString();
      case 'D':
        return random.element(
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''));
      case 'w':
        return random.element(
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
                .split(''));
      case 'W':
        return random.element('!@#\$%^&*()+-=[]{}|;:,.<>?/~'.split(''));
      case 's':
        return random.element([' ', '\t']);
      case 'S':
        return random.element(
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
                .split(''));
      case 'n':
        return '\n';
      case 't':
        return '\t';
      case 'r':
        return '\r';
      default:
        // Literal escape (like \. or \[)
        return escape;
    }
  }

  /// Generate from character class like [a-z] or [0-9]
  String _generateFromCharClass(String charClass) {
    final chars = <String>[];
    int i = 0;

    while (i < charClass.length) {
      if (i + 2 < charClass.length && charClass[i + 1] == '-') {
        // Range like a-z
        final start = charClass.codeUnitAt(i);
        final end = charClass.codeUnitAt(i + 2);
        for (int code = start; code <= end; code++) {
          chars.add(String.fromCharCode(code));
        }
        i += 3;
      } else {
        // Single character
        chars.add(charClass[i]);
        i++;
      }
    }

    if (chars.isEmpty) {
      throw FormatException('Empty character class');
    }

    return random.element(chars);
  }

  /// Apply quantifier to a string
  String _applyQuantifier(String base, String pattern, int quantifierIndex) {
    final quantifier = pattern[quantifierIndex];

    switch (quantifier) {
      case '?':
        return random.boolean(probability: 0.5) ? base : '';
      case '*':
        final count = random.integer(min: 0, max: 5);
        return base * count;
      case '+':
        final count = random.integer(min: 1, max: 5);
        return base * count;
      case '{':
        // Handle {n} or {n,m}
        final endIndex = pattern.indexOf('}', quantifierIndex);
        if (endIndex == -1) {
          throw FormatException('Unclosed quantifier');
        }
        final quantifierContent =
            pattern.substring(quantifierIndex + 1, endIndex);

        if (quantifierContent.contains(',')) {
          // {n,m} format
          final parts = quantifierContent.split(',');
          final min = int.tryParse(parts[0].trim()) ?? 0;
          final max = parts.length > 1 && parts[1].trim().isNotEmpty
              ? int.tryParse(parts[1].trim()) ?? min
              : min + 5; // Default max if not specified
          final count = random.integer(min: min, max: max);
          return base * count;
        } else {
          // {n} format
          final count = int.tryParse(quantifierContent) ?? 1;
          return base * count;
        }
      default:
        return base;
    }
  }

  /// Skip past a quantifier in the pattern
  int _skipQuantifier(String pattern, int start) {
    if (start >= pattern.length) return start;

    final char = pattern[start];
    if (char == '{') {
      final endIndex = pattern.indexOf('}', start);
      return endIndex != -1 ? endIndex : start;
    }
    return start;
  }

  /// Find the end of a group
  int _findGroupEnd(String pattern, int start) {
    int depth = 1;
    int i = start + 1;

    while (i < pattern.length && depth > 0) {
      if (pattern[i] == '\\') {
        i += 2; // Skip escape sequence
        continue;
      }
      if (pattern[i] == '(') depth++;
      if (pattern[i] == ')') depth--;
      i++;
    }

    if (depth != 0) {
      throw FormatException('Unclosed group');
    }

    return i - 1;
  }

  /// Split pattern by alternation, respecting groups
  List<String> _splitAlternatives(String pattern) {
    final alternatives = <String>[];
    final current = StringBuffer();
    int depth = 0;
    int i = 0;

    while (i < pattern.length) {
      if (pattern[i] == '\\') {
        // Add escape sequence
        current.write(pattern[i]);
        if (i + 1 < pattern.length) {
          current.write(pattern[i + 1]);
          i += 2;
        } else {
          i++;
        }
      } else if (pattern[i] == '(') {
        depth++;
        current.write(pattern[i]);
        i++;
      } else if (pattern[i] == ')') {
        depth--;
        current.write(pattern[i]);
        i++;
      } else if (pattern[i] == '|' && depth == 0) {
        // Found alternation at top level
        alternatives.add(current.toString());
        current.clear();
        i++;
      } else {
        current.write(pattern[i]);
        i++;
      }
    }

    // Add the last alternative
    if (current.isNotEmpty) {
      alternatives.add(current.toString());
    }

    return alternatives;
  }

  // === Preset Patterns for Common Use Cases ===

  /// Generates a Taiwan phone number
  String taiwanPhone() {
    return fromRegex(r'^09\d{2}-\d{3}-\d{3}$', experimental: false);
  }

  /// Generates a Taiwan ID number format (without checksum validation)
  String taiwanIdFormat() {
    return fromRegex(r'^[A-Z][12]\d{8}$', experimental: false);
  }

  /// Generates a US phone number
  String usPhone() {
    return fromRegex(r'^\(\d{3}\) \d{3}-\d{4}$', experimental: false);
  }

  /// Generates a Japan phone number
  String japanPhone() {
    return fromRegex(r'^0[789]0-\d{4}-\d{4}$', experimental: false);
  }

  /// Generates an email format
  String emailFormat() {
    return fromRegex(r'^[a-z]{3,10}\.[a-z]{3,10}@[a-z]{5,10}\.com$',
        experimental: false);
  }

  /// Generates a credit card format (Visa)
  String visaFormat() {
    return fromRegex(r'^4\d{3} \d{4} \d{4} \d{4}$', experimental: false);
  }

  /// Generates a credit card format (Mastercard)
  String mastercardFormat() {
    return fromRegex(r'^5[1-5]\d{2} \d{4} \d{4} \d{4}$', experimental: false);
  }

  /// Generates an order ID format
  String orderIdFormat({String prefix = 'ORD'}) {
    return fromRegex('^$prefix-\\d{10}\$', experimental: false);
  }

  /// Generates a SKU format
  String skuFormat() {
    return fromRegex(r'^[A-Z]{3}-\d{6}$', experimental: false);
  }

  /// Generates a tracking number format (simplified)
  String trackingNumberFormat() {
    return fromRegex(r'^[A-Z]{2}\d{10}[A-Z]{2}$', experimental: false);
  }

  /// Generates an invoice number format
  String invoiceFormat({int year = 2024}) {
    return fromRegex('^INV-$year\\d{6}\$', experimental: false);
  }

  /// Generates a license plate format (Taiwan new format)
  String licensePlateFormat() {
    return fromRegex(r'^[A-Z]{3}-\d{4}$', experimental: false);
  }

  /// Generates an IPv4 address format
  String ipv4Format() {
    // Simplified - generates valid looking IPs
    final octets = List.generate(4, (_) => random.integer(min: 1, max: 254));
    return octets.join('.');
  }

  /// Generates a MAC address format
  String macAddressFormat() {
    return fromRegex(
        r'^[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}$',
        experimental: false);
  }

  /// Generates a hex color code
  String hexColorFormat() {
    return fromRegex(r'^#[0-9A-F]{6}$', experimental: false);
  }

  /// Generates a UUID v4 format
  String uuidFormat() {
    return fromRegex(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        experimental: false);
  }
}
