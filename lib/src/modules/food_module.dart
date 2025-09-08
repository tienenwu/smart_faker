import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating food-related data.
class FoodModule {
  final RandomGenerator random;
  final LocaleManager localeManager;

  FoodModule(this.random, this.localeManager);

  String get currentLocale => localeManager.currentLocale;

  /// Generates a dish name based on locale.
  String dish() {
    switch (currentLocale) {
      case 'zh_TW':
        return random.element(_taiwaneseDishes);
      case 'ja_JP':
        return random.element(_japaneseDishes);
      default:
        return random.element(_dishes);
    }
  }

  /// Generates an ingredient name.
  String ingredient() {
    return random.element(_ingredients);
  }

  /// Generates a fruit name.
  String fruit() {
    return random.element(_fruits);
  }

  /// Generates a vegetable name.
  String vegetable() {
    return random.element(_vegetables);
  }

  /// Generates a meat type.
  String meat() {
    return random.element(_meats);
  }

  /// Generates a seafood type.
  String seafood() {
    return random.element(_seafood);
  }

  /// Generates a dairy product.
  String dairy() {
    return random.element(_dairy);
  }

  /// Generates a grain type.
  String grain() {
    return random.element(_grains);
  }

  /// Generates a spice name.
  String spice() {
    return random.element(_spices);
  }

  /// Generates a dessert name.
  String dessert() {
    switch (currentLocale) {
      case 'zh_TW':
        return random.element(_taiwaneseDesserts);
      case 'ja_JP':
        return random.element(_japaneseDesserts);
      default:
        return random.element(_desserts);
    }
  }

  /// Generates a beverage name.
  String beverage() {
    return random.element(_beverages);
  }

  /// Generates an alcoholic beverage name.
  String alcohol() {
    return random.element(_alcoholicBeverages);
  }

  /// Generates a cuisine type.
  String cuisine() {
    return random.element(_cuisines);
  }

  /// Generates a meal type.
  String mealType() {
    return random.element(['breakfast', 'brunch', 'lunch', 'dinner', 'snack', 'dessert']);
  }

  /// Generates a cooking method.
  String cookingMethod() {
    return random.element(_cookingMethods);
  }

  /// Generates a taste description.
  String taste() {
    return random.element(['sweet', 'sour', 'salty', 'bitter', 'umami', 'spicy', 'savory']);
  }

  /// Generates a texture description.
  String texture() {
    return random.element(_textures);
  }

  /// Generates a temperature description.
  String temperature() {
    return random.element(['hot', 'warm', 'room temperature', 'cold', 'frozen']);
  }

  /// Generates a restaurant name.
  String restaurantName() {
    final prefix = random.element(['The', 'Le', 'La', 'Il', 'El', '']);
    final type = random.element(['Kitchen', 'Bistro', 'Cafe', 'Restaurant', 'Grill', 'House', 'Place', 'Table']);
    final name = random.element(['Golden', 'Silver', 'Royal', 'Grand', 'Little', 'Big', 'Happy', 'Lucky']);
    
    if (prefix.isEmpty) {
      return '$name $type';
    }
    return '$prefix $name $type';
  }

  /// Generates a restaurant type.
  String restaurantType() {
    return random.element(_restaurantTypes);
  }

  /// Generates a menu item with price.
  String menuItem() {
    final item = dish();
    final price = random.integer(min: 8, max: 45);
    return '$item - \$$price.99';
  }

  /// Generates a menu description.
  String menuDescription() {
    final method = cookingMethod();
    final ingredient1 = ingredient();
    final ingredient2 = ingredient();
    final texture = this.texture();
    
    return 'Deliciously $method with fresh $ingredient1 and $ingredient2, creating a $texture experience';
  }

  /// Generates calorie count.
  String calories() {
    final cal = random.integer(min: 50, max: 1200);
    return '$cal cal';
  }

  /// Generates a serving size.
  String servingSize() {
    final sizes = [
      '1 cup', '1/2 cup', '1/4 cup',
      '100g', '150g', '200g', '250g',
      '1 piece', '2 pieces', '3 pieces',
      '1 serving', '1 portion',
      '1 bowl', '1 plate',
    ];
    return random.element(sizes);
  }

  /// Generates a dietary restriction.
  String dietaryRestriction() {
    return random.element([
      'vegetarian', 'vegan', 'gluten-free', 'dairy-free',
      'nut-free', 'kosher', 'halal', 'low-carb', 'keto', 'paleo'
    ]);
  }

  /// Generates an allergen.
  String allergen() {
    return random.element([
      'milk', 'eggs', 'fish', 'shellfish', 'tree nuts',
      'peanuts', 'wheat', 'soybeans', 'sesame'
    ]);
  }

  /// Generates a recipe name.
  String recipeName() {
    final style = random.element(['Classic', 'Homemade', 'Traditional', 'Modern', 'Easy', 'Quick']);
    final mainDish = dish();
    return '$style $mainDish';
  }

  /// Generates cooking time.
  String cookingTime() {
    final time = random.element([15, 20, 25, 30, 45, 60, 90, 120]);
    if (time < 60) {
      return '$time minutes';
    } else {
      final hours = time ~/ 60;
      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    }
  }

  /// Generates difficulty level.
  String difficulty() {
    return random.element(['easy', 'medium', 'hard', 'expert']);
  }

  /// Generates serving count.
  String servings() {
    final count = random.integer(min: 2, max: 8);
    return 'Serves $count';
  }

  /// Generates a list of ingredients.
  List<String> ingredientList() {
    final count = random.integer(min: 3, max: 10);
    final ingredients = <String>{};
    
    while (ingredients.length < count) {
      ingredients.add(ingredient());
    }
    
    return ingredients.toList();
  }

  /// Generates a cooking instruction.
  String instruction() {
    final action = random.element([
      'Mix', 'Stir', 'Cook', 'Bake', 'Fry', 'Boil', 'Simmer', 'Grill', 'Roast'
    ]);
    final duration = random.integer(min: 5, max: 30);
    final temp = random.element(['low', 'medium', 'high']);
    
    return '$action on $temp heat for $duration minutes until golden brown';
  }

  static final List<String> _dishes = [
    'Pasta Carbonara', 'Chicken Tikka Masala', 'Beef Bourguignon', 'Pad Thai',
    'Sushi Roll', 'Pizza Margherita', 'Fish and Chips', 'Tacos al Pastor',
    'Ramen', 'Paella', 'Hamburger', 'Caesar Salad', 'Tom Yum Soup',
    'Butter Chicken', 'Beef Stroganoff', 'Lasagna', 'Pho', 'Bibimbap',
    'Moussaka', 'Falafel', 'Chicken Parmesan', 'Beef Wellington',
    'Lobster Thermidor', 'Duck Confit', 'Coq au Vin', 'Chicken Satay',
  ];

  static final List<String> _taiwaneseDishes = [
    '牛肉麵', '滷肉飯', '小籠包', '珍珠奶茶', '臭豆腐', '蚵仔煎',
    '雞排', '肉圓', '擔仔麵', '鹽酥雞', '蔥油餅', '刈包',
    '魯肉飯', '炒米粉', '大腸包小腸', '三杯雞', '宮保雞丁',
  ];

  static final List<String> _japaneseDishes = [
    '寿司', 'ラーメン', '天ぷら', '刺身', 'うどん', 'そば',
    'カレーライス', '親子丼', 'とんかつ', 'お好み焼き', 'たこ焼き',
    '味噌汁', '焼き鳥', '牛丼', 'ちらし寿司', 'かつ丼',
  ];

  static final List<String> _ingredients = [
    'tomato', 'onion', 'garlic', 'olive oil', 'salt', 'pepper', 'basil',
    'oregano', 'thyme', 'rosemary', 'parsley', 'cilantro', 'ginger',
    'soy sauce', 'vinegar', 'honey', 'butter', 'cream', 'cheese', 'milk',
    'flour', 'sugar', 'eggs', 'chicken', 'beef', 'pork', 'fish',
    'shrimp', 'rice', 'pasta', 'potato', 'carrot', 'celery', 'mushroom',
  ];

  static final List<String> _fruits = [
    'apple', 'banana', 'orange', 'strawberry', 'grape', 'watermelon',
    'mango', 'pineapple', 'peach', 'pear', 'cherry', 'blueberry',
    'raspberry', 'blackberry', 'kiwi', 'papaya', 'pomegranate', 'plum',
    'apricot', 'cantaloupe', 'honeydew', 'coconut', 'lime', 'lemon',
    'grapefruit', 'dragonfruit', 'passion fruit', 'lychee', 'durian',
  ];

  static final List<String> _vegetables = [
    'carrot', 'broccoli', 'spinach', 'tomato', 'cucumber', 'lettuce',
    'bell pepper', 'onion', 'garlic', 'potato', 'sweet potato', 'corn',
    'peas', 'green beans', 'cauliflower', 'zucchini', 'eggplant',
    'asparagus', 'celery', 'kale', 'cabbage', 'brussels sprouts',
    'artichoke', 'radish', 'beet', 'turnip', 'squash', 'pumpkin',
  ];

  static final List<String> _meats = [
    'chicken breast', 'chicken thigh', 'chicken wing', 'beef sirloin',
    'beef ribeye', 'ground beef', 'pork chop', 'pork tenderloin',
    'bacon', 'ham', 'lamb chop', 'duck breast', 'turkey breast',
    'veal cutlet', 'venison', 'rabbit', 'quail', 'sausage',
  ];

  static final List<String> _seafood = [
    'salmon', 'tuna', 'cod', 'halibut', 'sea bass', 'trout', 'mackerel',
    'sardines', 'shrimp', 'lobster', 'crab', 'scallops', 'oysters',
    'mussels', 'clams', 'squid', 'octopus', 'anchovies', 'prawns',
  ];

  static final List<String> _dairy = [
    'milk', 'cheese', 'yogurt', 'butter', 'cream', 'sour cream',
    'cottage cheese', 'cream cheese', 'mozzarella', 'cheddar', 'parmesan',
    'swiss cheese', 'blue cheese', 'feta', 'ricotta', 'goat cheese',
    'ice cream', 'whipped cream', 'buttermilk', 'condensed milk',
  ];

  static final List<String> _grains = [
    'rice', 'wheat', 'oats', 'barley', 'quinoa', 'corn', 'millet',
    'buckwheat', 'rye', 'spelt', 'amaranth', 'teff', 'sorghum',
    'wild rice', 'brown rice', 'white rice', 'basmati rice', 'jasmine rice',
  ];

  static final List<String> _spices = [
    'salt', 'black pepper', 'paprika', 'cumin', 'coriander', 'turmeric',
    'cinnamon', 'nutmeg', 'cloves', 'cardamom', 'star anise', 'fennel',
    'mustard seeds', 'fenugreek', 'saffron', 'vanilla', 'chili powder',
    'cayenne', 'oregano', 'basil', 'thyme', 'rosemary', 'sage', 'bay leaf',
  ];

  static final List<String> _desserts = [
    'Chocolate Cake', 'Cheesecake', 'Tiramisu', 'Ice Cream Sundae',
    'Apple Pie', 'Brownies', 'Cookies', 'Crème Brûlée', 'Panna Cotta',
    'Macarons', 'Donuts', 'Cupcakes', 'Fruit Tart', 'Mousse', 'Soufflé',
    'Baklava', 'Cannoli', 'Éclair', 'Profiteroles', 'Churros',
  ];

  static final List<String> _taiwaneseDesserts = [
    '鳳梨酥', '太陽餅', '綠豆糕', '芋頭酥', '蛋黃酥', '豆花',
    '愛玉', '仙草', '芒果冰', '紅豆湯', '湯圓', '麻糬',
  ];

  static final List<String> _japaneseDesserts = [
    'もち', 'どら焼き', 'たい焼き', '大福', 'だんご', 'ようかん',
    'カステラ', '抹茶アイス', 'あんみつ', 'ぜんざい', 'おはぎ',
  ];

  static final List<String> _beverages = [
    'Coffee', 'Tea', 'Orange Juice', 'Apple Juice', 'Lemonade',
    'Iced Tea', 'Hot Chocolate', 'Smoothie', 'Milkshake', 'Soda',
    'Sparkling Water', 'Energy Drink', 'Sports Drink', 'Coconut Water',
    'Kombucha', 'Bubble Tea', 'Matcha Latte', 'Cappuccino', 'Espresso',
  ];

  static final List<String> _alcoholicBeverages = [
    'Beer', 'Wine', 'Whiskey', 'Vodka', 'Rum', 'Gin', 'Tequila',
    'Champagne', 'Martini', 'Margarita', 'Mojito', 'Cosmopolitan',
    'Bloody Mary', 'Piña Colada', 'Daiquiri', 'Manhattan', 'Old Fashioned',
    'Negroni', 'Aperol Spritz', 'Sake', 'Soju', 'Brandy', 'Cognac',
  ];

  static final List<String> _cuisines = [
    'Italian', 'French', 'Chinese', 'Japanese', 'Thai', 'Indian',
    'Mexican', 'Spanish', 'Greek', 'Turkish', 'Lebanese', 'Moroccan',
    'Vietnamese', 'Korean', 'American', 'Brazilian', 'Peruvian',
    'Ethiopian', 'German', 'British', 'Russian', 'Indonesian',
  ];

  static final List<String> _cookingMethods = [
    'grilled', 'roasted', 'baked', 'fried', 'steamed', 'boiled',
    'sautéed', 'braised', 'poached', 'smoked', 'barbecued', 'stir-fried',
    'deep-fried', 'pan-fried', 'blanched', 'simmered', 'caramelized',
  ];

  static final List<String> _textures = [
    'crispy', 'crunchy', 'soft', 'tender', 'chewy', 'fluffy', 'creamy',
    'smooth', 'silky', 'velvety', 'flaky', 'moist', 'juicy', 'firm',
    'delicate', 'dense', 'light', 'airy', 'sticky', 'gooey',
  ];

  static final List<String> _restaurantTypes = [
    'Fast Food', 'Casual Dining', 'Fine Dining', 'Buffet', 'Café',
    'Bistro', 'Steakhouse', 'Seafood Restaurant', 'Pizzeria', 'Bakery',
    'Food Truck', 'Diner', 'Pub', 'Bar & Grill', 'Sushi Bar',
    'Ramen Shop', 'Taco Stand', 'BBQ Joint', 'Sandwich Shop', 'Deli',
  ];
}