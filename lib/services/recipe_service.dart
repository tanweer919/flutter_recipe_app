import 'package:dekorner_recipe/models/category.dart';
import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/recipe_filter.dart';
import 'package:dekorner_recipe/models/search_recipe.dart';
import 'package:dekorner_recipe/models/food_classification.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/services/http_service.dart';
import 'package:dio/dio.dart';

class RecipeService {
  HttpService httpService = locator<HttpService>();

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

  Future<List<Recipe>> getRecipesByFilters(List<RecipeFilter> filters,
      {int? page}) async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient.get(
        'api/filter/?${filters.map((filter) => 'filterIds=${filter.id}').join('&')}${page != null ? '&page=$page' : ''}');
    final recipes = (response.data["results"] as List<dynamic>)
        .map((recipe) => Recipe.fromJson(recipe))
        .toList();
    return recipes;
  }

  Future<List<Recipe>> getPopularRecipes({int? page}) async {
    final httpClient = await httpService.getApiClient();
    final response = await httpClient
        .get('api/recipes/popular/${page != null ? '?page=$page' : ''}');
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

  Future<void> addRecipeToFavorites(int recipeId) async {
    try {
      final httpClient = await httpService.getAuthenticatedApiClient();
      final response = await httpClient
          .post('api/recipes/save/', data: {"recipe_id": recipeId});
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to add recipe to favorites');
      }
    } catch (error) {
      throw Exception('Failed to add recipe to favorites');
    }
  }

  Future<void> removeRecipeFromFavorites(int recipeId) async {
    try {
      final httpClient = await httpService.getAuthenticatedApiClient();
      final response = await httpClient
          .post('api/recipes/unsave/', data: {"recipe_id": recipeId});
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to remove recipe to favorites');
      }
    } catch (error) {
      throw Exception('Failed to remove recipe to favorites');
    }
  }

  Future<void> addRecipeToCookingHistory(int recipeId) async {
    try {
      final httpClient = await httpService.getAuthenticatedApiClient();
      final response = await httpClient
          .post('api/recipes/add-to-history/', data: {"recipe_id": recipeId});
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to add recipe to cooking history');
      }
    } catch (error) {
      throw Exception('Failed to add recipe to cooking history');
    }
  }

  Future<FoodClassificationResponse> classifyFoodImage(String imagePath) async {
    try {
      final httpClient = await httpService.getAuthenticatedApiClient();
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await httpClient.post(
        'api/predict/',
        data: formData,
      );

      return FoodClassificationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to classify food image: $e');
    }
  }

  Future<String> sendAICookingChatMessage(String message) async {
    try {
      final httpClient = await httpService.getApiClient();
      final formData = FormData.fromMap({
        'query': message,
      });
      final response = await httpClient.post(
        'api/predict/',
        data: formData,
      );
      if (response.statusCode == 200 && response.data != null) {
        // Adjust this if the response structure is different
        return response.data['response'] ?? response.data.toString();
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      throw Exception('Failed to send message to AI: $e');
    }
  }
}
