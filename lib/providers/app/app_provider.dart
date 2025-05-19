import 'dart:math';

import 'package:dekorner_recipe/models/cooked_recipe.dart';
import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/user.dart';
import 'package:dekorner_recipe/providers/app/app_state.dart';
import 'package:dekorner_recipe/services/auth_service.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/services/local_storage_service.dart';
import 'package:dekorner_recipe/services/recipe_service.dart';
import 'package:optional/optional.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_provider.g.dart';

@riverpod
class AppControl extends _$AppControl {
  final authService = locator<AuthService>();
  final recipeService = locator<RecipeService>();
  final localStorageService = locator<LocalStorageService>();
  @override
  AppState build() {
    _initializeUser();
    return AppState();
  }

  Future<void> _initializeUser() async {
    try {
      final user = await authService.getCurrentUser();
      state = state.copyWith(user: AsyncValue.data(user));
    } catch (e, st) {
      state = state.copyWith(user: AsyncValue.error(e, st));
    }
  }

  void setUser(User? user) {
    state = state.copyWith(user: AsyncValue.data(user));
  }

  Future<void> logout() async {
    await localStorageService.setAuthToken(
      accessToken: null,
      refreshToken: null,
    );
  }

  Future<void> loginWithGoogle() async {
    try {
      final user = await authService.loginWithGoogle();
      state = state.copyWith(user: AsyncValue.data(user));
    } catch (e, st) {
      state = state.copyWith(user: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchRecipes() async {
    final recipes = await recipeService.getRecipes();
    state = state.copyWith(recipes: Optional.ofNullable(recipes));
  }

  Future<void> fetchRecipesByCategory(int categoryId) async {
    state = state.copyWith(recipes: const Optional.empty());
    final recipes = await recipeService.getRecipesByCategory(categoryId);
    state = state.copyWith(recipes: Optional.ofNullable(recipes));
  }

  Future<void> fetchCategoriesByType(int typeId) async {
    final homeCategories = await recipeService.getCategoriesByType(typeId);
    state = state.copyWith(homeCategories: Optional.ofNullable(homeCategories));
  }

  Future<void> fetchInitialHomeData() async {
    final categories = await recipeService.getCategoriesByType(2);
    final recipes = await recipeService.getRecipesByCategory(categories[0].id);
    state = state.copyWith(
      recipes: Optional.ofNullable(recipes),
      homeCategories: Optional.ofNullable(categories),
    );
    final popularRecipes = await recipeService.getPopularRecipes();
    state = state.copyWith(popularRecipes: Optional.ofNullable(popularRecipes));
  }

  Future<void> addRecipeToFavorites(Recipe recipe) async {
    try {
      final currentUser = state.user.asData?.value;
      if (currentUser == null) return;

      // Create updated user with new favorite recipe
      final updatedUser = currentUser.copyWith(
        favoriteRecipes: [...currentUser.favoriteRecipes, recipe],
      );

      // Update state with new user data
      state = state.copyWith(user: AsyncValue.data(updatedUser));

      // Persist the change
      await recipeService.addRecipeToFavorites(recipe.id);
    } catch (e, st) {
      state = state.copyWith(user: AsyncValue.error(e, st));
    }
  }

  Future<void> removeRecipeFromFavorites(Recipe recipe) async {
    try {
      final currentUser = state.user.asData?.value;
      if (currentUser == null) return;

      // Create updated user with new favorite recipe
      final updatedUser = currentUser.copyWith(
        favoriteRecipes: currentUser.favoriteRecipes
            .where((e) => e.id != recipe.id)
            .toList(),
      );

      // Update state with new user data
      state = state.copyWith(user: AsyncValue.data(updatedUser));

      // Persist the change
      await recipeService.removeRecipeFromFavorites(recipe.id);
    } catch (e, st) {
      state = state.copyWith(user: AsyncValue.error(e, st));
    }
  }

  Future<void> addRecipeToCookingHistory(Recipe recipe) async {
    try {
      final currentUser = state.user.asData?.value;
      if (currentUser == null) return;

      // Create updated user with new favorite recipe
      final updatedUser = currentUser.copyWith(
        cookingHistory: [
          ...currentUser.cookingHistory,
          CookedRecipe(recipe: recipe, cookTime: 'Today')
        ],
      );

      // Update state with new user data
      state = state.copyWith(user: AsyncValue.data(updatedUser));

      // Persist the change
      await recipeService.addRecipeToCookingHistory(recipe.id);
    } catch (e, st) {
      state = state.copyWith(user: AsyncValue.error(e, st));
    }
  }

  void setBottomNavbarIndex(int index) {
    state = state.copyWith(bottomNavbarIndex: Optional.ofNullable(index));
  }
}
