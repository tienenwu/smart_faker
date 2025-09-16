import 'dart:math';

import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating basic data types
class DatatypeModule {
  /// Creates a new datatype module instance
  DatatypeModule(this._random, LocaleManager locale);

  final RandomGenerator _random;

  /// Generate a random UUID
  String uuid() {
    final bytes =
        List<int>.generate(16, (_) => _random.integer(min: 0, max: 255));

    // Set version (4) and variant bits
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20, 32)}';
  }

  /// Generate a random integer
  int number({int min = 0, int max = 100}) {
    return _random.integer(min: min, max: max);
  }

  /// Generate a random double
  double float({double min = 0.0, double max = 100.0, int decimals = 2}) {
    final value = min + (_random.nextDouble() * (max - min));
    final multiplier = pow(10, decimals);
    return (value * multiplier).round() / multiplier;
  }

  /// Generate a random boolean
  bool boolean() {
    return _random.nextBool();
  }

  /// Generate a random hexadecimal string
  String hexadecimal({int length = 8}) {
    const chars = '0123456789abcdef';
    return List.generate(
      length,
      (_) => chars[_random.integer(min: 0, max: 15)],
    ).join();
  }

  /// Generate a random alphanumeric string
  String alphanumeric({int length = 10}) {
    const chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(
      length,
      (_) => chars[_random.integer(min: 0, max: chars.length - 1)],
    ).join();
  }

  /// Pick a random element from a list
  T randomElement<T>(List<T> list) {
    if (list.isEmpty) {
      throw ArgumentError('Cannot pick from empty list');
    }
    return list[_random.integer(min: 0, max: list.length - 1)];
  }

  /// Pick multiple random elements from a list
  List<T> randomElements<T>(List<T> list, {int count = 3}) {
    if (list.isEmpty) {
      throw ArgumentError('Cannot pick from empty list');
    }

    final result = <T>[];
    final indices = <int>{};

    while (result.length < count && indices.length < list.length) {
      final index = _random.integer(min: 0, max: list.length - 1);
      if (!indices.contains(index)) {
        indices.add(index);
        result.add(list[index]);
      }
    }

    return result;
  }
}
