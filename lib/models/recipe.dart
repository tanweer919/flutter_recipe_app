import 'package:dekorner_recipe/models/category.dart';
import 'package:dekorner_recipe/models/recipe_ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final int noOfServings;
  final String servingSize;
  final List<String> instructions;
  final String cookTime;
  final String prepTime;
  final String totalTime;
  final double calories;
  final double fatContent;
  final double saturatedFatContent;
  final double cholesterolContent;
  final double carbohydrateContent;
  final double proteinContent;
  final double fiberContent;
  final double sugarContent;
  final List<RecipeIngredient> ingredients;
  final List<String> images;
  final List<Category> categories;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.noOfServings,
    required this.cookTime,
    required this.prepTime,
    required this.totalTime,
    required this.ingredients,
    required this.images,
    required this.categories,
    required this.calories,
    required this.fatContent,
    required this.saturatedFatContent,
    required this.cholesterolContent,
    required this.carbohydrateContent,
    required this.proteinContent,
    required this.fiberContent,
    required this.sugarContent,
    required this.instructions,
    required this.servingSize,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: (json['name'] as String).replaceAll('&amp;', '&'),
      description: json['description'],
      noOfServings: json['no_of_servings'],
      cookTime: json['cook_time'],
      prepTime: json['prep_time'],
      totalTime: json['total_time'],
      ingredients: (json['ingredients'] as List)
          .map((i) => RecipeIngredient.fromJson(i))
          .toList(),
      images: (json['images'] as List)
          .map((image) => image["image_url"] as String)
          .toList(),
      categories: (json['search_terms'] as List)
          .map((category) => Category.fromJson(category['search']))
          .toList(),
      calories: json['calories'],
      fatContent: json['fat_content'],
      saturatedFatContent: json['saturatedFat_content'],
      cholesterolContent: json['cholesterol_content'],
      carbohydrateContent: json['carbohydrate_content'],
      proteinContent: json['protein_content'],
      fiberContent: json['fiber_content'],
      sugarContent: json['sugar_content'],
      instructions: (json['instructions'] as String).split('\n'),
      servingSize: json['serving_size'],
    );
  }
}
