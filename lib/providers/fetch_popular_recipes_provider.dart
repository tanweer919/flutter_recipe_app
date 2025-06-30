import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/services/recipe_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'fetch_popular_recipes_provider.g.dart';

@riverpod
Future<List<Recipe>> fetchPopularRecipes(FetchPopularRecipesRef ref, int page) {
  final recipeService = locator<RecipeService>();
  return recipeService.getPopularRecipes(page: page);
}
