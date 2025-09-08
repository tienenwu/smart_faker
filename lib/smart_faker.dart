/// SmartFaker - An intelligent test data generator for Flutter/Dart
///
/// SmartFaker provides comprehensive test data generation with features like:
/// - Schema-based generation
/// - Smart relationships between data
/// - Comprehensive internationalization (10+ languages)
/// - Type-safe API
/// - Reproducible results with seeding
///
/// Example usage:
/// ```dart
/// import 'package:smart_faker/smart_faker.dart';
///
/// final faker = SmartFaker();
/// final name = faker.person.fullName();
/// final email = faker.internet.email();
/// ```
library smart_faker;

// Core exports
export 'src/core/smart_faker.dart';
export 'src/core/faker_config.dart';
export 'src/core/random_generator.dart';
export 'src/core/locale_manager.dart';

// Module exports
export 'src/modules/person_module.dart';
export 'src/modules/internet_module.dart';
export 'src/modules/location_module.dart';
export 'src/modules/datetime_module.dart';
export 'src/modules/commerce_module.dart';
export 'src/modules/company_module.dart';
export 'src/modules/finance_module.dart';
export 'src/modules/vehicle_module.dart';
export 'src/modules/lorem_module.dart';
export 'src/modules/system_module.dart';
export 'src/modules/image_module.dart';
export 'src/modules/phone_module.dart';
export 'src/modules/color_module.dart';
export 'src/modules/crypto_module.dart';
export 'src/modules/food_module.dart';
export 'src/modules/music_module.dart';
export 'src/modules/export_module.dart';
export 'src/modules/taiwan_module.dart';
export 'src/modules/social_media_module.dart';
export 'src/modules/ecommerce_module.dart';
export 'src/modules/healthcare_module.dart';
export 'src/modules/pattern_module.dart';

// Model exports
export 'src/modules/models/coordinates.dart';

// Annotation exports (for schema-based generation)
export 'src/annotations/faker_schema.dart';
export 'src/annotations/faker_field.dart';

// Schema exports
export 'src/schema/schema_builder.dart';
export 'src/schema/faker_model.dart';
export 'src/schema/relationship_manager.dart';
