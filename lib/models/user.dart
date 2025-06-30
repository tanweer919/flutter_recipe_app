import 'package:dekorner_recipe/models/cooked_recipe.dart';

import '../models/recipe.dart';

class User {
  final String name;
  final String email;
  final String photoUrl;
  final List<Recipe> favoriteRecipes;
  final List<CookedRecipe> cookingHistory;

  User({
    required this.name,
    required this.email,
    required this.photoUrl,
    this.favoriteRecipes = const [],
    this.cookingHistory = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      photoUrl: json['profile_picture'],
      favoriteRecipes: json['saved_recipes'] != null
          ? (json['saved_recipes'] as List<dynamic>)
              .map((recipe) => Recipe.fromJson(recipe))
              .toList()
          : const [],
      cookingHistory: json['cooking_history'] != null
          ? (json['cooking_history'] as List<dynamic>)
              .map((recipe) => CookedRecipe.fromJson(recipe))
              .toList()
          : const [],
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? photoUrl,
    List<Recipe>? favoriteRecipes,
    List<CookedRecipe>? cookingHistory,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      cookingHistory: cookingHistory ?? this.cookingHistory,
    );
  }
}
