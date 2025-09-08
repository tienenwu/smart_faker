import 'dart:convert';

/// Module for exporting generated data to various formats.
class ExportModule {
  /// Creates a new instance of [ExportModule].
  const ExportModule();

  /// Exports data to CSV format.
  ///
  /// [data] - List of maps containing the data to export
  /// [headers] - Optional custom headers. If not provided, uses keys from first item
  /// [delimiter] - CSV delimiter (default: comma)
  String toCSV(
    List<Map<String, dynamic>> data, {
    List<String>? headers,
    String delimiter = ',',
  }) {
    if (data.isEmpty) return '';

    // Get headers from first item if not provided
    final csvHeaders = headers ?? data.first.keys.toList();

    // Build CSV string
    final buffer = StringBuffer();

    // Add headers
    buffer.writeln(csvHeaders.map(_escapeCSV).join(delimiter));

    // Add data rows
    for (final row in data) {
      final values = csvHeaders.map((header) {
        final value = row[header];
        return _formatCSVValue(value);
      }).toList();
      buffer.writeln(values.join(delimiter));
    }

    return buffer.toString();
  }

  /// Exports data to JSON format.
  ///
  /// [data] - Data to export (can be any JSON-serializable object)
  /// [pretty] - Whether to format with indentation
  String toJSON(
    dynamic data, {
    bool pretty = false,
  }) {
    // Convert DateTime objects to ISO strings
    final jsonData = _prepareForJson(data);

    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonData);
    }
    return jsonEncode(jsonData);
  }

  /// Exports data to SQL INSERT statements.
  ///
  /// [data] - List of maps containing the data to export
  /// [table] - Name of the database table
  /// [columns] - Optional specific columns to include
  String toSQL(
    List<Map<String, dynamic>> data, {
    required String table,
    List<String>? columns,
  }) {
    if (data.isEmpty) return '';

    final buffer = StringBuffer();

    for (final row in data) {
      final useColumns = columns ?? row.keys.toList();
      final values = useColumns.map((col) {
        final value = row[col];
        return _formatSQLValue(value);
      }).toList();

      buffer.writeln(
          'INSERT INTO $table (${useColumns.join(', ')}) VALUES (${values.join(', ')});');
    }

    return buffer.toString();
  }

  /// Exports data to TSV (Tab-Separated Values) format.
  String toTSV(
    List<Map<String, dynamic>> data, {
    List<String>? headers,
  }) {
    return toCSV(data, headers: headers, delimiter: '\t');
  }

  /// Exports data to Markdown table format.
  String toMarkdown(
    List<Map<String, dynamic>> data, {
    List<String>? headers,
  }) {
    if (data.isEmpty) return '';

    final tableHeaders = headers ?? data.first.keys.toList();
    final buffer = StringBuffer();

    // Add headers
    buffer.writeln('| ${tableHeaders.join(' | ')} |');
    buffer.writeln('| ${tableHeaders.map((_) => '---').join(' | ')} |');

    // Add data rows
    for (final row in data) {
      final values = tableHeaders.map((header) {
        final value = row[header] ?? '';
        return value.toString().replaceAll('|', '\\|');
      }).toList();
      buffer.writeln('| ${values.join(' | ')} |');
    }

    return buffer.toString();
  }

  /// Exports data to XML format.
  String toXML(
    List<Map<String, dynamic>> data, {
    String rootElement = 'data',
    String itemElement = 'item',
  }) {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<$rootElement>');

    for (final item in data) {
      buffer.writeln('  <$itemElement>');
      item.forEach((key, value) {
        final xmlValue = _escapeXML(value?.toString() ?? '');
        buffer.writeln('    <$key>$xmlValue</$key>');
      });
      buffer.writeln('  </$itemElement>');
    }

    buffer.writeln('</$rootElement>');
    return buffer.toString();
  }

  /// Exports data to YAML format.
  String toYAML(List<Map<String, dynamic>> data) {
    final buffer = StringBuffer();

    for (int i = 0; i < data.length; i++) {
      buffer.writeln('- # Item ${i + 1}');
      data[i].forEach((key, value) {
        if (value is String && value.contains('\n')) {
          buffer.writeln('  $key: |');
          value.split('\n').forEach((line) {
            buffer.writeln('    $line');
          });
        } else if (value is List) {
          buffer.writeln('  $key:');
          for (final item in value) {
            buffer.writeln('    - ${_formatYAMLValue(item)}');
          }
        } else if (value is Map) {
          buffer.writeln('  $key:');
          value.forEach((k, v) {
            buffer.writeln('    $k: ${_formatYAMLValue(v)}');
          });
        } else {
          buffer.writeln('  $key: ${_formatYAMLValue(value)}');
        }
      });
    }

    return buffer.toString();
  }

  /// Helper method to create a data transformer for streaming large datasets.
  Stream<String> streamCSV(
    Stream<Map<String, dynamic>> dataStream, {
    List<String>? headers,
    String delimiter = ',',
  }) async* {
    bool isFirst = true;
    List<String>? csvHeaders = headers;

    await for (final item in dataStream) {
      if (isFirst) {
        csvHeaders ??= item.keys.toList();
        yield csvHeaders.map(_escapeCSV).join(delimiter) + '\n';
        isFirst = false;
      }

      final values = csvHeaders!.map((header) {
        final value = item[header];
        return _formatCSVValue(value);
      }).toList();
      yield values.join(delimiter) + '\n';
    }
  }

  // Private helper methods
  String _escapeCSV(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _formatCSVValue(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) return value.toIso8601String();
    if (value is List) return '"${value.join(', ')}"';
    if (value is Map) return '"${jsonEncode(value)}"';

    final stringValue = value.toString();
    return _escapeCSV(stringValue);
  }

  String _formatSQLValue(dynamic value) {
    if (value == null) return 'NULL';
    if (value is bool) return value ? '1' : '0';
    if (value is num) return value.toString();
    if (value is DateTime) return "'${value.toIso8601String()}'";
    if (value is List || value is Map)
      return "'${jsonEncode(value).replaceAll("'", "''")}'";

    return "'${value.toString().replaceAll("'", "''")}'";
  }

  String _escapeXML(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  String _formatYAMLValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String && (value.contains(':') || value.contains('#'))) {
      return '"$value"';
    }
    return value.toString();
  }

  dynamic _prepareForJson(dynamic data) {
    if (data is DateTime) {
      return data.toIso8601String();
    } else if (data is Map) {
      return data.map((key, value) => MapEntry(key, _prepareForJson(value)));
    } else if (data is List) {
      return data.map(_prepareForJson).toList();
    }
    return data;
  }
}
