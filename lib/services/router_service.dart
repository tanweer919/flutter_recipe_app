import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/recipe_filter.dart';
import 'package:dekorner_recipe/screens/ai_coming_soon_screen.dart';
import 'package:dekorner_recipe/screens/filter_results/filter_results.dart';
import 'package:dekorner_recipe/screens/filters/fliters.dart';
import 'package:dekorner_recipe/screens/food_classification/food_classification_screen.dart';
import 'package:dekorner_recipe/screens/home/home.dart';
import 'package:dekorner_recipe/screens/login/login.dart';
import 'package:dekorner_recipe/screens/login/login_screen_arguments.dart';
import 'package:dekorner_recipe/screens/popular_recipes/popular_recipes.dart';
import 'package:dekorner_recipe/screens/profile/profile.dart';
import 'package:dekorner_recipe/screens/recipe_page/recipe_screen.dart';
import 'package:dekorner_recipe/screens/recipe_page/recipe_screen_arguments.dart';
import 'package:flutter/material.dart';

class RouterService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  Route<dynamic> generateRoutes(RouteSettings settings) {
    final List<String> validRoutes = [
      '/',
      '/login',
      '/home',
      '/recipe',
      '/filter',
      '/filter/results',
      '/profile',
      '/login',
      '/popular-recipes',
      '/ai',
      '/food-classification',
    ];

    PageRouteBuilder<dynamic> customRoutes(String route, Object? args) {
      Recipe? recipe;
      int? recipeId;
      String? message;
      String? screenToNavigate;
      List<RecipeFilter>? filters;
      if (args != null) {
        if (route == '/recipe') {
          final arguments = args as RecipeScreenArguments;
          recipe = arguments.recipe;
          recipeId = arguments.recipeId;
        }
        if (route == '/filter/results') {
          final arguments = args as List<RecipeFilter>;
          filters = arguments;
        }
        if (route == '/login') {
          final arguments = args as LoginScreenArguments;
          message = arguments.message;
          screenToNavigate = arguments.screenToNavigate;
        }
      }
      Map<String, Widget> screens = {
        '/': const Home(),
        '/login': LoginScreen(
          message: message,
          screenToNavigate: screenToNavigate,
        ),
        '/home': const Home(),
        '/recipe': RecipeScreen(recipe: recipe, recipeId: recipeId),
        '/filter': const FilterScreen(),
        '/filter/results': FilterResultsScreen(filters: filters),
        '/profile': const ProfileScreen(),
        '/popular-recipes': const PopularRecipesScreen(),
        '/ai': const AIComingSoonScreen(),
        '/food-classification': const FoodClassificationScreen(),
      };

      return PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              screens.containsKey(route) ? screens[route]! : Container(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: child,
              ),
          transitionDuration: const Duration(milliseconds: 250));
    }

    if (validRoutes.contains(settings.name)) {
      return customRoutes(settings.name!, settings.arguments);
    } else {
      return MaterialPageRoute(builder: (_) {
        return Container();
      });
    }
  }
}
