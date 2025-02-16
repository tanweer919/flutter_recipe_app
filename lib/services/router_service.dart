import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/recipe_filter.dart';
import 'package:dekorner_recipe/screens/filter_results/filter_results.dart';
import 'package:dekorner_recipe/screens/filters/fliters.dart';
import 'package:dekorner_recipe/screens/home/home.dart';
import 'package:dekorner_recipe/screens/recipe_page/recipe_screen.dart';
import 'package:dekorner_recipe/screens/recipe_page/recipe_screen_arguments.dart';
import 'package:flutter/material.dart';

class RouterService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  Route<dynamic> generateRoutes(RouteSettings settings) {
    final List<String> validRoutes = [
      '/',
      '/home',
      '/recipe',
      '/filter',
      '/filter/results',
    ];

    PageRouteBuilder<dynamic> customRoutes(String route, Object? args) {
      Recipe? recipe;
      int? recipeId;
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
      }
      Map<String, Widget> screens = {
        '/': const Home(),
        '/home': const Home(),
        '/recipe': RecipeScreen(recipe: recipe, recipeId: recipeId),
        '/filter': const FilterScreen(),
        '/filter/results': FilterResultsScreen(filters: filters),
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
