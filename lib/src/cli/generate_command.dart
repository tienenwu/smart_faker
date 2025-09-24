import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:smart_faker/smart_faker.dart';
import 'package:yaml/yaml.dart';

class GenerateCommand extends Command<int> {
  GenerateCommand() {
    argParser
      ..addOption(
        'schema-file',
        abbr: 'f',
        valueHelp: 'path',
        help: 'Path to a JSON Schema, OpenAPI, or Prisma schema file.',
      )
      ..addOption(
        'type',
        help: 'Schema format (auto-detected by extension when omitted).',
        allowed: ['json-schema', 'openapi', 'prisma'],
      )
      ..addOption(
        'schema',
        abbr: 's',
        valueHelp: 'name',
        help: 'Name of the schema to generate (defaults to first discovered).',
      )
      ..addOption(
        'locale',
        defaultsTo: 'en_US',
        help: 'Locale to use for generated data.',
      )
      ..addOption(
        'count',
        abbr: 'c',
        defaultsTo: '1',
        help: 'Number of records to generate.',
      )
      ..addOption(
        'format',
        defaultsTo: 'pretty',
        allowed: ['json', 'pretty'],
        help: 'Output format.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Write the generated payload to the given file path.',
      )
      ..addFlag(
        'list-schemas',
        negatable: false,
        help: 'List discovered schemas without generating data.',
      );
  }

  @override
  String get description => 'Generate fake data from schema files.';

  @override
  String get name => 'generate';

  @override
  Future<int> run() async {
    final schemaFile = argResults?['schema-file'] as String?;
    if (schemaFile == null) {
      usageException('Missing required option: --schema-file');
    }

    final file = File(schemaFile);
    if (!file.existsSync()) {
      usageException('Schema file not found: $schemaFile');
    }

    final locale = argResults?['locale'] as String? ?? 'en_US';
    final faker = SmartFaker(locale: locale);
    final builder = SchemaBuilder(faker);

    final inferredType =
        (argResults?['type'] as String?) ?? _inferType(schemaFile);

    final schemaContent = await file.readAsString();
    final SchemaImportResult importResult;
    switch (inferredType) {
      case 'prisma':
        importResult = builder.importFromPrisma(schemaContent);
        break;
      case 'openapi':
        final map = _decodeToMap(schemaContent, allowYaml: true);
        importResult = builder.importFromOpenApi(map);
        break;
      case 'json-schema':
      default:
        final map = _decodeToMap(schemaContent);
        importResult = builder.importFromJsonSchema(map);
        break;
    }

    if (importResult.schemas.isEmpty) {
      stderr.writeln('No schemas discovered in $schemaFile.');
      return 64;
    }

    if (importResult.warnings.isNotEmpty) {
      for (final warning in importResult.warnings) {
        stderr.writeln('warning: $warning');
      }
    }

    final listOnly = argResults?['list-schemas'] as bool? ?? false;
    if (listOnly) {
      stdout.writeln('Discovered schemas:');
      for (final schema in importResult.schemas) {
        stdout.writeln('  • ${schema.name}');
      }
      return 0;
    }

    final schemaName =
        argResults?['schema'] as String? ?? importResult.schemas.first.name;
    if (!builder.hasSchema(schemaName)) {
      stderr.writeln('Schema "$schemaName" was not found. Available schemas:');
      for (final schema in importResult.schemas) {
        stderr.writeln('  • ${schema.name}');
      }
      return 64;
    }

    final count = int.tryParse(argResults?['count'] as String? ?? '1');
    if (count == null || count < 1) {
      usageException('Invalid --count value.');
    }

    final records = builder.generateList(schemaName, count: count);
    final format = argResults?['format'] as String? ?? 'pretty';
    final encoder = format == 'pretty'
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();

    final safeRecords = records.map(_jsonSafe).toList();
    final output = encoder.convert(safeRecords);
    final outputPath = argResults?['output'] as String?;
    if (outputPath != null) {
      await File(outputPath).writeAsString(output);
      stdout.writeln(
          'Generated $count record(s) for "$schemaName" at $outputPath');
    } else {
      stdout.writeln(output);
    }

    return 0;
  }

  Map<String, dynamic> _decodeToMap(String source, {bool allowYaml = false}) {
    try {
      final dynamic decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
      throw const FormatException('Decoded JSON is not a map');
    } on FormatException {
      if (!allowYaml) rethrow;
      final yaml = loadYaml(source);
      final json = jsonDecode(jsonEncode(yaml));
      if (json is Map<String, dynamic>) {
        return json;
      }
      if (json is Map) {
        return json.map((key, value) => MapEntry(key.toString(), value));
      }
      throw const FormatException('Decoded YAML is not a map');
    }
  }

  String _inferType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.prisma')) return 'prisma';
    if (lower.endsWith('.yaml') || lower.endsWith('.yml')) return 'openapi';
    return 'json-schema';
  }

  dynamic _jsonSafe(dynamic value) {
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is Map) {
      return value.map((key, v) => MapEntry(key.toString(), _jsonSafe(v)));
    }
    if (value is Iterable) {
      return value.map(_jsonSafe).toList();
    }
    return value;
  }
}
