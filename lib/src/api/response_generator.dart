import 'dart:math';

import '../core/smart_faker.dart';

/// Generates dynamic responses based on templates and faker data
class ResponseGenerator {
  final SmartFaker _faker;
  final Random _random = Random();

  /// Create a response generator with a faker instance
  ResponseGenerator({SmartFaker? faker}) : _faker = faker ?? SmartFaker();

  /// Generate response from a template
  /// Template can contain faker directives like @faker.person.fullName
  dynamic generate(dynamic template) {
    if (template is String) {
      return _processString(template);
    } else if (template is Map) {
      return _processMap(template);
    } else if (template is List) {
      return _processList(template);
    }
    return template;
  }

  /// Process string templates with faker directives
  String _processString(String template) {
    // Handle faker directives
    if (template.startsWith('@')) {
      return _evaluateFakerDirective(template);
    }

    // Handle string interpolation
    final pattern = RegExp(r'{{(.+?)}}');
    return template.replaceAllMapped(pattern, (match) {
      final directive = match.group(1)!.trim();
      return _evaluateFakerDirective('@$directive');
    });
  }

  /// Process map templates
  dynamic _processMap(Map template) {
    final result = <String, dynamic>{};

    for (final entry in template.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      // Handle special directives
      if (key.startsWith('@')) {
        final directive = key.substring(1);
        if (directive == 'repeat' && value is int) {
          // Generate array of objects
          return List.generate(
              value, (_) => _processMap(template..remove(key)));
        } else if (directive == 'optional' && value is Map) {
          // Optionally include field (50% chance)
          if (_random.nextBool()) {
            result.addAll(_processMap(value));
          }
        }
      } else {
        result[key] = generate(value);
      }
    }

    return result;
  }

  /// Process list templates
  List<dynamic> _processList(List template) {
    if (template.isEmpty) return [];

    // If first element is a directive, handle it specially
    if (template.first is String && template.first.toString().startsWith('@')) {
      final directive = template.first.toString();

      // Handle array generation directives
      if (directive.startsWith('@array:')) {
        final parts = directive.split(':');
        if (parts.length >= 2) {
          final count = int.tryParse(parts[1]) ?? 10;
          final itemTemplate = template.length > 1 ? template[1] : {};
          return List.generate(count, (_) => generate(itemTemplate));
        }
      }
    }

    // Otherwise, process each element
    return template.map((item) => generate(item)).toList();
  }

  /// Evaluate faker directives
  String _evaluateFakerDirective(String directive) {
    // Remove @ prefix if present
    if (directive.startsWith('@')) {
      directive = directive.substring(1);
    }

    // Parse directive parts
    final parts = directive.split('.');

    // Handle built-in types
    switch (parts.first) {
      case 'uuid':
        return _faker.datatype.uuid();
      case 'email':
        return _faker.internet.email();
      case 'url':
        return _faker.internet.url();
      case 'username':
        return _faker.internet.username();
      case 'password':
        return _faker.internet.password();
      case 'boolean':
        return _faker.datatype.boolean().toString();
      case 'number':
        return _handleNumberDirective(parts);
      case 'date':
        return _handleDateDirective(parts);
      case 'person':
        return _handlePersonDirective(parts);
      case 'company':
        return _handleCompanyDirective(parts);
      case 'address':
        return _handleAddressDirective(parts);
      case 'internet':
        return _handleInternetDirective(parts);
      case 'lorem':
        return _handleLoremDirective(parts);
      case 'image':
        return _handleImageDirective(parts);
      case 'commerce':
        return _handleCommerceDirective(parts);
      case 'phone':
        return _faker.phone.phoneNumber();
      case 'color':
        return _faker.color.hexColor();
      default:
        // Return as literal if not recognized
        return directive;
    }
  }

  /// Handle number directives
  String _handleNumberDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.datatype.number(max: 100).toString();
    }

    switch (parts[1]) {
      case 'int':
        final max = parts.length > 2 ? int.tryParse(parts[2]) ?? 100 : 100;
        return _faker.datatype.number(max: max).toString();
      case 'double':
        final max =
            parts.length > 2 ? double.tryParse(parts[2]) ?? 100.0 : 100.0;
        return _faker.datatype.float(max: max).toString();
      case 'price':
        return _faker.commerce.price().toString();
      default:
        return _faker.datatype.number(max: 100).toString();
    }
  }

  /// Handle date directives
  String _handleDateDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.date.past().toIso8601String();
    }

    switch (parts[1]) {
      case 'past':
        return _faker.date.past().toIso8601String();
      case 'future':
        return _faker.date.future().toIso8601String();
      case 'recent':
        return _faker.date.recent().toIso8601String();
      case 'soon':
        return _faker.date.soon().toIso8601String();
      case 'birthdate':
        return _faker.date.birthdate().toIso8601String();
      default:
        return _faker.date.past().toIso8601String();
    }
  }

  /// Handle person directives
  String _handlePersonDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.person.fullName();
    }

    switch (parts[1]) {
      case 'fullName':
        return _faker.person.fullName();
      case 'firstName':
        return _faker.person.firstName();
      case 'lastName':
        return _faker.person.lastName();
      case 'email':
        return _faker.person.email();
      case 'phone':
        return _faker.person.phone();
      case 'title':
        return _faker.person.jobTitle();
      case 'bio':
        return _faker.person.bio();
      default:
        return _faker.person.fullName();
    }
  }

  /// Handle company directives
  String _handleCompanyDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.company.companyName();
    }

    switch (parts[1]) {
      case 'name':
        return _faker.company.companyName();
      case 'suffix':
        return _faker.company.companySuffix();
      case 'catchPhrase':
        return _faker.company.catchPhrase();
      case 'bs':
        return _faker.company.bs();
      default:
        return _faker.company.companyName();
    }
  }

  /// Handle address directives
  String _handleAddressDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.address.streetAddress();
    }

    switch (parts[1]) {
      case 'street':
        return _faker.address.streetAddress();
      case 'city':
        return _faker.address.city();
      case 'country':
        return _faker.address.country();
      case 'zipCode':
        return _faker.address.zipCode();
      case 'full':
        return '${_faker.address.streetAddress()}, ${_faker.address.city()}, ${_faker.address.country()} ${_faker.address.zipCode()}';
      default:
        return _faker.address.streetAddress();
    }
  }

  /// Handle internet directives
  String _handleInternetDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.internet.email();
    }

    switch (parts[1]) {
      case 'email':
        return _faker.internet.email();
      case 'username':
        return _faker.internet.username();
      case 'password':
        return _faker.internet.password();
      case 'url':
        return _faker.internet.url();
      case 'domainName':
        return _faker.internet.domainName();
      case 'ipv4':
        return _faker.internet.ipv4();
      case 'ipv6':
        return _faker.internet.ipv6();
      case 'userAgent':
        return _faker.internet.userAgent();
      default:
        return _faker.internet.email();
    }
  }

  /// Handle lorem directives
  String _handleLoremDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.lorem.sentence();
    }

    switch (parts[1]) {
      case 'word':
        return _faker.lorem.word();
      case 'words':
        final count = parts.length > 2 ? int.tryParse(parts[2]) ?? 3 : 3;
        return _faker.lorem.words(count: count);
      case 'sentence':
        return _faker.lorem.sentence();
      case 'sentences':
        final count = parts.length > 2 ? int.tryParse(parts[2]) ?? 3 : 3;
        return _faker.lorem.sentences(count: count);
      case 'paragraph':
        return _faker.lorem.paragraph();
      case 'paragraphs':
        final count = parts.length > 2 ? int.tryParse(parts[2]) ?? 3 : 3;
        return _faker.lorem.paragraphs(count: count);
      default:
        return _faker.lorem.sentence();
    }
  }

  /// Handle image directives
  String _handleImageDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.image.imageUrl();
    }

    switch (parts[1]) {
      case 'avatar':
        return _faker.image.avatarUrl();
      case 'url':
        return _faker.image.imageUrl();
      case 'placeholder':
        final width = parts.length > 2 ? parts[2] : '640';
        final height = parts.length > 3 ? parts[3] : '480';
        return 'https://via.placeholder.com/${width}x$height';
      default:
        return _faker.image.imageUrl();
    }
  }

  /// Handle commerce directives
  String _handleCommerceDirective(List<String> parts) {
    if (parts.length == 1) {
      return _faker.commerce.productName();
    }

    switch (parts[1]) {
      case 'product':
        return _faker.commerce.productName();
      case 'price':
        return _faker.commerce.price().toString();
      case 'department':
        return _faker.commerce.department();
      case 'productDescription':
        return _faker.commerce.productDescription();
      default:
        return _faker.commerce.productName();
    }
  }
}
