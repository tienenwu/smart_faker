import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class FoodGeneratorScreen extends StatefulWidget {
  const FoodGeneratorScreen({super.key});

  @override
  State<FoodGeneratorScreen> createState() => _FoodGeneratorScreenState();
}

class _FoodGeneratorScreenState extends State<FoodGeneratorScreen> {
  late SmartFaker faker;
  final Map<String, String> _values = {};

  @override
  void initState() {
    super.initState();
    faker = SmartFaker();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      _values['Dish'] = faker.food.dish();
      _values['Ingredient'] = faker.food.ingredient();
      _values['Cuisine'] = faker.food.cuisine();
      _values['Fruit'] = faker.food.fruit();
      _values['Vegetable'] = faker.food.vegetable();
      _values['Meat'] = faker.food.meat();
      _values['Spice'] = faker.food.spice();
      _values['Cooking Method'] = faker.food.cookingMethod();
      _values['Meal Type'] = faker.food.mealType();
      _values['Restaurant Name'] = faker.food.restaurantName();
      _values['Restaurant Type'] = faker.food.restaurantType();
      _values['Beverage'] = faker.food.beverage();
      _values['Dessert'] = faker.food.dessert();
      _values['Recipe'] = faker.food.recipeName();
    });
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateAll,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _values.entries
            .map((entry) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text(
                      entry.value,
                      style: const TextStyle(fontFamily: 'monospace'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () => _copyToClipboard(entry.value),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
