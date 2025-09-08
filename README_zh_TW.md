# SmartFaker

[![pub package](https://img.shields.io/pub/v/smart_faker.svg)](https://pub.dev/packages/smart_faker)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一個強大且智慧的 Flutter 和 Dart 應用程式假資料生成器。SmartFaker 提供全面的測試資料生成功能，包含智慧關聯、國際化支援和基於模式的生成。

**版本：** 0.1.1  
**最後更新：** 2025-09-08

## 📦 資源

- **GitHub 儲存庫：** [https://github.com/tienenwu/smart_faker](https://github.com/tienenwu/smart_faker)
- **示範應用程式：** 在儲存庫的 `/demo` 資料夾中提供所有功能的完整範例
- **API 文件：** [pub.dev/documentation/smart_faker](https://pub.dev/documentation/smart_faker/latest/)

## 功能特色

- 🌍 **多語言支援**：英文、繁體中文、日文
- 🔗 **智慧關聯**：建立具有一致關係的真實資料
- 📊 **基於模式的生成**：定義資料結構並生成一致的假資料
- 🎯 **型別安全 API**：完整的型別介面，提供更好的 IDE 支援和更少的執行時錯誤
- 🔄 **可重現結果**：基於種子的生成，確保測試資料一致
- 🏗️ **工廠模式**：多種整合資料類別的方式
- ⚡ **高效能**：針對大型資料集最佳化
- 🎨 **豐富的資料類型**：15+ 個模組涵蓋人員、網路、地點、商務、金融等

## 安裝

在您的 `pubspec.yaml` 中加入 `smart_faker`：

```yaml
dependencies:
  smart_faker: ^0.1.1
```

然後執行：

```bash
flutter pub get
```

## 快速開始

### 基本使用

```dart
import 'package:smart_faker/smart_faker.dart';

void main() {
  final faker = SmartFaker();
  
  // 生成基本資料
  print(faker.person.fullName());        // "John Smith"
  print(faker.internet.email());         // "john.smith@example.com"
  print(faker.location.city());          // "New York"
  print(faker.commerce.productName());   // "人體工學橡膠鍵盤"
}
```

### 使用不同語言環境

```dart
// 繁體中文環境
final zhFaker = SmartFaker(locale: 'zh_TW');
print(zhFaker.person.fullName());      // "王小明"
print(zhFaker.location.city());        // "台北市"
print(zhFaker.company.name());         // "科技有限公司"

// 日文環境
final jaFaker = SmartFaker(locale: 'ja_JP');
print(jaFaker.person.fullName());      // "山田太郎"
print(jaFaker.company.name());         // "株式会社山田"
print(jaFaker.location.city());        // "東京都"
```

### 可重現的資料（使用種子）

```dart
// 相同的種子產生相同的資料
final faker1 = SmartFaker(seed: 42);
final faker2 = SmartFaker(seed: 42);

print(faker1.person.fullName() == faker2.person.fullName()); // true
```

## 資料類別整合

### 方法 1：工廠建構函式

```dart
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
  
  // 新增工廠建構函式來生成假資料
  factory User.fake() {
    final faker = SmartFaker();
    return User(
      id: faker.random.uuid(),
      name: faker.person.fullName(),
      email: faker.internet.email(),
      age: faker.random.integer(min: 18, max: 65),
    );
  }
  
  // 生成多個實例
  static List<User> fakeList(int count) {
    return List.generate(count, (_) => User.fake());
  }
}

// 使用方式
final user = User.fake();
final users = User.fakeList(10);
```

### 方法 2：擴充方法

```dart
class Product {
  final String id;
  final String name;
  final double price;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

// 透過擴充新增假資料生成
extension ProductFaker on Product {
  static Product fake() {
    final faker = SmartFaker();
    return Product(
      id: faker.random.uuid(),
      name: faker.commerce.productName(),
      price: faker.commerce.price(min: 9.99, max: 999.99),
    );
  }
}

// 使用方式
final product = ProductFaker.fake();
```

## 基於模式的生成

定義具有關聯的複雜資料結構：

```dart
final faker = SmartFaker();
final builder = SchemaBuilder(faker);

// 定義使用者模式
final userSchema = SchemaBuilder.defineSchema('User')
  .id()
  .withName()
  .withContact()
  .field('age', FakerFieldType.integer, min: 18, max: 65)
  .withTimestamps()
  .build();

// 定義具有關聯的訂單模式
final orderSchema = SchemaBuilder.defineSchema('Order')
  .id()
  .belongsTo('userId', 'User')
  .field('total', FakerFieldType.amount, min: 10, max: 1000)
  .field('status', FakerFieldType.word)
  .withTimestamps()
  .build();

// 註冊模式
builder.registerSchema(userSchema);
builder.registerSchema(orderSchema);

// 生成具有關聯的資料
final order = builder.generate('Order');
print(order); // 具有有效 userId 參考的訂單
```

## 智慧關聯

建立具有一致關係的真實相關資料：

```dart
final faker = SmartFaker();
final manager = RelationshipManager(faker);
final relationshipBuilder = SmartRelationshipBuilder(
  manager: manager,
  faker: faker,
);

// 一對多：使用者與貼文
final user = relationshipBuilder.oneToMany(
  parentSchema: 'User',
  childSchema: 'Post',
  parent: {
    'name': faker.person.fullName(),
    'email': faker.internet.email(),
  },
  childrenGenerator: (userId) => List.generate(3, (_) => {
    'title': faker.lorem.sentence(),
    'content': faker.lorem.paragraph(),
    'authorId': userId,
  }),
);

// 多對多：使用者和角色
final pivotData = relationshipBuilder.manyToMany(
  schema1: 'User',
  schema2: 'Role',
  pivotSchema: 'UserRole',
  items1: users,
  items2: roles,
);

// 階層式：組織結構
final orgChart = relationshipBuilder.hierarchy(
  schema: 'Department',
  nodeGenerator: (depth, parentId) => {
    'name': faker.commerce.department(),
    'budget': faker.finance.amount(min: 50000, max: 500000),
  },
  maxDepth: 3,
  childrenPerNode: 4,
);
```

## 可用模組

### 人員模組（Person Module）
```dart
faker.person.firstName()      // "John"
faker.person.lastName()       // "Smith"
faker.person.fullName()       // "John Smith"
faker.person.prefix()         // "Mr."
faker.person.suffix()         // "Jr."
faker.person.gender()         // "Male"
faker.person.jobTitle()       // "資深開發人員"
```

### 網路模組（Internet Module）
```dart
faker.internet.email()        // "user@example.com"
faker.internet.username()     // "cooluser123"
faker.internet.password()     // "SecurePass123!"
faker.internet.url()          // "https://example.com"
faker.internet.ipv4()         // "192.168.1.1"
faker.internet.ipv6()         // "2001:0db8:85a3::8a2e:0370:7334"
faker.internet.macAddress()   // "00:1B:44:11:3A:B7"
faker.internet.userAgent()    // "Mozilla/5.0..."
faker.internet.domainName()   // "example.com"
```

### 地點模組（Location Module）
```dart
faker.location.country()      // "美國"
faker.location.city()          // "紐約"
faker.location.state()         // "加州"
faker.location.zipCode()       // "10001"
faker.location.streetAddress() // "123 主街"
faker.location.latitude()      // 40.7128
faker.location.longitude()     // -74.0060
faker.location.coordinates()   // Coordinates 物件
faker.location.timeZone()      // "America/New_York"
```

### 其他模組

- **商務（Commerce）**：產品、價格、類別、SKU
- **公司（Company）**：公司名稱、標語、產業
- **金融（Finance）**：金額、信用卡、IBAN、加密貨幣
- **日期時間（DateTime）**：過去、未來、最近、之間
- **Lorem**：單字、句子、段落
- **圖片（Image）**：頭像、圖片 URL、SVG
- **電話（Phone）**：電話號碼、國碼、區碼
- **車輛（Vehicle）**：VIN、車牌、品牌、型號
- **系統（System）**：檔案路徑、MIME 類型、副檔名
- **顏色（Color）**：十六進位色彩、RGB、HSL
- **加密貨幣（Crypto）**：比特幣/以太坊地址、雜湊
- **食物（Food）**：菜餚、食材、餐廳、菜系
- **音樂（Music）**：類型、藝術家、歌曲、專輯

## 進階用法

### 批次生成

```dart
// 有效率地生成多個項目
final faker = SmartFaker(seed: 42);

// 生成 100 個具有一致關係的使用者
final users = List.generate(100, (_) => User.fake());

// 生成相關資料
final posts = <Map<String, dynamic>>[];
for (final user in users) {
  final userPosts = List.generate(
    faker.random.integer(min: 1, max: 5),
    (_) => {
      'userId': user.id,
      'title': faker.lorem.sentence(),
      'content': faker.lorem.paragraphs(3),
      'publishedAt': faker.dateTime.recent().toIso8601String(),
    },
  );
  posts.addAll(userPosts);
}
```

### 自訂頭像生成

```dart
// 使用自訂選項生成本地頭像
final avatar = faker.image.localAvatar(
  name: faker.person.fullName(),
  size: AvatarSize.large,    // 128x128
  shape: AvatarShape.circle,
  backgroundColor: '#3498db',
);

// 在 Flutter widget 中使用
Container(
  width: 128,
  height: 128,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(
      image: MemoryImage(base64Decode(avatar.split(',')[1])),
    ),
  ),
)
```

## 常見使用案例

### 1. 測試電商應用程式
```dart
// 生成測試產品
final products = List.generate(50, (_) => {
  'id': faker.random.uuid(),
  'name': faker.commerce.productName(),
  'price': faker.commerce.price(min: 10, max: 1000),
  'category': faker.commerce.category(),
  'inStock': faker.random.boolean(),
  'rating': faker.random.integer(min: 1, max: 5),
});
```

### 2. 模擬 API 回應
```dart
Map<String, dynamic> mockUserResponse() {
  final faker = SmartFaker();
  return {
    'status': 'success',
    'data': {
      'user': {
        'id': faker.random.uuid(),
        'profile': {
          'firstName': faker.person.firstName(),
          'lastName': faker.person.lastName(),
          'avatar': faker.image.avatar(),
          'email': faker.internet.email(),
        },
      }
    }
  };
}
```

### 3. 資料庫種子資料
```dart
Future<void> seedDatabase() async {
  final faker = SmartFaker(seed: 12345); // 可重現的資料
  
  // 建立使用者
  for (int i = 0; i < 100; i++) {
    await db.insert('users', {
      'name': faker.person.fullName(),
      'email': faker.internet.email(),
      'created_at': faker.dateTime.past(),
    });
  }
}
```

## 故障排除

### 常見問題

1. **DateTime 序列化錯誤**
   - 使用 JSON 時始終將 DateTime 轉換為字串
   ```dart
   'createdAt': faker.dateTime.past().toIso8601String()
   ```

2. **語言環境無效**
   - 確保語言環境受支援：`en_US`、`zh_TW` 或 `ja_JP`
   - 檢查拼寫和大小寫

3. **可重現資料無效**
   - 使用相同的種子值
   - 使用種子建立新的 SmartFaker 實例

## 效能提示

1. **重用 Faker 實例**：建立一次並重複使用以獲得更好的效能
2. **使用批次生成**：在單一迴圈中生成多個項目
3. **延遲載入**：僅在需要時生成資料
4. **測試用種子**：在測試中使用種子以獲得可重現的結果

## 支援的語言環境

- `en_US` - 英文（美國）- 預設
- `zh_TW` - 繁體中文
- `ja_JP` - 日文

## 範例應用程式

[GitHub 儲存庫](https://github.com/tienenwu/smart_faker/tree/main/demo)中提供了完整的示範應用程式。示範包含：

- 所有資料生成模組
- 即時範例的基於模式生成
- 智慧關聯示範
- 多語言支援
- 自訂頭像生成
- 展示不同使用案例的互動式表單

執行示範：

```bash
git clone https://github.com/tienenwu/smart_faker.git
cd smart_faker/demo
flutter run
```

## 貢獻

歡迎貢獻！請隨時提交 Pull Request。

1. Fork 專案
2. 建立您的功能分支（`git checkout -b feature/AmazingFeature`）
3. 提交您的更改（`git commit -m 'Add some AmazingFeature'`）
4. 推送到分支（`git push origin feature/AmazingFeature`）
5. 開啟 Pull Request

## 授權

本專案採用 MIT 授權 - 詳見 [LICENSE](LICENSE) 檔案。

## 致謝

- 靈感來自 [Faker.js](https://github.com/faker-js/faker) 和 [Bogus](https://github.com/bchavez/Bogus)
- 用 ❤️ 為 Flutter 社群打造

## 支援

如果您覺得這個套件有幫助，請考慮：
- ⭐ 給專案加星
- 🐛 回報錯誤
- 💡 建議新功能
- 📖 改進文件

對於錯誤和功能請求，請[建立 issue](https://github.com/tienenwu/smart_faker/issues)。