import 'package:meta/meta.dart';

/// Annotation to mark a field for fake data generation.
@immutable
class FakerField {
  /// The type of fake data to generate.
  final FakerFieldType type;

  /// Custom options for the field.
  final Map<String, dynamic> options;

  /// Whether this field is required.
  final bool required;

  /// Minimum value (for numbers, dates, strings length).
  final dynamic min;

  /// Maximum value (for numbers, dates, strings length).
  final dynamic max;

  /// Pattern for string generation.
  final String? pattern;

  /// Custom generator function name.
  final String? generator;

  /// Reference to another field for relationships.
  final String? reference;

  const FakerField({
    this.type = FakerFieldType.auto,
    this.options = const {},
    this.required = true,
    this.min,
    this.max,
    this.pattern,
    this.generator,
    this.reference,
  });
}

/// Types of faker fields.
enum FakerFieldType {
  /// Automatically detect type based on field type.
  auto,

  // Person
  firstName,
  lastName,
  fullName,
  email,
  username,
  password,
  phone,
  avatar,
  jobTitle,

  // Location
  address,
  city,
  country,
  zipCode,
  latitude,
  longitude,

  // DateTime
  date,
  time,
  dateTime,
  timestamp,

  // Commerce
  productName,
  price,
  sku,
  barcode,

  // Company
  companyName,
  industry,
  catchPhrase,

  // Finance
  creditCard,
  iban,
  currency,
  amount,
  bitcoinAddress,

  // Internet
  url,
  ipAddress,
  macAddress,
  userAgent,

  // Lorem
  word,
  sentence,
  paragraph,
  text,

  // Numbers
  integer,
  double,
  boolean,

  // Custom
  uuid,
  json,
  list,
  map,
  custom,
}
