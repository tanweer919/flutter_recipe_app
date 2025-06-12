import 'package:dekorner_recipe/models/recipe.dart';

class FoodClassificationResponse {
  final bool success;
  final Recipe recipe;

  FoodClassificationResponse({
    required this.success,
    required this.recipe,
  });

  factory FoodClassificationResponse.fromJson(Map<String, dynamic> json) {
    return FoodClassificationResponse(
      success: json['success'],
      recipe: Recipe.fromJson(json['recipe']),
    );
  }
}
