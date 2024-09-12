import 'package:dekorner_recipe/models/ingredient.dart';

class RecipeIngredient {
  final int id;
  final String ingredientQuantity;
  final Ingredient ingredient;

  RecipeIngredient({
    required this.id,
    required this.ingredient,
    required this.ingredientQuantity,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'],
      ingredient: Ingredient.fromJson(json['ingredient']),
      ingredientQuantity: json['ingredient_quantity'],
    );
  }
}
