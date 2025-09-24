import 'json_schema_importer.dart';
import 'schema_importer.dart';

/// Imports schemas from OpenAPI v3 documents by delegating to
/// [JsonSchemaImporter].
class OpenApiSchemaImporter {
  OpenApiSchemaImporter({SchemaImportConfig? config})
      : _jsonImporter = JsonSchemaImporter(config: config);

  final JsonSchemaImporter _jsonImporter;

  SchemaImportResult importFromDocument(
    Map<String, dynamic> document, {
    Iterable<String>? componentNames,
  }) {
    final components = (document['components'] as Map<String, dynamic>?) ?? {};
    final schemas =
        (components['schemas'] as Map<String, dynamic>?) ?? const {};

    final clonedDocument = <String, dynamic>{
      'components': {
        'schemas': schemas,
      },
    };

    return _jsonImporter.importFromDocument(
      clonedDocument,
      schemaNames: componentNames,
    );
  }
}
