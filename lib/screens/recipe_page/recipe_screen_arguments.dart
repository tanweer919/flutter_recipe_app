import 'package:dekorner_recipe/models/recipe.dart';

class RecipeScreenArguments {
  final Recipe? recipe;
  final int? recipeId;
  const RecipeScreenArguments({
    this.recipe,
    this.recipeId,
  });
}