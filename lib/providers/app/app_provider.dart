import 'package:dekorner_recipe/providers/app/app_state.dart';
import 'package:dekorner_recipe/providers/app/providers.dart';
import 'package:optional/optional.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_provider.g.dart';

@riverpod
class AppControl extends _$AppControl {
  @override
  AppState build() {
    return AppState();
  }

  Future<void> fetchRecipes() async {
    final recipeService = ref.read(recipeServiceProvider);
    final recipes = await recipeService.getRecipes();
    state = state.copyWith(recipes: Optional.ofNullable(recipes));
  }

  Future<void> fetchRecipesByCategory(int categoryId) async {
    final recipeService = ref.read(recipeServiceProvider);
    state = state.copyWith(recipes: const Optional.empty());
    final recipes = await recipeService.getRecipesByCategory(categoryId);
    state = state.copyWith(recipes: Optional.ofNullable(recipes));
  }

  Future<void> fetchCategoriesByType(int typeId) async {
    final recipeService = ref.read(recipeServiceProvider);
    final homeCategories = await recipeService.getCategoriesByType(typeId);
    state = state.copyWith(homeCategories: Optional.ofNullable(homeCategories));
  }

  Future<void> fetchInitialHomeData() async {
    final recipeService = ref.read(recipeServiceProvider);
    final categories = await recipeService.getCategoriesByType(2);
    final recipes = await recipeService.getRecipesByCategory(categories[0].id);
    state = state.copyWith(
      recipes: Optional.ofNullable(recipes),
      homeCategories: Optional.ofNullable(categories),
    );
    final popularRecipes = await recipeService.getPopularRecipes();
    state = state.copyWith(
      popularRecipes: Optional.ofNullable(popularRecipes)
    );
  }
}
