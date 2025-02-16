import 'package:dekorner_recipe/models/category.dart';
import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/recipe_filter.dart';
import 'package:dekorner_recipe/models/search_recipe.dart';
import 'package:dekorner_recipe/services/http_service.dart';

class RecipeService {
  HttpService httpService;
  RecipeService({required this.httpService});

  Future<Recipe> getRecipe(int recipeId) async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get('api/recipe/$recipeId/');
    final recipe = Recipe.fromJson(response.data);
    return recipe;
  }

  Future<List<Recipe>> getRecipes() async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get('api/recipes/');
    final recipes = (response.data["results"] as List<dynamic>)
        .map((recipe) => Recipe.fromJson(recipe))
        .toList();
    return recipes;
  }

  Future<List<Recipe>> getRecipesByCategory(int categoryId) async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get('api/recipes/$categoryId/');
    final recipes = (response.data["results"] as List<dynamic>)
        .map((recipe) => Recipe.fromJson(recipe))
        .toList();
    return recipes;
  }

  Future<List<Recipe>> getRecipesByFilters(List<RecipeFilter> filters) async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get('api/filter/?${filters.map((filter) => 'filterIds=${filter.id}').join('&')}');
    final recipes = (response.data["results"] as List<dynamic>)
        .map((recipe) => Recipe.fromJson(recipe))
        .toList();
    return recipes;
  }

  Future<List<Recipe>> getPopularRecipes() async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get('api/recipes/popular/');
    final recipes = (response.data["results"] as List<dynamic>)
        .map((recipe) => Recipe.fromJson(recipe))
        .toList();
    return recipes;
  }

  Future<List<Category>> getCategoriesByType(int typeId) async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get('api/categories/$typeId/');
    final categories = (response.data as List<dynamic>)
        .map((recipe) => Category.fromJson(recipe))
        .toList();
    if (categories.isNotEmpty && categories.first.id == 5) {
      final value = categories.removeAt(0);
      categories.add(value);
    }
    return categories;
  }

  Future<List<SearchRecipe>> searchRecipesByQuery(String query) async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get('api/search/?q=$query');
    final recipes = (response.data["results"] as List<dynamic>)
        .map((recipe) => SearchRecipe.fromJson(recipe))
        .toList();
    return recipes;
  }
}
