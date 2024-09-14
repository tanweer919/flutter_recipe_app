import 'package:dekorner_recipe/models/category.dart';
import 'package:dekorner_recipe/models/recipe.dart';
import 'package:optional/optional.dart';

class AppState {
  final List<Recipe>? recipes;
  final List<Recipe>? popularRecipes;
  final List<Category>? homeCategories;

  AppState({this.recipes, this.homeCategories, this.popularRecipes});

  AppState copyWith(
      {Optional<List<Recipe>?>? recipes,
      Optional<List<Category>?>? homeCategories,
      Optional<List<Recipe>?>? popularRecipes,
  }) {
    return AppState(
      recipes: recipes != null ? recipes.orElseNull : this.recipes,
      popularRecipes: popularRecipes != null ? popularRecipes.orElseNull : this.popularRecipes,
      homeCategories: homeCategories != null
          ? homeCategories.orElseNull
          : this.homeCategories,
    );
  }
}
