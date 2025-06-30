import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dekorner_recipe/providers/fetch_popular_recipes_provider.dart';
import 'package:dekorner_recipe/screens/home/widgets/popular_recipe_card.dart';
import 'package:dekorner_recipe/screens/home/widgets/popular_recipe_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopularRecipesScreen extends HookConsumerWidget {
  const PopularRecipesScreen({super.key});
  static const pageSize = 10;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColorfulSafeArea(
      color: Colors.white,
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
            'Popular Recipes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final page = index ~/ pageSize + 1;
                final indexInPage = index % pageSize;
                // use the fact that this is an infinite list to fetch a new page
                // as soon as the index exceeds the page size
                // Note that ref.watch is called for up to pageSize items
                // with the same page and query arguments (but this is ok since data is cached)
                final responseAsync =
                    ref.watch(fetchPopularRecipesProvider(page));
                return responseAsync.when(
                  error: (err, stack) => Text(err.toString()),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: PopularRecipeCardSkeleton(),
                  ),
                  data: (response) {
                    // This condition only happens if a null itemCount is given
                    if (indexInPage >= response.length) {
                      return null;
                    }
                    final recipe = response[indexInPage];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: PopularRecipeCard(
                        recipe: recipe,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
