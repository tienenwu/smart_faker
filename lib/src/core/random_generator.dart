import 'dart:math';

/// A random number generator with seed support for reproducible results.
class RandomGenerator {
  /// Creates a new random generator.
  /// 
  /// [seed] - Optional seed for reproducible random generation.
  RandomGenerator({int? seed}) {
    if (seed != null) {
      _random = Random(seed);
      _seed = seed;
    } else {
      _random = Random();
      _seed = null;
    }
  }

  late Random _random;
  int? _seed;

  /// Gets the current seed value.
  int? get currentSeed => _seed;

  /// Sets a new seed for reproducible generation.
  void seed(int seed) {
    _seed = seed;
    _random = Random(seed);
  }

  /// Resets to non-seeded random generation.
  void reset() {
    _seed = null;
    _random = Random();
  }

  /// Generates a random integer between [min] and [max] (inclusive).
  int integer({int min = 0, required int max}) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Generates a random double between [min] and [max].
  double decimal({double min = 0.0, double max = 1.0}) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Generates a random boolean value.
  bool boolean({double probability = 0.5}) {
    return _random.nextDouble() < probability;
  }

  /// Picks a random element from a list.
  T element<T>(List<T> list) {
    if (list.isEmpty) {
      throw ArgumentError('Cannot pick from an empty list');
    }
    return list[_random.nextInt(list.length)];
  }

  /// Picks multiple random elements from a list.
  List<T> elements<T>(List<T> list, {required int count}) {
    if (count > list.length) {
      throw ArgumentError('Count cannot be greater than list length');
    }
    
    final shuffled = List<T>.from(list)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  /// Picks a random element based on weights.
  T weightedElement<T>(Map<T, int> weightedMap) {
    if (weightedMap.isEmpty) {
      throw ArgumentError('Cannot pick from an empty map');
    }

    final total = weightedMap.values.reduce((a, b) => a + b);
    var randomValue = _random.nextInt(total);

    for (final entry in weightedMap.entries) {
      randomValue -= entry.value;
      if (randomValue < 0) {
        return entry.key;
      }
    }

    return weightedMap.keys.first;
  }

  /// Shuffles a list in-place and returns it.
  List<T> shuffle<T>(List<T> list) {
    final result = List<T>.from(list);
    result.shuffle(_random);
    return result;
  }

  /// Generates a random string of specified length.
  String string({
    int length = 10,
    String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
  }) {
    return List.generate(
      length,
      (_) => chars[_random.nextInt(chars.length)],
    ).join();
  }

  /// Generates a random UUID v4.
  String uuid() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    
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

  /// Generates a random hex color string.
  String hexColor({bool includeHash = true}) {
    final color = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return includeHash ? '#$color' : color;
  }

  /// Generates a random boolean value (alias for boolean method).
  bool nextBool() {
    return boolean();
  }

  /// Generates a random double between 0.0 and 1.0 (alias for decimal with defaults).
  double nextDouble() {
    return _random.nextDouble();
  }

  /// Generates a random integer between 0 and max (exclusive).
  int nextInt(int max) {
    return _random.nextInt(max);
  }

  /// Gets the underlying Random instance.
  Random get random => _random;

  /// Generates a random hex string of the specified length.
  String hexString({required int length}) {
    const chars = '0123456789abcdef';
    return List.generate(length, (_) => chars[_random.nextInt(16)]).join();
  }
}