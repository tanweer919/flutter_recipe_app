import 'package:dekorner_recipe/models/ingredient.dart';

class RecipeIngredient {
  final int id;
  final String ingredientText;
  final Ingredient ingredient;
  final String? quantity;

  RecipeIngredient({
    required this.id,
    required this.ingredient,
    required this.ingredientText,
    this.quantity,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    final res = extractQuantityAndIngredient(json['ingredient_quantity']);
    return RecipeIngredient(
      id: json['id'],
      ingredient: Ingredient.fromJson(json['ingredient']),
      ingredientText: res.$1,
      quantity: res.$2,
    );
  }
}

(String, String?) extractQuantityAndIngredient(String sentence) {
  final match =
      RegExp(r'^([-+]?\d*\.?\d+(?:/\d+)?)\s*(.*)$').firstMatch(sentence.trim());
  if (match != null) {
    final number = match.group(1)!;
    final remainingText = match.group(2)!;
    return (remainingText, number);
  }
  return (sentence, null);
}
