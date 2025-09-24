import '../schema_builder.dart';

/// Configuration for schema importers.
class SchemaImportConfig {
  /// Whether to infer relationships from nested object/array definitions.
  final bool inferRelationships;

  /// Default schema name when the source document does not provide one.
  final String defaultSchemaName;

  /// Optional transformer for schema names.
  final String Function(String name)? nameTransformer;

  /// Default locale hint for generated schemas (not yet used but reserved).
  final String? defaultLocale;

  const SchemaImportConfig({
    this.inferRelationships = true,
    this.defaultSchemaName = 'ImportedSchema',
    this.nameTransformer,
    this.defaultLocale,
  });

  /// Applies the configured [nameTransformer] to the provided [rawName].
  String transformName(String rawName) {
    if (nameTransformer != null) {
      return nameTransformer!(rawName);
    }
    return rawName;
  }
}

/// Result returned by schema importers.
class SchemaImportResult {
  /// All schemas discovered in the source document.
  final List<Schema> schemas;

  /// Warnings collected during parsing (e.g. unsupported keywords).
  final List<String> warnings;

  const SchemaImportResult({
    required this.schemas,
    this.warnings = const [],
  });

  /// Whether any warnings were emitted during import.
  bool get hasWarnings => warnings.isNotEmpty;
}

/// Base class for schema importers.
abstract class SchemaImporter {
  /// Imports schemas from the provided source.
  SchemaImportResult importSchemas();
}
