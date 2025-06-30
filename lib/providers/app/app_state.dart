import 'package:dekorner_recipe/models/category.dart';
import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/user.dart';
import 'package:optional/optional.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AppState {
  final bottomNavbarIndex;
  final AsyncValue<User?> user;
  final List<Recipe>? recipes;
  final List<Recipe>? popularRecipes;
  final List<Category>? homeCategories;

  AppState({
    this.bottomNavbarIndex = 0,
    this.user = const AsyncValue.loading(),
    this.recipes,
    this.homeCategories,
    this.popularRecipes,
  });

  AppState copyWith({
    Optional<int>? bottomNavbarIndex,
    AsyncValue<User?>? user,
    Optional<List<Recipe>?>? recipes,
    Optional<List<Category>?>? homeCategories,
    Optional<List<Recipe>?>? popularRecipes,
  }) {
    return AppState(
      bottomNavbarIndex: bottomNavbarIndex != null
          ? bottomNavbarIndex.orElseNull
          : this.bottomNavbarIndex,
      user: user ?? this.user,
      recipes: recipes != null ? recipes.orElseNull : this.recipes,
      popularRecipes: popularRecipes != null
          ? popularRecipes.orElseNull
          : this.popularRecipes,
      homeCategories: homeCategories != null
          ? homeCategories.orElseNull
          : this.homeCategories,
    );
  }
}
