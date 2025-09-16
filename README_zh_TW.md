# SmartFaker

[![pub package](https://img.shields.io/pub/v/smart_faker.svg)](https://pub.dev/packages/smart_faker)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一個強大且智慧的 Flutter 和 Dart 應用程式假資料生成器。SmartFaker 提供全面的測試資料生成功能，包含智慧關聯、國際化支援和基於模式的生成。

## 應用程式截圖

<p align="center">
  <img src="screenshots/01_home_screen.jpg" width="200" alt="首頁畫面" />
  <img src="screenshots/02_internet_generator.jpg" width="200" alt="網路資料生成器" />
  <img src="screenshots/03_location_generator_multilang.jpg" width="200" alt="多語言位置生成器" />
  <img src="screenshots/04_company_generator.jpg" width="200" alt="公司資料生成器" />
</p>
<p align="center">
  <img src="screenshots/05_schema_based_generation.jpg" width="200" alt="基於架構的生成" />
  <img src="screenshots/06_export_module.jpg" width="200" alt="匯出模組" />
  <img src="screenshots/07_healthcare_module.jpg" width="200" alt="醫療保健模組" />
</p>

**版本：** 0.4.0
**最後更新：** 2025-09-16

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
- 🎨 **豐富的資料類型**：20+ 個模組涵蓋人員、網路、地點、商務、金融等
- 📤 **資料匯出**：匯出為 CSV、JSON、SQL、XML、YAML、Markdown 格式（v0.2.0 新功能！）
- 🇹🇼 **台灣模組**：完整的台灣特定資料生成，包括身分證字號、統一編號等（v0.2.0 新功能！）
- 🎯 **模式模組**：從正規表示式生成符合驗證規則的假資料（v0.3.0 新功能！）
- 🚀 **API 模擬**：內建模擬伺服器，用於測試 API 整合與真實資料（v0.4.0 新功能！）

## 安裝

在您的 `pubspec.yaml` 中加入 `smart_faker`：

```yaml
dependencies:
  smart_faker: ^0.4.0
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

### 模式模組（Pattern Module）- v0.3.0 新功能！
```dart
// 從正規表示式生成資料
faker.pattern.fromRegex(r'^\d{5}$')         // "12345"
faker.pattern.fromRegex(r'^[A-Z]{3}-\d{4}$') // "ABC-1234"
faker.pattern.fromRegex(r'^09\d{8}$')       // "0912345678"

// 使用預設模式生成常見格式
faker.pattern.taiwanPhone()      // "0912-345-678"
faker.pattern.taiwanIdFormat()   // "A123456789"
faker.pattern.usPhone()          // "(555) 123-4567"
faker.pattern.japanPhone()       // "090-1234-5678"
faker.pattern.emailFormat()      // "john.doe@example.com"
faker.pattern.visaFormat()       // "4532 1234 5678 9012"
faker.pattern.mastercardFormat() // "5412 3456 7890 1234"
faker.pattern.orderIdFormat()    // "ORD-1234567890"
faker.pattern.skuFormat()        // "SKU-123456"
faker.pattern.ipv4Format()       // "192.168.1.1"
faker.pattern.macAddressFormat() // "00:1B:44:11:3A:B7"
faker.pattern.hexColorFormat()   // "#FF5733"
faker.pattern.uuidFormat()       // "550e8400-e29b-41d4-a716-446655440000"

// 自訂訂單編號前綴
faker.pattern.orderIdFormat(prefix: 'INV') // "INV-1234567890"

// 自訂發票年份
faker.pattern.invoiceFormat(year: 2025)    // "INV-20251234567"
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

## API 模擬 - v0.4.0 新功能！

SmartFaker 現在包含強大的 API 模擬功能，用於測試 Flutter 應用程式的 API 整合。內建的模擬伺服器可以生成真實的動態回應、模擬網路延遲，甚至測試錯誤處理。

### 快速開始

```dart
import 'package:smart_faker/smart_faker.dart';

void main() async {
  final faker = SmartFaker();
  final mockServer = MockServer(faker: faker);

  // 設定端點
  mockServer.get('/api/users', {
    'users': ['@array:10', {
      'id': '@uuid',
      'name': '@person.fullName',
      'email': '@internet.email',
      'age': '@number.int:65',
    }]
  });

  // 啟動伺服器
  await mockServer.start(port: 3000);
  print('模擬伺服器運行於 http://localhost:3000');

  // 您的 Flutter 應用程式現在可以向 http://localhost:3000/api/users 發送請求
  // 並接收具有 10 個隨機使用者的真實回應

  // 停止伺服器
  await mockServer.stop();
}
```

### 支援的 HTTP 方法

模擬伺服器支援所有標準的 RESTful 方法：

```dart
// GET - 取得資源
mockServer.get('/api/products', {
  'products': ['@array:5', {
    'id': '@uuid',
    'name': '@commerce.product',
    'price': '@commerce.price',
  }]
});

// POST - 建立資源
mockServer.post('/api/users', (body) => {
  'id': '@uuid',
  'name': body['name'],
  'email': body['email'],
  'createdAt': '@date.recent',
});

// PUT - 更新整個資源
mockServer.put('/api/users/<id>', (body, params) => {
  'id': params['id'],
  'name': body['name'],
  'email': body['email'],
  'updatedAt': '@date.recent',
});

// PATCH - 部分更新資源
mockServer.patch('/api/users/<id>', (body, params) => {
  'id': params['id'],
  ...body,
  'updatedAt': '@date.recent',
});

// DELETE - 刪除資源
mockServer.delete('/api/users/<id>', (params) => {
  'message': '使用者 ${params['id']} 已刪除',
  'success': true,
});
```

### 動態回應範本

使用 faker 指令生成動態資料：

```dart
// 基本 faker 指令
{
  'id': '@uuid',                    // 生成 UUID
  'email': '@email',                // 生成電子郵件
  'url': '@url',                    // 生成 URL
  'username': '@username',          // 生成使用者名稱
  'password': '@password',          // 生成密碼
  'boolean': '@boolean',            // 生成布林值
  'phone': '@phone',                // 生成電話號碼
  'color': '@color',                // 生成顏色
}

// 數字指令
{
  'age': '@number.int:100',         // 0-100 之間的整數
  'price': '@number.double:999.99', // 0-999.99 之間的浮點數
  'quantity': '@number.price',      // 價格格式
}

// 日期指令
{
  'createdAt': '@date.past',        // 過去的日期
  'updatedAt': '@date.recent',      // 最近的日期
  'nextReview': '@date.future',     // 未來的日期
  'birthday': '@date.birthdate',    // 生日
}

// 人員指令
{
  'fullName': '@person.fullName',   // 全名
  'firstName': '@person.firstName', // 名字
  'lastName': '@person.lastName',   // 姓氏
  'jobTitle': '@person.title',      // 職稱
  'bio': '@person.bio',              // 個人簡介
}

// 公司指令
{
  'company': '@company.name',       // 公司名稱
  'suffix': '@company.suffix',      // 公司後綴
  'catchPhrase': '@company.catchPhrase', // 標語
  'bs': '@company.bs',              // BS 術語
}

// 地址指令
{
  'street': '@address.street',      // 街道地址
  'city': '@address.city',          // 城市
  'country': '@address.country',    // 國家
  'zipCode': '@address.zipCode',    // 郵遞區號
  'fullAddress': '@address.full',   // 完整地址
}

// 網路指令
{
  'email': '@internet.email',       // 電子郵件
  'username': '@internet.username', // 使用者名稱
  'password': '@internet.password', // 密碼
  'url': '@internet.url',           // URL
  'domain': '@internet.domainName', // 網域名稱
  'ipv4': '@internet.ipv4',        // IPv4 地址
  'ipv6': '@internet.ipv6',        // IPv6 地址
  'userAgent': '@internet.userAgent', // 使用者代理
}

// Lorem 文字指令
{
  'title': '@lorem.sentence',       // 一個句子
  'description': '@lorem.paragraph', // 一個段落
  'summary': '@lorem.sentences:3',  // 3 個句子
  'content': '@lorem.paragraphs:5', // 5 個段落
}

// 圖片指令
{
  'avatar': '@image.avatar',        // 頭像 URL
  'image': '@image.url',            // 圖片 URL
  'placeholder': '@image.placeholder:640:480', // 佔位圖片
}

// 商務指令
{
  'product': '@commerce.product',   // 產品名稱
  'price': '@commerce.price',       // 價格
  'department': '@commerce.department', // 部門
  'description': '@commerce.productDescription', // 產品描述
}
```

### 陣列生成

生成動態大小的陣列：

```dart
mockServer.get('/api/posts', {
  'posts': ['@array:20', {      // 生成 20 個貼文
    'id': '@uuid',
    'title': '@lorem.sentence',
    'content': '@lorem.paragraph',
    'author': '@person.fullName',
    'publishedAt': '@date.recent',
    'likes': '@number.int:1000',
  }]
});
```

### 字串插值

在字串中混合靜態和動態內容：

```dart
mockServer.get('/api/profile', {
  'bio': '嗨！我是 {{person.fullName}}，{{person.title}} 來自 {{address.city}}。',
  'description': '歡迎來到 {{company.name}} - {{company.catchPhrase}}！',
});
```

### 路徑參數

支援動態路由參數：

```dart
// 路由中使用 <參數名>
mockServer.get('/api/users/<userId>/posts/<postId>', (params) => {
  'userId': params['userId'],
  'postId': params['postId'],
  'title': '@lorem.sentence',
  'content': '@lorem.paragraph',
});

// 客戶端請求：GET /api/users/123/posts/456
// 回應：{ userId: "123", postId: "456", title: "...", content: "..." }
```

### 狀態管理 (CRUD)

模擬伺服器可以維護記憶體中的狀態，用於真實的 CRUD 操作：

```dart
final mockServer = MockServer(faker: faker);

// 啟用狀態管理
mockServer.enableStatefulCrud('/api/users');

// 現在這些端點自動運作：
// GET    /api/users      - 列出所有使用者
// GET    /api/users/:id  - 取得特定使用者
// POST   /api/users      - 建立新使用者
// PUT    /api/users/:id  - 更新使用者
// DELETE /api/users/:id  - 刪除使用者

// 您也可以手動管理狀態
mockServer.setState('users', [
  {'id': '1', 'name': '王小明'},
  {'id': '2', 'name': '李小華'},
]);

final users = mockServer.getState('users');
```

### 網路模擬

模擬真實的網路條件：

```dart
// 新增延遲到所有請求（毫秒）
mockServer.setDelay(500, 2000);  // 隨機 500-2000ms 延遲

// 模擬網路錯誤
mockServer.setErrorRate(0.1);  // 10% 的請求會失敗

// 只對特定端點設定條件
mockServer.get('/api/slow-endpoint',
  {'data': '@lorem.sentence'},
  delay: 3000,  // 3 秒延遲
);

mockServer.get('/api/flaky-endpoint',
  {'data': '@lorem.sentence'},
  errorRate: 0.5,  // 50% 錯誤率
);
```

### 中介軟體支援

新增自訂中介軟體處理請求：

```dart
// 新增日誌記錄
mockServer.addMiddleware((request) async {
  print('${request.method} ${request.requestedUri.path}');
  return null;  // 繼續到下一個處理程序
});

// 新增驗證
mockServer.addMiddleware((request) async {
  final authHeader = request.headers['authorization'];
  if (authHeader == null || !authHeader.contains('Bearer')) {
    return Response.forbidden('需要驗證');
  }
  return null;  // 繼續處理
});

// 新增自訂標頭
mockServer.addMiddleware((request) async {
  return null;  // 回應將由路由處理程序新增標頭
});
```

### 完整範例：電商 API

```dart
import 'package:smart_faker/smart_faker.dart';

void main() async {
  final faker = SmartFaker(locale: 'zh_TW');
  final mockServer = MockServer(faker: faker);

  // 設定延遲以模擬真實網路
  mockServer.setDelay(200, 800);

  // 產品列表
  mockServer.get('/api/products', {
    'products': ['@array:20', {
      'id': '@uuid',
      'name': '@commerce.product',
      'price': '@commerce.price',
      'category': '@commerce.department',
      'inStock': '@boolean',
      'rating': '@number.int:5',
      'imageUrl': '@image.url',
    }],
    'total': 20,
    'page': 1,
  });

  // 產品詳情
  mockServer.get('/api/products/<id>', (params) => {
    'id': params['id'],
    'name': '@commerce.product',
    'price': '@commerce.price',
    'description': '@commerce.productDescription',
    'specifications': {
      'weight': '{{number.int:10}} 公斤',
      'dimensions': '{{number.int:100}}x{{number.int:100}}x{{number.int:100}} 公分',
      'warranty': '{{number.int:3}} 年',
    },
    'images': ['@array:5', '@image.url'],
    'reviews': ['@array:10', {
      'id': '@uuid',
      'author': '@person.fullName',
      'rating': '@number.int:5',
      'comment': '@lorem.sentence',
      'date': '@date.recent',
    }],
  });

  // 購物車
  mockServer.enableStatefulCrud('/api/cart');

  // 下訂單
  mockServer.post('/api/orders', (body) => {
    'orderId': '@uuid',
    'items': body['items'],
    'total': '@commerce.price',
    'status': '處理中',
    'estimatedDelivery': '@date.soon',
    'trackingNumber': 'TW-{{number.int:999999999}}',
  });

  // 使用者認證
  mockServer.post('/api/auth/login', (body) => {
    'token': '@uuid',
    'user': {
      'id': '@uuid',
      'email': body['email'],
      'name': '@person.fullName',
      'role': '顧客',
    },
    'expiresIn': 3600,
  });

  await mockServer.start(port: 3000);
  print('電商模擬 API 運行於 http://localhost:3000');

  // 測試時保持伺服器運行
  // 生產環境中記得呼叫 mockServer.stop()
}
```

### 與 Flutter 整合

在您的 Flutter 應用程式中使用模擬伺服器：

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // 開發環境使用模擬伺服器，生產環境使用真實 API
  static const String baseUrl = kDebugMode
    ? 'http://localhost:3000'  // 模擬伺服器
    : 'https://api.production.com';  // 生產 API

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
        .map((p) => Product.fromJson(p))
        .toList();
    }
    throw Exception('載入產品失敗');
  }
}
```

### 測試範例

```dart
import 'package:test/test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  late MockServer mockServer;

  setUpAll(() async {
    final faker = SmartFaker(seed: 12345);
    mockServer = MockServer(faker: faker);

    mockServer.get('/api/users', {
      'users': ['@array:5', {
        'id': '@uuid',
        'name': '@person.fullName',
      }]
    });

    await mockServer.start(port: 3001);
  });

  tearDownAll(() async {
    await mockServer.stop();
  });

  test('應該取得使用者列表', () async {
    final response = await http.get(
      Uri.parse('http://localhost:3001/api/users')
    );

    expect(response.statusCode, 200);
    final data = json.decode(response.body);
    expect(data['users'], hasLength(5));
  });
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

如果您覺得這個套件有幫助，您可以支援開發：

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-yellow?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/wutienenc)

您也可以：
- ⭐ 給專案加星
- 🐛 回報錯誤
- 💡 建議新功能
- 📖 改進文件

對於錯誤和功能請求，請[建立 issue](https://github.com/tienenwu/smart_faker/issues)。