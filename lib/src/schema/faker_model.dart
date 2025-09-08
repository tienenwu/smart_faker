import '../core/smart_faker.dart';

/// Base class for models that can generate fake data
abstract class FakerModel {
  /// Generates a fake instance of this model
  static T generate<T extends FakerModel>(
    T Function(SmartFaker faker) factory, {
    int? seed,
    String? locale,
  }) {
    final faker = SmartFaker(seed: seed, locale: locale ?? 'en_US');
    return factory(faker);
  }

  /// Generates a list of fake instances
  static List<T> generateList<T extends FakerModel>(
    T Function(SmartFaker faker) factory, {
    required int count,
    int? seed,
    String? locale,
  }) {
    final faker = SmartFaker(seed: seed, locale: locale ?? 'en_US');
    return List.generate(count, (_) => factory(faker));
  }
}

/// Mixin to add fake data generation to any class
mixin FakeDataMixin {
  static final SmartFaker _defaultFaker = SmartFaker();

  /// Gets the default faker instance
  SmartFaker get faker => _defaultFaker;

  /// Creates a new faker with specific seed
  SmartFaker fakerWithSeed(int seed) => SmartFaker(seed: seed);
}

/// Extension to make it easy to generate fake data for any class
extension FakerExtension<T> on T {
  /// Fills this object with fake data using a factory function
  static T fake<T>(T Function(SmartFaker) factory, {int? seed}) {
    final faker = SmartFaker(seed: seed);
    return factory(faker);
  }

  /// Generates a list of fake objects
  static List<T> fakeList<T>(
    T Function(SmartFaker) factory, {
    required int count,
    int? seed,
  }) {
    final faker = SmartFaker(seed: seed);
    return List.generate(count, (_) => factory(faker));
  }
}
