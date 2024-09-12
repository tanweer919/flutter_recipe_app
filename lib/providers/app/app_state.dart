import 'package:dekorner_recipe/models/category.dart';
import 'package:dekorner_recipe/models/recipe.dart';
import 'package:optional/optional.dart';

class AppState {
  final List<Recipe>? recipes;
  final List<Category>? homeCategories;

  AppState({this.recipes, this.homeCategories});

  AppState copyWith(
      {Optional<List<Recipe>?>? recipes,
      Optional<List<Category>?>? homeCategories}) {
    return AppState(
      recipes: recipes != null ? recipes.orElseNull : this.recipes,
      homeCategories: homeCategories != null
          ? homeCategories.orElseNull
          : this.homeCategories,
    );
  }
}
