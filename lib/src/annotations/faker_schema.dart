import 'package:meta/meta.dart';

/// Annotation to mark a class as a faker schema.
@immutable
class FakerSchema {
  /// The name of the schema.
  final String? name;

  /// Whether to generate timestamps (createdAt, updatedAt).
  final bool timestamps;

  /// Custom seed for this schema.
  final int? seed;

  /// Locale for this schema.
  final String? locale;

  const FakerSchema({
    this.name,
    this.timestamps = false,
    this.seed,
    this.locale,
  });
}
