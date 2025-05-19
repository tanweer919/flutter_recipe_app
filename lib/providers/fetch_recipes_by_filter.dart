import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/recipe_filter.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/services/recipe_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'fetch_recipes_by_filter.g.dart';

@riverpod
Future<List<Recipe>> fetchRecipesByFilter(FetchRecipesByFilterRef ref, List<RecipeFilter> filters, int page) {
  final recipeService = locator<RecipeService>();
  return recipeService.getRecipesByFilters(filters, page: page);
}
