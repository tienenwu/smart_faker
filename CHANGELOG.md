# Changelog

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