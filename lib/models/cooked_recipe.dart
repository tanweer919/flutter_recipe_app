import 'package:dekorner_recipe/models/recipe.dart';

class CookedRecipe {
  final Recipe recipe;
  final String cookTime;

  CookedRecipe({
    required this.recipe,
    required this.cookTime,
  });

  factory CookedRecipe.fromJson(Map<String, dynamic> json) {
    return CookedRecipe(
      recipe: Recipe.fromJson(json['recipe']),
      cookTime: json['cooked_at'],
    );
  }
}