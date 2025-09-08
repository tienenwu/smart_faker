import '../core/random_generator.dart';
import '../core/locale_manager.dart';

/// Module for generating e-commerce related data.
class EcommerceModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [EcommerceModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of e-commerce data.
  EcommerceModule(this.random, this.localeManager);

  /// Generates an order ID.
  ///
  /// Returns a formatted order ID with year and sequence number.
  String orderId() {
    final year = DateTime.now().year;
    final sequence = random.integer(min: 100000, max: 999999);
    final formats = [
      'ORD-$year-$sequence',
      'PO-$sequence',
      '#$year$sequence',
      'ORDER-${random.alphanumeric(8).toUpperCase()}',
    ];
    return random.element(formats);
  }

  /// Generates a tracking number.
  ///
  /// Returns a realistic tracking number for various carriers.
  String trackingNumber() {
    final carriers = {
      'UPS': () => '1Z${random.alphanumeric(16).toUpperCase()}',
      'FedEx': () =>
          '${random.integer(min: 1000000000000, max: 9999999999999)}',
      'USPS': () =>
          '${random.integer(min: 9400, max: 9499)}${random.integer(min: 1000000000000000, max: 9999999999999999)}',
      'DHL': () => '${random.integer(min: 10000000000, max: 99999999999)}',
      'EMS': () => 'E${random.alphanumeric(9).toUpperCase()}TW',
    };

    final carrier = random.element(carriers.keys.toList());
    return carriers[carrier]!();
  }

  /// Generates a coupon code.
  ///
  /// Returns various types of discount codes.
  String couponCode() {
    final prefixes = [
      'SAVE',
      'DEAL',
      'SALE',
      'PROMO',
      'DISCOUNT',
      'OFF',
      'GET',
      'NEW',
      'FLASH',
      'MEGA'
    ];
    final suffixes = [
      '10',
      '15',
      '20',
      '25',
      '30',
      '40',
      '50',
      'NOW',
      '2024',
      '2025',
      'TODAY'
    ];

    final formats = [
      () => '${random.element(prefixes)}${random.element(suffixes)}',
      () =>
          '${random.element(prefixes)}-${random.alphanumeric(4).toUpperCase()}',
      () => '${random.alphanumeric(8).toUpperCase()}',
      () => '${random.element([
                'WELCOME',
                'THANKYOU',
                'LOYALTY',
                'VIP'
              ])}${random.integer(min: 10, max: 50)}',
      () => '${random.element([
                'SUMMER',
                'WINTER',
                'SPRING',
                'FALL',
                'HOLIDAY'
              ])}${random.integer(min: 2024, max: 2025)}',
    ];

    return random.element(formats)();
  }

  /// Generates a shipping method.
  String shippingMethod() {
    final methods = {
      'en_US': [
        'Standard Shipping',
        'Express Delivery',
        'Next Day Delivery',
        'Two-Day Shipping',
        'Economy Shipping',
        'Priority Mail',
        'Ground Shipping',
        'Air Freight',
        'Same Day Delivery',
        'Free Shipping',
      ],
      'zh_TW': [
        '標準配送',
        '快速配送',
        '隔日送達',
        '兩日送達',
        '經濟配送',
        '優先郵件',
        '陸運',
        '空運',
        '當日送達',
        '免費配送',
      ],
      'ja_JP': [
        '標準配送',
        '速達便',
        '翌日配送',
        '2日以内配送',
        'エコノミー配送',
        '優先郵便',
        '陸送',
        '航空便',
        '当日配送',
        '送料無料',
      ],
    };

    final locale = localeManager.currentLocale;
    return random.element(methods[locale] ?? methods['en_US']!);
  }

  /// Generates a payment method.
  String paymentMethod() {
    final methods = {
      'en_US': [
        'Credit Card',
        'Debit Card',
        'PayPal',
        'Apple Pay',
        'Google Pay',
        'Bank Transfer',
        'Cash on Delivery',
        'Cryptocurrency',
        'Buy Now Pay Later',
        'Gift Card',
        'Store Credit',
      ],
      'zh_TW': [
        '信用卡',
        '金融卡',
        'PayPal',
        'Apple Pay',
        'Google Pay',
        '銀行轉帳',
        '貨到付款',
        '加密貨幣',
        '先買後付',
        '禮品卡',
        '商店點數',
      ],
      'ja_JP': [
        'クレジットカード',
        'デビットカード',
        'PayPal',
        'Apple Pay',
        'Google Pay',
        '銀行振込',
        '代金引換',
        '暗号通貨',
        '後払い',
        'ギフトカード',
        'ストアクレジット',
      ],
    };

    final locale = localeManager.currentLocale;
    return random.element(methods[locale] ?? methods['en_US']!);
  }

  /// Generates an order status.
  String orderStatus() {
    final statuses = {
      'en_US': [
        'Pending',
        'Processing',
        'Confirmed',
        'Shipped',
        'Out for Delivery',
        'Delivered',
        'Completed',
        'Cancelled',
        'Refunded',
        'On Hold',
        'Failed',
        'Returned',
      ],
      'zh_TW': [
        '待處理',
        '處理中',
        '已確認',
        '已出貨',
        '配送中',
        '已送達',
        '已完成',
        '已取消',
        '已退款',
        '暫停',
        '失敗',
        '已退貨',
      ],
      'ja_JP': [
        '保留中',
        '処理中',
        '確認済み',
        '発送済み',
        '配達中',
        '配達済み',
        '完了',
        'キャンセル',
        '返金済み',
        '一時停止',
        '失敗',
        '返品済み',
      ],
    };

    final locale = localeManager.currentLocale;
    return random.element(statuses[locale] ?? statuses['en_US']!);
  }

  /// Generates a product review.
  ///
  /// Returns a review with rating and comment.
  Map<String, dynamic> review() {
    final rating = random.decimal(min: 1.0, max: 5.0);
    final roundedRating = (rating * 2).round() / 2; // Round to nearest 0.5

    final comments = {
      5.0: [
        'Excellent product! Highly recommend!',
        'Perfect! Exactly what I was looking for.',
        'Amazing quality, fast shipping!',
        'Best purchase ever! Worth every penny.',
        'Outstanding! Exceeded my expectations.',
      ],
      4.0: [
        'Very good product, minor issues.',
        'Great value for money.',
        'Good quality, satisfied with purchase.',
        'Nice product, would buy again.',
        'Pretty good, meets expectations.',
      ],
      3.0: [
        'Average product, nothing special.',
        'Okay for the price.',
        'Decent, but could be better.',
        'Mixed feelings about this.',
        'It\'s fine, serves its purpose.',
      ],
      2.0: [
        'Not great, disappointed.',
        'Below expectations.',
        'Poor quality for the price.',
        'Would not recommend.',
        'Many issues with this product.',
      ],
      1.0: [
        'Terrible! Complete waste of money.',
        'Awful quality, returning immediately.',
        'Do not buy this!',
        'Worst purchase ever.',
        'Completely unsatisfied.',
      ],
    };

    final ratingKey = roundedRating.round().toDouble();
    final comment = random.element(comments[ratingKey] ?? comments[3.0]!);

    return {
      'rating': roundedRating,
      'comment': comment,
      'helpful': random.integer(min: 0, max: 100),
      'verified': random.boolean(probability: 0.8),
      'date': DateTime.now()
          .subtract(Duration(days: random.integer(min: 1, max: 365))),
    };
  }

  /// Generates a shopping cart.
  ///
  /// Returns a list of cart items with products and quantities.
  List<Map<String, dynamic>> cart({int items = 3}) {
    final products = [
      {
        'name': 'Wireless Headphones',
        'price': 79.99,
        'category': 'Electronics'
      },
      {'name': 'Smart Watch', 'price': 299.99, 'category': 'Electronics'},
      {'name': 'Running Shoes', 'price': 89.99, 'category': 'Sports'},
      {'name': 'Yoga Mat', 'price': 29.99, 'category': 'Sports'},
      {'name': 'Coffee Maker', 'price': 149.99, 'category': 'Home'},
      {'name': 'Blender', 'price': 69.99, 'category': 'Kitchen'},
      {'name': 'Backpack', 'price': 49.99, 'category': 'Travel'},
      {'name': 'Water Bottle', 'price': 24.99, 'category': 'Sports'},
      {'name': 'Bluetooth Speaker', 'price': 59.99, 'category': 'Electronics'},
      {'name': 'Phone Case', 'price': 19.99, 'category': 'Accessories'},
      {'name': 'USB Cable', 'price': 9.99, 'category': 'Electronics'},
      {'name': 'Notebook', 'price': 14.99, 'category': 'Stationery'},
      {'name': 'T-Shirt', 'price': 29.99, 'category': 'Clothing'},
      {'name': 'Jeans', 'price': 79.99, 'category': 'Clothing'},
      {'name': 'Sunglasses', 'price': 99.99, 'category': 'Accessories'},
    ];

    final selectedProducts = <Map<String, dynamic>>[];
    final usedProducts = <String>{};

    for (int i = 0; i < items && i < products.length; i++) {
      Map<String, dynamic> product;
      do {
        product = random.element(products);
      } while (usedProducts.contains(product['name']));

      usedProducts.add(product['name'] as String);

      selectedProducts.add({
        'product': product['name'],
        'category': product['category'],
        'price': product['price'],
        'quantity': random.integer(min: 1, max: 5),
        'subtotal':
            (product['price'] as double) * random.integer(min: 1, max: 5),
      });
    }

    return selectedProducts;
  }

  /// Generates an invoice number.
  String invoiceNumber() {
    final year = DateTime.now().year;
    final month = DateTime.now().month.toString().padLeft(2, '0');
    final sequence = random.integer(min: 1000, max: 9999);

    return random.element([
      'INV-$year$month-$sequence',
      'INV-${random.integer(min: 100000, max: 999999)}',
      'INVOICE-${random.alphanumeric(8).toUpperCase()}',
      '#INV$year$sequence',
    ]);
  }

  /// Generates a SKU (Stock Keeping Unit).
  String sku() {
    final formats = [
      () =>
          '${random.alphanumeric(3).toUpperCase()}-${random.integer(min: 1000, max: 9999)}',
      () => '${random.element([
                'PROD',
                'ITEM',
                'SKU'
              ])}-${random.integer(min: 100000, max: 999999)}',
      () => random.alphanumeric(10).toUpperCase(),
      () => '${random.integer(min: 10000000, max: 99999999)}',
    ];

    return random.element(formats)();
  }

  /// Generates a warehouse location.
  String warehouseLocation() {
    final zone = random.element(['A', 'B', 'C', 'D', 'E', 'F']);
    final row = random.integer(min: 1, max: 50);
    final shelf = random.integer(min: 1, max: 10);
    final bin = random.integer(min: 1, max: 20);

    return '$zone-$row-$shelf-$bin';
  }

  /// Generates inventory status.
  String inventoryStatus() {
    final statuses = {
      'en_US': [
        'In Stock',
        'Out of Stock',
        'Low Stock',
        'Pre-order',
        'Backordered',
        'Discontinued',
        'Limited Edition',
        'Coming Soon',
      ],
      'zh_TW': [
        '有現貨',
        '缺貨',
        '庫存不足',
        '預購',
        '延期交貨',
        '已停產',
        '限量版',
        '即將上市',
      ],
      'ja_JP': [
        '在庫あり',
        '在庫切れ',
        '在庫僅か',
        '予約注文',
        '取り寄せ',
        '販売終了',
        '限定版',
        '近日発売',
      ],
    };

    final locale = localeManager.currentLocale;
    return random.element(statuses[locale] ?? statuses['en_US']!);
  }

  /// Generates a return reason.
  String returnReason() {
    return random.element([
      'Defective product',
      'Wrong item received',
      'Not as described',
      'No longer needed',
      'Found better price',
      'Ordered by mistake',
      'Arrived too late',
      'Damaged in shipping',
      'Quality not as expected',
      'Size/fit issues',
    ]);
  }

  /// Generates a discount percentage.
  int discountPercentage() {
    final discounts = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 75, 80];
    return random.element(discounts);
  }

  /// Generates shipping cost.
  double shippingCost() {
    final isFree = random.boolean(probability: 0.3);
    if (isFree) return 0.0;

    return random.decimal(min: 4.99, max: 29.99);
  }

  /// Generates an estimated delivery date.
  DateTime estimatedDelivery() {
    final daysToAdd = random.integer(min: 2, max: 14);
    return DateTime.now().add(Duration(days: daysToAdd));
  }

  /// Generates a customer tier.
  String customerTier() {
    final tiers = {
      'en_US': [
        'Bronze',
        'Silver',
        'Gold',
        'Platinum',
        'Diamond',
        'VIP',
        'Premium',
        'Elite',
      ],
      'zh_TW': [
        '青銅',
        '白銀',
        '黃金',
        '白金',
        '鑽石',
        'VIP',
        '高級',
        '菁英',
      ],
      'ja_JP': [
        'ブロンズ',
        'シルバー',
        'ゴールド',
        'プラチナ',
        'ダイヤモンド',
        'VIP',
        'プレミアム',
        'エリート',
      ],
    };

    final locale = localeManager.currentLocale;
    return random.element(tiers[locale] ?? tiers['en_US']!);
  }

  /// Generates loyalty points.
  int loyaltyPoints() {
    return random.integer(min: 0, max: 10000);
  }

  /// Generates a gift card code.
  String giftCardCode() {
    final code = random.alphanumeric(16).toUpperCase();
    // Format as XXXX-XXXX-XXXX-XXXX
    return '${code.substring(0, 4)}-${code.substring(4, 8)}-${code.substring(8, 12)}-${code.substring(12, 16)}';
  }

  /// Generates a wishlist.
  List<String> wishlist({int items = 5}) {
    final products = [
      'Laptop',
      'Smartphone',
      'Tablet',
      'Smart TV',
      'Gaming Console',
      'Camera',
      'Drone',
      'Smart Home Hub',
      'Fitness Tracker',
      'Wireless Earbuds',
      'Electric Scooter',
      'Coffee Machine',
      'Air Fryer',
      'Robot Vacuum',
      'Standing Desk',
    ];

    final wishlist = <String>{};
    while (wishlist.length < items && wishlist.length < products.length) {
      wishlist.add(random.element(products));
    }

    return wishlist.toList();
  }
}
