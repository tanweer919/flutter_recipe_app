import 'package:dekorner_recipe/models/recipe.dart';
import 'package:dekorner_recipe/models/recipe_filter.dart';
import 'package:dekorner_recipe/providers/app/providers.dart';
import 'package:dekorner_recipe/screens/home/widgets/popular_recipe_card.dart';
import 'package:dekorner_recipe/screens/home/widgets/popular_recipe_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterResultsScreen extends HookConsumerWidget {
  final List<RecipeFilter>? filters;
  const FilterResultsScreen({super.key, required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeService = ref.read(recipeServiceProvider);
    final recipes = useState<List<Recipe>?>(null);
    useEffect(() {
      Future<void> fetchInitialData() async {
        final result = await recipeService.getRecipesByFilters(filters ?? []);
        recipes.value = result;
      }

      fetchInitialData();
      return () {};
    }, []);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Filter Results',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                recipes.value != null
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(children: [
                            for (int i = 0; i < recipes.value!.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: PopularRecipeCard(
                                  recipe: recipes.value![i],
                                ),
                              ),
                          ]),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(children: [
                            for (int i = 0; i < 12; i++)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: PopularRecipeCardSkeleton(),
                              ),
                          ]),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
