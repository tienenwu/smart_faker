# SmartFaker Ideas & Future Features

## Feature: Regular Expression Pattern Support

### Overview
Enable developers to generate fake data that matches specific regular expression patterns, allowing for seamless integration with existing validation rules and system requirements.

### Problem Statement

Many development teams face challenges when generating test data:

1. **Validation Compatibility**: Test data must pass existing validation rules
   - Enterprise systems often have strict format requirements
   - Legacy systems require specific patterns
   - Integration tests fail due to format mismatches

2. **Manual Post-Processing**: Developers waste time adjusting generated data
   - Generated phone numbers don't match company format
   - Order IDs don't follow internal naming conventions
   - Employee codes need manual modification

3. **Testing Gaps**: Invalid test data leads to incomplete testing
   - Can't test validation logic properly
   - Integration tests skip important scenarios
   - Production issues due to untested edge cases

### Solution Goals

1. **Direct Pattern Generation**: Generate data matching regex patterns directly
2. **Zero Post-Processing**: Output immediately usable in existing systems
3. **Validation Ready**: All generated data passes validation rules
4. **Enterprise Friendly**: Support complex corporate data formats

### Implementation Plan

#### Phase 1: MVP (v0.3.0) - Basic Pattern Support

**Core Feature**: Simple regex pattern generation

```dart
class PatternModule {
  final RandomGenerator random;
  final LocaleManager localeManager;
  
  PatternModule(this.random, this.localeManager);
  
  /// Generate string from regex pattern
  /// Supports basic regex features initially
  String fromRegex(String pattern, {
    Duration timeout = const Duration(seconds: 5),
    bool experimental = true,
  }) {
    // Implementation using regex parser
    // Convert regex to generation rules
    // Handle character classes, quantifiers, anchors
  }
}
```

**Supported Patterns**:
- Character classes: `[A-Z]`, `[0-9]`, `\d`, `\w`
- Quantifiers: `{n}`, `{n,m}`, `+`, `*`, `?`
- Anchors: `^`, `$`
- Groups: `(...)` 
- Alternation: `|`

**Example Usage**:
```dart
final faker = SmartFaker();

// Taiwan phone number
final phone = faker.pattern.fromRegex(r'^\+886-9\d{2}-\d{3}-\d{3}$');
// Output: +886-923-456-789

// Order ID
final orderId = faker.pattern.fromRegex(r'^ORD-2024\d{6}$');
// Output: ORD-20241234567

// Employee code
final empCode = faker.pattern.fromRegex(r'^EMP[A-Z]{2}\d{4}$');
// Output: EMPAB1234
```

#### Phase 2: Pattern Library (v0.4.0)

**Pre-built Common Patterns**:

```dart
extension PatternPresets on PatternModule {
  /// Taiwan phone number
  String taiwanPhone() => fromRegex(r'^\+886-9\d{2}-\d{3}-\d{3}$');
  
  /// Taiwan ID number format
  String taiwanId() => fromRegex(r'^[A-Z][12]\d{8}$');
  
  /// Credit card (simplified)
  String creditCard() => fromRegex(r'^\d{4}-\d{4}-\d{4}-\d{4}$');
  
  /// Email with company domain
  String corporateEmail(String domain) => 
    fromRegex(r'^[a-z]+\.[a-z]+@' + RegExp.escape(domain) + r'$');
  
  /// Invoice number (Taiwan format)
  String invoiceNumber() => fromRegex(r'^[A-Z]{2}\d{8}$');
  
  /// License plate (Taiwan)
  String licensePlate() => fromRegex(r'^[A-Z]{3}-\d{4}$');
}
```

**Localized Patterns**:
```dart
Map<String, Map<String, String>> patterns = {
  'zh_TW': {
    'phone': r'^\+886-9\d{2}-\d{3}-\d{3}$',
    'id': r'^[A-Z][12]\d{8}$',
    'zipcode': r'^\d{3}$',
  },
  'ja_JP': {
    'phone': r'^\+81-[789]0-\d{4}-\d{4}$',
    'zipcode': r'^\d{3}-\d{4}$',
  },
  'en_US': {
    'phone': r'^\+1-\d{3}-\d{3}-\d{4}$',
    'ssn': r'^\d{3}-\d{2}-\d{4}$',
    'zipcode': r'^\d{5}(-\d{4})?$',
  },
};
```

#### Phase 3: Advanced Features (v0.5.0)

**Custom Validators**:
```dart
String generateWithValidation(
  String pattern, {
  bool Function(String)? validator,
  int maxAttempts = 100,
}) {
  for (int i = 0; i < maxAttempts; i++) {
    final result = fromRegex(pattern);
    if (validator == null || validator(result)) {
      return result;
    }
  }
  throw Exception('Could not generate valid data within $maxAttempts attempts');
}
```

**Backreference Support**:
```dart
// Support for \1, \2 backreferences
final duplicate = faker.pattern.fromRegex(r'^([A-Z]{3})-\1$');
// Output: ABC-ABC
```

**Complex Patterns**:
- Lookahead/lookbehind assertions
- Named groups
- Unicode support
- Conditional patterns

### Technical Implementation Details

#### 1. Regex Parser Architecture

```dart
abstract class RegexNode {
  String generate(RandomGenerator random);
}

class CharacterClass extends RegexNode {
  final List<CharRange> ranges;
  
  @override
  String generate(RandomGenerator random) {
    // Pick random character from ranges
  }
}

class Quantifier extends RegexNode {
  final RegexNode child;
  final int min;
  final int? max;
  
  @override
  String generate(RandomGenerator random) {
    // Generate child node n times
  }
}
```

#### 2. Safety Mechanisms

```dart
class PatternSafetyGuard {
  static const int maxDepth = 10;
  static const int maxIterations = 1000;
  static const Duration defaultTimeout = Duration(seconds: 5);
  
  static void checkComplexity(String pattern) {
    // Analyze pattern complexity
    // Reject patterns that could cause exponential generation
  }
  
  static Future<String> generateWithTimeout(
    String pattern,
    Duration timeout,
  ) async {
    return Future.any([
      Future.delayed(timeout, () => throw TimeoutException()),
      Future(() => generateFromPattern(pattern)),
    ]);
  }
}
```

#### 3. Performance Optimization

```dart
class PatternCache {
  final Map<String, CompiledPattern> _cache = {};
  
  CompiledPattern compile(String pattern) {
    return _cache.putIfAbsent(pattern, () => _compile(pattern));
  }
  
  CompiledPattern _compile(String pattern) {
    // Parse and compile pattern into optimized structure
  }
}
```

### Testing Strategy

1. **Unit Tests**: Test each regex component individually
2. **Integration Tests**: Test complex patterns
3. **Performance Tests**: Ensure generation speed
4. **Security Tests**: Test against regex bombs
5. **Validation Tests**: Verify output matches pattern

```dart
test('generates valid Taiwan phone numbers', () {
  final pattern = r'^\+886-9\d{2}-\d{3}-\d{3}$';
  for (int i = 0; i < 100; i++) {
    final phone = faker.pattern.fromRegex(pattern);
    expect(RegExp(pattern).hasMatch(phone), isTrue);
  }
});
```

### Migration Path

For existing users, provide compatibility layer:

```dart
// Old way
final phone = faker.phone.number();

// New way with pattern
final phone = faker.pattern.taiwanPhone();

// Custom pattern
final phone = faker.pattern.fromRegex(myCompanyPhonePattern);
```

### Documentation Requirements

1. **API Documentation**: Complete dartdoc for all public methods
2. **Pattern Guide**: Examples of common patterns
3. **Performance Guide**: Best practices for complex patterns
4. **Security Guide**: Avoiding regex bombs
5. **Migration Guide**: Moving from fixed generators to patterns

### Success Metrics

1. **Adoption Rate**: 30% of users using pattern features within 6 months
2. **Performance**: 95% of patterns generate in <100ms
3. **Reliability**: Zero regex bomb incidents
4. **User Satisfaction**: >4.5 star rating for pattern features

### Risks and Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Regex bombs | High | Timeout + complexity limits |
| Poor performance | Medium | Caching + optimization |
| Complex API | Medium | Progressive disclosure |
| Breaking changes | Low | Feature flag + experimental tag |

### Timeline

- **Month 1**: Research and prototype
- **Month 2**: Implement Phase 1 (MVP)
- **Month 3**: Testing and documentation
- **Month 4**: Release v0.3.0 with experimental pattern support
- **Month 5-6**: Gather feedback and implement Phase 2
- **Month 7-8**: Phase 3 development
- **Month 9**: Full release v0.5.0

### Alternative Approaches Considered

1. **Template-based Generation**: Using templates like `XXX-####`
   - Pros: Simpler to implement
   - Cons: Less flexible than regex

2. **Format Strings**: Using format strings like `{alpha:3}-{digit:4}`
   - Pros: More readable
   - Cons: Not standard, learning curve

3. **Builder Pattern**: Programmatic pattern building
   - Pros: Type-safe, IDE support
   - Cons: Verbose, less portable

### Decision: Regex Pattern Support

Chosen regex approach because:
1. **Industry Standard**: Developers already know regex
2. **Portable**: Patterns can be shared across languages
3. **Powerful**: Can express complex patterns
4. **Existing Tools**: Can leverage existing regex libraries

---

## Other Future Ideas

### 1. AI-Powered Data Generation
Use AI models to generate more realistic data based on context.

### 2. Database Seeding Integration
Direct integration with popular databases for seeding test data.

### 3. GraphQL Schema Support
Generate data based on GraphQL schemas automatically.

### 4. Visual Pattern Builder
Web-based tool to visually create and test patterns.

### 5. Data Relationship Support
Generate related data that maintains referential integrity.

---

*Document created: 2025-09-08*
*Last updated: 2025-09-08*