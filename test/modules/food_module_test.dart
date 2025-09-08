import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('FoodModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Food Items', () {
      test('should generate dish name', () {
        final dish = faker.food.dish();
        expect(dish, isNotEmpty);
      });

      test('should generate ingredient', () {
        final ingredient = faker.food.ingredient();
        expect(ingredient, isNotEmpty);
      });

      test('should generate fruit', () {
        final fruit = faker.food.fruit();
        expect(fruit, isNotEmpty);
      });

      test('should generate vegetable', () {
        final vegetable = faker.food.vegetable();
        expect(vegetable, isNotEmpty);
      });

      test('should generate meat', () {
        final meat = faker.food.meat();
        expect(meat, isNotEmpty);
      });

      test('should generate seafood', () {
        final seafood = faker.food.seafood();
        expect(seafood, isNotEmpty);
      });

      test('should generate dairy product', () {
        final dairy = faker.food.dairy();
        expect(dairy, isNotEmpty);
      });

      test('should generate grain', () {
        final grain = faker.food.grain();
        expect(grain, isNotEmpty);
      });

      test('should generate spice', () {
        final spice = faker.food.spice();
        expect(spice, isNotEmpty);
      });

      test('should generate dessert', () {
        final dessert = faker.food.dessert();
        expect(dessert, isNotEmpty);
      });

      test('should generate beverage', () {
        final beverage = faker.food.beverage();
        expect(beverage, isNotEmpty);
      });

      test('should generate alcoholic beverage', () {
        final alcohol = faker.food.alcohol();
        expect(alcohol, isNotEmpty);
      });
    });

    group('Food Categories', () {
      test('should generate cuisine type', () {
        final cuisine = faker.food.cuisine();
        expect(cuisine, isNotEmpty);
      });

      test('should generate meal type', () {
        final meal = faker.food.mealType();
        expect(['breakfast', 'brunch', 'lunch', 'dinner', 'snack', 'dessert'],
            contains(meal));
      });

      test('should generate cooking method', () {
        final method = faker.food.cookingMethod();
        expect(method, isNotEmpty);
      });

      test('should generate taste', () {
        final taste = faker.food.taste();
        expect(['sweet', 'sour', 'salty', 'bitter', 'umami', 'spicy', 'savory'],
            contains(taste));
      });

      test('should generate texture', () {
        final texture = faker.food.texture();
        expect(texture, isNotEmpty);
      });

      test('should generate temperature', () {
        final temp = faker.food.temperature();
        expect(['hot', 'warm', 'room temperature', 'cold', 'frozen'],
            contains(temp));
      });
    });

    group('Restaurant', () {
      test('should generate restaurant name', () {
        final name = faker.food.restaurantName();
        expect(name, isNotEmpty);
      });

      test('should generate restaurant type', () {
        final type = faker.food.restaurantType();
        expect(type, isNotEmpty);
      });

      test('should generate menu item', () {
        final item = faker.food.menuItem();
        expect(item, isNotEmpty);
        expect(item, contains(r'$'));
      });

      test('should generate menu description', () {
        final desc = faker.food.menuDescription();
        expect(desc, isNotEmpty);
      });
    });

    group('Nutrition', () {
      test('should generate calories', () {
        final calories = faker.food.calories();
        expect(calories, matches(RegExp(r'^\d{1,4} cal$')));
      });

      test('should generate serving size', () {
        final serving = faker.food.servingSize();
        expect(serving, isNotEmpty);
      });

      test('should generate dietary restriction', () {
        final diet = faker.food.dietaryRestriction();
        expect([
          'vegetarian',
          'vegan',
          'gluten-free',
          'dairy-free',
          'nut-free',
          'kosher',
          'halal',
          'low-carb',
          'keto',
          'paleo'
        ], contains(diet));
      });

      test('should generate allergen', () {
        final allergen = faker.food.allergen();
        expect([
          'milk',
          'eggs',
          'fish',
          'shellfish',
          'tree nuts',
          'peanuts',
          'wheat',
          'soybeans',
          'sesame'
        ], contains(allergen));
      });
    });

    group('Recipe', () {
      test('should generate recipe name', () {
        final recipe = faker.food.recipeName();
        expect(recipe, isNotEmpty);
      });

      test('should generate cooking time', () {
        final time = faker.food.cookingTime();
        expect(time, matches(RegExp(r'^\d{1,3} (minutes?|hours?)$')));
      });

      test('should generate difficulty level', () {
        final difficulty = faker.food.difficulty();
        expect(['easy', 'medium', 'hard', 'expert'], contains(difficulty));
      });

      test('should generate serving count', () {
        final servings = faker.food.servings();
        expect(servings, matches(RegExp(r'^Serves \d{1,2}$')));
      });

      test('should generate ingredient list', () {
        final ingredients = faker.food.ingredientList();
        expect(ingredients, isNotEmpty);
        expect(ingredients.length, greaterThanOrEqualTo(3));
        expect(ingredients.length, lessThanOrEqualTo(10));
      });

      test('should generate cooking instruction', () {
        final instruction = faker.food.instruction();
        expect(instruction, isNotEmpty);
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English food names', () {
        final faker = SmartFaker(locale: 'en_US');
        final dish = faker.food.dish();
        expect(dish, isNotEmpty);
      });

      test('should generate Traditional Chinese food names', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final dish = faker.food.dish();
        expect(dish, isNotEmpty);
      });

      test('should generate Japanese food names', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final dish = faker.food.dish();
        expect(dish, isNotEmpty);
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible food data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.food.dish(), equals(faker2.food.dish()));
        expect(faker1.food.ingredient(), equals(faker2.food.ingredient()));
        expect(
            faker1.food.restaurantName(), equals(faker2.food.restaurantName()));
      });
    });
  });
}
