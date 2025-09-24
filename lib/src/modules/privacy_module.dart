import 'dart:math' as math;

import '../core/locale_manager.dart';
import '../core/random_generator.dart';

class PrivacyModule {
  PrivacyModule(this._random, this._localeManager);

  final RandomGenerator _random;
  final LocaleManager _localeManager;
  double? _cachedGaussian;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRegex =
      RegExp(r'^(?:\+?\d{1,3}[ -]?)?(?:\d{2,4}[ -]?){2,4}\d{2,4}$');
  static final RegExp _creditCardRegex = RegExp(r'^(?:\d[ -]?){13,19}$');
  static final RegExp _ssnRegex = RegExp(r'^\d{3}-\d{2}-\d{4}$');
  static final RegExp _ipv4Regex = RegExp(r'^(?:\d{1,3}\.){3}\d{1,3}$');

  String maskValue(
    String value, {
    int visibleStart = 2,
    int visibleEnd = 2,
    String mask = '*',
  }) {
    if (value.isEmpty) return value;
    final start = value.substring(0, math.min(visibleStart, value.length));
    final end =
        value.substring(math.max(0, value.length - visibleEnd), value.length);
    final maskedLength = math.max(0, value.length - start.length - end.length);
    return start + mask * maskedLength + end;
  }

  String maskEmail(String email, {int visibleStart = 1}) {
    final parts = email.split('@');
    if (parts.length != 2) {
      return maskValue(email, visibleStart: visibleStart, visibleEnd: 2);
    }
    final localPart = parts.first;
    final domain = parts.last;
    final maskedLocal = maskValue(localPart,
        visibleStart: visibleStart, visibleEnd: 1, mask: '*');
    return '$maskedLocal@$domain';
  }

  String maskPhone(String phone, {int visibleDigits = 4}) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return phone;
    }
    final masked = maskValue(
      digits,
      visibleStart:
          digits.length > visibleDigits ? digits.length - visibleDigits : 0,
      visibleEnd: visibleDigits,
    );
    return masked
        .replaceAllMapped(RegExp(r'.{3}'), (match) => '${match.group(0)} ')
        .trim();
  }

  Map<String, dynamic> deidentifyRecord(
    Map<String, dynamic> record, {
    Iterable<String>? fields,
  }) {
    final result = Map<String, dynamic>.from(record);
    final targetFields = fields?.toSet() ?? detectPiiFields(record);
    for (final field in targetFields) {
      final value = record[field];
      if (value is String) {
        if (_emailRegex.hasMatch(value)) {
          result[field] = maskEmail(value);
        } else if (_phoneRegex.hasMatch(value)) {
          result[field] = maskPhone(value);
        } else if (_creditCardRegex.hasMatch(value)) {
          result[field] = maskValue(value, visibleStart: 0, visibleEnd: 4);
        } else if (_ssnRegex.hasMatch(value)) {
          result[field] = '***-**-${value.substring(value.length - 4)}';
        } else {
          result[field] = maskValue(value, visibleStart: 1, visibleEnd: 1);
        }
      }
    }
    return result;
  }

  Set<String> detectPiiFields(Map<String, dynamic> record) {
    final result = <String>{};
    final locale = _localeManager.currentLocale;
    final isChinese = locale.startsWith('zh');
    final isJapanese = locale.startsWith('ja');
    record.forEach((key, value) {
      if (value is! String) return;
      final lowerKey = key.toLowerCase();
      if (lowerKey.contains('email') || _emailRegex.hasMatch(value)) {
        result.add(key);
      } else if (lowerKey.contains('phone') ||
          lowerKey.contains('mobile') ||
          _phoneRegex.hasMatch(value)) {
        result.add(key);
      } else if (lowerKey.contains('ssn') || _ssnRegex.hasMatch(value)) {
        result.add(key);
      } else if (lowerKey.contains('card') ||
          _creditCardRegex.hasMatch(value)) {
        result.add(key);
      } else if (lowerKey.contains('ip') || _ipv4Regex.hasMatch(value)) {
        result.add(key);
      } else if (lowerKey.contains('name')) {
        result.add(key);
      } else if (isChinese &&
          (key.contains('姓名') || key.contains('電話') || key.contains('電郵'))) {
        result.add(key);
      } else if (isJapanese &&
          (key.contains('氏名') || key.contains('電話') || key.contains('メール'))) {
        result.add(key);
      }
    });
    return result;
  }

  List<double> synthesizeNumeric(
    List<num> sample, {
    int count = 1,
  }) {
    if (sample.isEmpty) {
      return const [];
    }
    if (sample.length == 1) {
      return List<double>.filled(count, sample.first.toDouble());
    }

    final mean = sample.reduce((a, b) => a + b) / sample.length;
    final variance = sample
            .map((value) => math.pow(value - mean, 2))
            .reduce((a, b) => a + b) /
        sample.length;
    final stdDev = math.sqrt(variance.toDouble());

    final results = <double>[];
    for (int i = 0; i < count; i++) {
      final gaussian = _nextGaussian();
      results.add(mean + gaussian * stdDev);
    }
    return results;
  }

  bool satisfiesKAnonymity(
    List<Map<String, dynamic>> dataset,
    List<String> quasiIdentifiers,
    int k,
  ) {
    if (quasiIdentifiers.isEmpty) {
      return true;
    }

    final counts = <String, int>{};
    for (final record in dataset) {
      final key = quasiIdentifiers
          .map((field) => record[field]?.toString() ?? '')
          .join('|');
      counts.update(key, (value) => value + 1, ifAbsent: () => 1);
    }

    return counts.values.every((count) => count >= k);
  }

  List<Map<String, dynamic>> synthesizeDataset(
    List<Map<String, dynamic>> dataset, {
    int? count,
  }) {
    if (dataset.isEmpty) {
      return const [];
    }
    final targetCount = count ?? dataset.length;
    final fieldValues = <String, List<dynamic>>{};
    for (final record in dataset) {
      record.forEach((key, value) {
        fieldValues.putIfAbsent(key, () => <dynamic>[]).add(value);
      });
    }

    final numericFields = fieldValues.entries
        .where((entry) => entry.value.every((element) => element is num))
        .map((entry) => entry.key)
        .toSet();

    final synthesized = <Map<String, dynamic>>[];
    for (int i = 0; i < targetCount; i++) {
      final record = <String, dynamic>{};
      fieldValues.forEach((key, values) {
        if (numericFields.contains(key)) {
          final numericValues = values.cast<num>();
          record[key] = synthesizeNumeric(numericValues, count: 1).first;
        } else {
          record[key] = _random.element(values);
        }
      });
      synthesized.add(record);
    }
    return synthesized;
  }

  double _nextGaussian() {
    if (_cachedGaussian != null) {
      final value = _cachedGaussian!;
      _cachedGaussian = null;
      return value;
    }

    double u1;
    double u2;
    do {
      u1 = _random.nextDouble();
      u2 = _random.nextDouble();
    } while (u1 <= double.minPositive);

    final mag = math.sqrt(-2.0 * math.log(u1));
    final z0 = mag * math.cos(2 * math.pi * u2);
    final z1 = mag * math.sin(2 * math.pi * u2);
    _cachedGaussian = z1;
    return z0;
  }
}
