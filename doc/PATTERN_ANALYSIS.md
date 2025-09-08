# Pattern & Schema Analysis for SmartFaker

## 1. Fields That Need Regular Expression Support

After analyzing the existing modules, here are the fields that would benefit from regex pattern support:

### 🆔 Identity & Personal Data

#### TaiwanModule
- **ID Number**: `^[A-Z][12]\d{8}$`
  - Current: Complex algorithm with checksum
  - With Pattern: Ensure format compliance + validation
  
- **Unified Business Number**: `^\d{8}$`
  - With checksum validation
  
- **License Plate**: 
  - Old format: `^[A-Z]{2}-\d{4}$`
  - New format: `^[A-Z]{3}-\d{4}$`

#### PersonModule  
- **SSN (US)**: `^\d{3}-\d{2}-\d{4}$`
- **Passport**: `^[A-Z]\d{8}$` (varies by country)

### 📱 Phone Numbers

#### PhoneModule
Currently hardcoded formats need pattern support:

```dart
// Taiwan
"^09\d{2}-\d{3}-\d{3}$"  // Mobile
"^0[2-8]-\d{4}-\d{4}$"   // Landline

// Japan  
"^0[789]0-\d{4}-\d{4}$"  // Mobile
"^0\d{1,3}-\d{2,4}-\d{4}$" // Landline

// US
"^\(\d{3}\) \d{3}-\d{4}$"  // Standard
"^1-\d{3}-\d{3}-\d{4}$"    // With country code
```

- **IMEI**: `^\d{15}$` (with Luhn check)
- **IMSI**: `^\d{15}$`

### 💳 Financial Data

#### FinanceModule
- **Credit Card Numbers**:
  ```dart
  "^4\d{15}$"                 // Visa
  "^5[1-5]\d{14}$"           // Mastercard
  "^3[47]\d{13}$"            // Amex
  "^6011\d{12}$"             // Discover
  ```

- **Bank Account**: `^\d{10,12}$`
- **Routing Number**: `^\d{9}$` (with checksum)
- **IBAN**: `^[A-Z]{2}\d{2}[A-Z0-9]{4}\d{7}([A-Z0-9]?){0,16}$`
- **SWIFT/BIC**: `^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`

### 🌐 Internet Data

#### InternetModule
- **Email**: `^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,}$`
- **URL**: `^https?://[a-z0-9.-]+\.[a-z]{2,}(/.*)?$`
- **IPv4**: `^(\d{1,3}\.){3}\d{1,3}$`
- **IPv6**: `^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$`
- **MAC Address**: `^([0-9A-F]{2}:){5}[0-9A-F]{2}$`
- **Username**: `^[a-z0-9_]{3,16}$`

### 🏢 Business Data

#### CompanyModule
- **Tax ID**: `^\d{8}$` (Taiwan)
- **Company Registration**: `^[A-Z]{2}\d{8}$`
- **Stock Symbol**: `^[A-Z]{2,5}$`

#### EcommerceModule
- **Order ID**: `^ORD-\d{10}$`
- **SKU**: `^[A-Z]{3}-\d{6}$`
- **Tracking Number**:
  ```dart
  "^1Z[A-Z0-9]{16}$"        // UPS
  "^\d{12,14}$"             // FedEx
  "^9[234]\d{20}$"          // USPS
  ```
- **Invoice Number**: `^INV-\d{4}-\d{6}$`
- **Coupon Code**: `^[A-Z0-9]{8,12}$`

### 🚗 Vehicle Data

#### VehicleModule
- **VIN**: `^[A-HJ-NPR-Z0-9]{17}$`
- **License Plate**: (varies by country)

### 🔐 Crypto/Security

#### CryptoModule
- **Bitcoin Address**: `^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$`
- **Ethereum Address**: `^0x[a-fA-F0-9]{40}$`
- **Transaction Hash**: `^0x[a-fA-F0-9]{64}$`

## 2. Schema-Based Generation Support

### What is Schema-Based Generation?

Instead of calling individual methods, define a data structure schema and generate complete objects:

```dart
// Define schema
final userSchema = {
  'id': 'uuid',
  'name': 'person.fullName',
  'email': 'internet.email',
  'phone': 'phone.mobile',
  'address': {
    'street': 'location.streetAddress',
    'city': 'location.city',
    'zipCode': 'location.zipCode',
  },
  'createdAt': 'datetime.past',
};

// Generate data
final user = faker.fromSchema(userSchema);
```

### Benefits of Schema Support

1. **Consistency**: Generate related data sets
2. **Reusability**: Define once, use many times
3. **Type Safety**: Schema validation
4. **Relationships**: Handle data dependencies
5. **Bulk Generation**: Generate arrays of data

### Proposed Schema Features

#### 1. Basic Schema Definition

```dart
class Schema {
  final Map<String, dynamic> definition;
  final bool strict; // Enforce types
  final Map<String, Validator>? validators;
  
  Schema({
    required this.definition,
    this.strict = true,
    this.validators,
  });
}
```

#### 2. Field Types

```dart
// Simple types
'field': 'module.method'           // Call faker method
'field': {'type': 'string'}        // Type definition
'field': {'pattern': '^[A-Z]+$'}   // Regex pattern
'field': {'enum': ['A', 'B', 'C']} // Enum values
'field': {'const': 'fixed'}        // Constant value

// Complex types
'field': {
  'type': 'array',
  'items': {'type': 'string'},
  'minItems': 1,
  'maxItems': 10,
}

// Nested objects
'field': {
  'type': 'object',
  'properties': {
    'subfield': 'module.method'
  }
}
```

#### 3. Relationships & Dependencies

```dart
final orderSchema = {
  'orderId': 'ecommerce.orderId',
  'customerId': {'ref': 'customer.id'}, // Reference
  'items': {
    'type': 'array',
    'minItems': 1,
    'maxItems': 5,
    'items': {
      'productId': 'uuid',
      'quantity': {'type': 'integer', 'min': 1, 'max': 10},
      'price': 'finance.price',
      'subtotal': {'compute': '${quantity} * ${price}'}, // Computed
    }
  },
  'total': {'compute': 'sum(items.subtotal)'}, // Aggregate
};
```

#### 4. Conditional Generation

```dart
final personSchema = {
  'age': {'type': 'integer', 'min': 18, 'max': 80},
  'isStudent': {'type': 'boolean'},
  'school': {
    'when': {'isStudent': true}, // Conditional field
    'value': 'education.university',
  },
  'company': {
    'when': {'isStudent': false},
    'value': 'company.name',
  }
};
```

#### 5. Format Templates

```dart
final schema = {
  'fullName': {
    'template': '${firstName} ${middleInitial}. ${lastName}',
    'variables': {
      'firstName': 'person.firstName',
      'middleInitial': {'pattern': '^[A-Z]$'},
      'lastName': 'person.lastName',
    }
  },
  'email': {
    'template': '${firstName}.${lastName}@${company}.com',
    'variables': {
      'firstName': {'ref': 'fullName.firstName'},
      'lastName': {'ref': 'fullName.lastName'},
      'company': {'pattern': '^[a-z]{5,10}$'},
    }
  }
};
```

### Implementation Plan for Schema Support

#### Phase 1: Basic Schema (v0.4.0)
- Simple field mapping
- Basic types (string, number, boolean)
- Method calls to faker modules

#### Phase 2: Advanced Types (v0.5.0)
- Arrays and objects
- Patterns and enums
- References between fields

#### Phase 3: Full Features (v0.6.0)
- Computed fields
- Conditional generation
- Custom validators
- Bulk generation

### Example Use Cases

#### 1. E-commerce Order
```dart
final orderSchema = Schema(
  definition: {
    'orderId': 'ecommerce.orderId',
    'customer': {
      'id': 'uuid',
      'name': 'person.fullName',
      'email': 'internet.email',
      'tier': 'ecommerce.customerTier',
    },
    'items': {
      'type': 'array',
      'minItems': 1,
      'maxItems': 5,
      'items': {
        'sku': {'pattern': r'^PRD-\d{6}$'},
        'name': 'commerce.productName',
        'quantity': {'type': 'integer', 'min': 1, 'max': 10},
        'price': 'finance.price',
      }
    },
    'shipping': {
      'method': 'ecommerce.shippingMethod',
      'address': 'location.fullAddress',
      'estimatedDelivery': 'datetime.future',
    },
    'payment': {
      'method': 'ecommerce.paymentMethod',
      'status': {'enum': ['pending', 'completed', 'failed']},
    }
  }
);

final order = faker.fromSchema(orderSchema);
```

#### 2. User Registration
```dart
final userSchema = Schema(
  definition: {
    'id': 'uuid',
    'username': {'pattern': r'^[a-z0-9_]{5,15}$'},
    'email': 'internet.email',
    'password': {'pattern': r'^(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9]{8,}$'},
    'profile': {
      'firstName': 'person.firstName',
      'lastName': 'person.lastName',
      'birthDate': 'datetime.birthDate',
      'phone': 'phone.mobile',
      'avatar': 'image.avatar',
    },
    'preferences': {
      'language': {'enum': ['en_US', 'zh_TW', 'ja_JP']},
      'timezone': 'location.timezone',
      'newsletter': 'datatype.boolean',
    },
    'createdAt': 'datetime.recent',
    'verificationToken': {'pattern': r'^[A-Z0-9]{32}$'},
  },
  validators: {
    'email': (value) => value.contains('@'),
    'username': (value) => !value.contains(' '),
  }
);
```

#### 3. API Response
```dart
final apiResponseSchema = Schema(
  definition: {
    'status': {'enum': ['success', 'error']},
    'code': {'type': 'integer', 'min': 200, 'max': 599},
    'data': {
      'when': {'status': 'success'},
      'value': {
        'items': {
          'type': 'array',
          'maxItems': 20,
          'items': 'person.fullObject',
        },
        'pagination': {
          'page': {'type': 'integer', 'min': 1},
          'perPage': {'const': 20},
          'total': {'type': 'integer', 'min': 0, 'max': 1000},
        }
      }
    },
    'error': {
      'when': {'status': 'error'},
      'value': {
        'message': 'lorem.sentence',
        'details': 'lorem.paragraph',
      }
    }
  }
);
```

## 3. Comparison: Pattern vs Schema

| Feature | Pattern Support | Schema Support |
|---------|----------------|----------------|
| **Use Case** | Single field validation | Complete data structures |
| **Complexity** | Simple | Complex |
| **Flexibility** | High (any regex) | Structured |
| **Performance** | Fast for simple patterns | Depends on schema size |
| **Type Safety** | String only | Multiple types |
| **Relationships** | No | Yes |
| **Validation** | Pattern matching | Custom validators |
| **Learning Curve** | Low (know regex) | Medium |

## 4. Recommended Priority

### High Priority (Implement First)
1. **Pattern Support for**:
   - Phone numbers (all locales)
   - ID numbers (Taiwan, Japan)
   - Credit card formats
   - Email addresses
   - Order/Invoice IDs

2. **Basic Schema Support**:
   - Simple field mapping
   - Common business objects
   - API response structures

### Medium Priority
1. **Pattern Support for**:
   - IP addresses
   - MAC addresses
   - Tracking numbers
   - Vehicle identifiers

2. **Advanced Schema**:
   - Nested objects
   - Arrays
   - References

### Low Priority
1. **Complex Patterns**:
   - Lookahead/lookbehind
   - Backreferences
   
2. **Schema Features**:
   - Computed fields
   - Conditional logic
   - Custom validators

## 5. Migration Strategy

```dart
// Current approach
final phone = faker.phone.number(); // Fixed format

// With pattern support
final phone = faker.pattern.fromRegex(r'^09\d{8}$'); // Custom format

// With schema support
final user = faker.fromSchema({
  'phone': {'pattern': r'^09\d{8}$'}
});
```

## Conclusion

Both **Pattern Support** and **Schema-Based Generation** would significantly enhance SmartFaker:

1. **Pattern Support**: Essential for format validation and compliance
2. **Schema Support**: Powerful for generating complex, related data

Recommendation: **Start with Pattern Support** (simpler, immediate value), then add Schema Support for advanced use cases.

---
*Analysis Date: 2025-09-08*