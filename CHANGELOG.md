# Changelog

## [0.5.0] - 2025-09-24

### Added
- **Schema Importers**: JSON Schema, OpenAPI, and Prisma importers with schema auto-naming and presets
- **smart_faker CLI**: `generate`, `mock`, and `build` commands for fixture generation and mock server control
- **Mock Server Enhancements**: GraphQL resolvers, SSE/WebSocket support, and request recording/replay APIs
- **Privacy Module**: Masking, PII detection, numeric synthesizer, and k-anonymity helpers
- **Demo & Docs**: Updated demo screens, multilingual READMEs, and API_MOCKING guide for new capabilities

### Changed
- Updated documentation and examples to highlight CLI usage and advanced streaming features
- Refreshed README cards and demo app labels to reflect v0.5.0 feature set

### Fixed
- Corrected JSON Schema importer naming for root-level schemas and improved tests for CLI import workflows

## [0.4.0] - 2025-09-16

### Added
- **API Mocking Feature**: Built-in mock server for testing API integrations
  - MockServer class with HTTP server using Shelf package
  - Support for GET/POST/PUT/DELETE/PATCH methods
  - Path parameters support (e.g., `/users/<id>`)
  - Stateful operations with in-memory storage
  - Network simulation with configurable delays and error rates
  - CORS support for cross-origin requests
- **Response Generator**: Template-based dynamic response generation
  - Faker directives support (`@uuid`, `@person.fullName`, etc.)
  - Array generation with `@array:N` directive
  - Nested object support
  - Conditional responses based on request
- **Datatype Module**: New module for basic data types
  - UUID generation
  - Number, float, boolean generation
  - Hexadecimal and alphanumeric strings
  - Random element selection from lists
- **Method Aliases**: Added convenience aliases for common methods
  - `phoneNumber()` for phone module
  - `email()`, `phone()`, `bio()` for person module
  - `hexColor()` for color module
  - `companyName()`, `companySuffix()`, `catchPhrase()` for company module
  - `birthdate()` for datetime module
  - `imageUrl()`, `avatarUrl()` for image module
- **Module Aliases**: Added commonly used module aliases
  - `date` as alias for `dateTime` module
  - `address` as alias for `location` module

### Changed
- Updated dependencies to include shelf and shelf_router for API mocking
- Enhanced documentation with API_MOCKING.md guide
- Improved example directory with api_mocking_example.dart

### Fixed
- Fixed missing method implementations in various modules
- Corrected method signatures for lorem module methods

## [0.3.5] - 2025-09-11

### Added
- Buy Me a Coffee support button in README files (all languages)

### Changed
- Updated documentation with support information

## [0.3.4] - 2025-09-09

### Changed
- **Dependency Updates**: Updated `intl` from `^0.17.0` to `^0.18.1` for improved pub.dev score
- **Maintained Compatibility**: Kept `meta` at `^1.7.0` to ensure Flutter SDK compatibility

### Fixed
- **pub.dev Score**: Improved dependency compliance for better package health score

## [0.3.3] - 2025-09-09

### Changed
- **Improved Compatibility**: Lowered Dart SDK requirement from `^3.5.0` to `>=2.17.0 <4.0.0`
- **Flutter 3.0.0 Support**: Now compatible with Flutter 3.0.0 and newer versions
- **Dependency Updates**: Adjusted all dependencies to work with older Flutter/Dart versions

### Fixed
- Updated `meta` package to `^1.7.0` for Flutter 3.0.0 compatibility
- Updated `intl` package to `^0.17.0` for wider compatibility
- Fixed crypto package compatibility issues
- Resolved dev dependency version conflicts
- Fixed null safety issues in example code

### Added
- New standalone demo (`example/demo_standalone.dart`) showcasing all features
- Comprehensive compatibility testing with Flutter 3.0.0
- Updated installation guide for broader Flutter version support

## [0.3.2] - 2025-09-08

### Fixed
- Excluded demo app and build artifacts from package publication
- Reduced package size from 2MB to 148KB
- Added .pubignore file to properly exclude development files

## [0.3.1] - 2025-09-08

### Fixed
- Fixed static analysis issue: Added missing braces to if statement in export module
- Improved code formatting and linter compliance
- Enhanced pub.dev score from 40/50 to near perfect

## [0.3.0] - 2025-09-08

### Added
- **Pattern Module**: Generate data from regex patterns
  - Custom regex pattern parser and generator
  - Support for character classes, quantifiers, alternation
  - 17+ preset patterns for common formats (phone, ID, credit card, etc.)
  - Taiwan-specific patterns (ID, phone, invoice)
  - Network patterns (IPv4, MAC address)
  - Product patterns (SKU, barcode, tracking numbers)
  
- **Schema Validation**: Field-level validation with regex patterns
  - Custom validators for schema fields
  - Regex pattern validation support
  - Built-in validators (email, phone, URL, credit card, UUID, etc.)
  - Validator combinators (combine, range, length, inList)
  - Custom error messages for validation failures
  - Pattern-based field generation with validation
  
- **Field Validators**: Comprehensive validation utilities
  - FieldValidators class with 15+ built-in validators
  - FieldPatterns class with 30+ common regex patterns
  - Support for custom validator functions
  - Validation with retry mechanism

### Enhanced
- SchemaBuilder now supports pattern and validator properties
- Improved type safety with validation constraints
- Better error handling for invalid patterns

## [0.2.0] - 2025-09-08

### Added
- **Export Module**: Export generated data to multiple formats
  - CSV export with customizable headers and delimiters
  - JSON export with pretty printing option
  - SQL INSERT statement generation
  - TSV (Tab-Separated Values) export
  - Markdown table format
  - XML export with configurable elements
  - YAML export with proper formatting
  - Stream support for large datasets (memory efficient)
  
- **Taiwan Module**: Comprehensive Taiwan-specific data generation
  - Taiwan ID number (身分證字號) with valid checksum
  - Company tax ID (統一編號) with proper validation
  - Landline phone numbers with area codes
  - Postal codes (3 and 5 digit formats)
  - Vehicle license plates (car, motorcycle, electric)
  - Bank account numbers with real bank codes
  - Health insurance card numbers
  - Enhanced phone number prefixes for Taiwan carriers

### Enhanced
- Improved zh_TW locale with more realistic data
- Better Taiwan phone number generation with actual carrier prefixes
- More comprehensive Taiwan location data

## [0.1.3] - 2025-09-08

### Fixed
- Removed redundant default clause in switch statement
- Fixed code formatting issues
- Achieved perfect 160/160 pub.dev score

## [0.1.2] - 2025-09-08

### Improved
- Updated `intl` dependency to ^0.20.0 for better compatibility
- Added missing dartdoc comments to achieve 100% API documentation coverage
  - Added documentation for `Coordinates.latitude` and `Coordinates.longitude`
  - Added documentation for all `FieldDefinition` properties
- Enhanced pub.dev score to 160/160 points

## [0.1.1] - 2025-09-08

### Added
- **Image Module Enhancement**: New `localAvatar()` method for generating SVG avatars
  - Customizable shapes (circle/square)
  - Random vibrant background colors with automatic contrast text
  - Standard avatar sizes (48, 64, 128, 256, 512px)
  - Support for custom names or random initials
  - Base64 encoded SVG data URIs for direct embedding

## [0.1.0] - 2025-09-08

### Added
- Initial release with 11 comprehensive data generation modules:
  - **PersonModule**: Names, ages, job titles, genders
  - **InternetModule**: Emails, URLs, usernames, passwords, IP addresses
  - **LocationModule**: Addresses, cities, countries, coordinates, timezones
  - **DateTimeModule**: Past/future dates, times, timestamps, date ranges
  - **CommerceModule**: Products, prices, departments, colors, materials
  - **CompanyModule**: Company names, catch phrases, mission statements
  - **FinanceModule**: Credit cards, bank accounts, cryptocurrencies, transactions
  - **VehicleModule**: Vehicle manufacturers, models, VINs, license plates
  - **LoremModule**: Multi-language text generation (Lorem ipsum, Chinese, Japanese)
  - **SystemModule**: File paths, versions, processes, environment variables
  - **ImageModule**: Image URLs, placeholders, colors (hex, RGB, HSL)

### Features
- Multi-locale support (en_US, zh_TW, ja_JP)
- Seeded random generation for reproducible results
- Type-safe API with null safety
- Comprehensive test coverage (250+ tests)
- Interactive demo application showcasing all modules
- Smart context-aware data generation
- Lightweight with zero external dependencies

### Developer Experience
- Well-documented API with inline documentation
- Modular architecture for easy extension
- Consistent API across all modules
- Example usage for every generator method
