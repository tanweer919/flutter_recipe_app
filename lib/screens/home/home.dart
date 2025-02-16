import 'package:cached_network_image/cached_network_image.dart';
import 'package:dekorner_recipe/constants.dart';
import 'package:dekorner_recipe/models/search_recipe.dart';
import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:dekorner_recipe/providers/app/providers.dart';
import 'package:dekorner_recipe/screens/home/widgets/categories_skeleton.dart';
import 'package:dekorner_recipe/screens/home/widgets/popular_recipe_card.dart';
import 'package:dekorner_recipe/screens/home/widgets/popular_recipe_card_skeleton.dart';
import 'package:dekorner_recipe/screens/home/widgets/recipe_card.dart';
import 'package:dekorner_recipe/screens/home/widgets/recipe_card_skeleton.dart';
import 'package:dekorner_recipe/screens/recipe_page/recipe_screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = useState(0);
    final appProviderNotifier = ref.watch(appControlProvider.notifier);
    final appProvider = ref.watch(appControlProvider);
    final authService = ref.read(authServiceProvider);
    final recipeService = ref.read(recipeServiceProvider);
    final isLoading = useState(false);
    Widget searchBar() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: Theme.of(context).colorScheme.outline, width: 1.5),
        ),
        child: Autocomplete<SearchRecipe>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            isLoading.value = true;
            if (textEditingValue.text == '') {
              return [];
            }
            final recipes =
                recipeService.searchRecipesByQuery(textEditingValue.text);
            isLoading.value = false;
            return recipes;
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 290),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isLoading.value
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: 5, // Show 3 skeleton items while loading
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: index != 2
                                      ? Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withOpacity(0.2),
                                          ),
                                        )
                                      : null,
                                ),
                                child: ListTile(
                                  leading: Skeleton(
                                    width: 40,
                                    height: 40,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  title: Skeleton(
                                    width: double.infinity,
                                    height: 20,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final SearchRecipe recipe =
                                  options.elementAt(index);
                              return Container(
                                decoration: BoxDecoration(
                                  border: index != options.length - 1
                                      ? Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withOpacity(0.2),
                                          ),
                                        )
                                      : null,
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: Image.network(
                                        recipe.image != null
                                            ? recipe.image!
                                            : 'https://picsum.photos/40', // Replace with your actual image URL
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 40,
                                            height: 40,
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 20,
                                              color: Colors.grey[400],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    recipe.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF4A5568),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/recipe',
                                      arguments: RecipeScreenArguments(
                                        recipeId: recipe.id,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
              child: SizedBox(
                height: 44,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                      child: Icon(
                        Icons.search_rounded,
                        size: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              hintText: 'Search recipes',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onChanged: (value) async {},
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 1.5,
                        height: 25,
                        color: const Color.fromARGB(255, 180, 180, 180),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/filter');
                      },
                      child: Container(
                        child: const Icon(
                          Icons.tune,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

// Skeleton widget for loading sta

    useEffect(() {
      appProviderNotifier.fetchInitialHomeData();
      return () {};
    }, []);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hi,',
                                  style: TextStyle(
                                      color: Color(0xff4b4b4b), fontSize: 18),
                                ),
                                TextSpan(
                                  text: 'Tanweer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'UI Designer & Cook',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 120, 120, 120),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () {
                            authService.loginWithGoogle();
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://pbs.twimg.com/profile_images/1035928584697696256/_eg6oELD_400x400.jpg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: searchBar(),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 96.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Color(0xfffff0cb),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 64.0, top: 16.0, bottom: 16.0),
                          child: Column(
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Find recipes based on what you already have at ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        height: 1.3,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'home',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 22,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                      color: Color(0xfffb9d31),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xfffb9d31),
                                    weight: 1.2,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: -60,
                        top: 15,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 8,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/dish2.jpeg',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: appProvider.homeCategories != null
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0;
                                  i < appProvider.homeCategories!.length;
                                  i++)
                                InkWell(
                                  onTap: () {
                                    activeIndex.value = i;
                                    appProviderNotifier.fetchRecipesByCategory(
                                      appProvider.homeCategories![i].id,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          appProvider.homeCategories![i].name
                                              .toCapitalized,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: activeIndex.value == i
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Container(
                                            height: 3,
                                            width: 15,
                                            decoration: BoxDecoration(
                                              color: activeIndex.value == i
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < 5; i++)
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.0),
                                    child: CategoriesSkeleton()),
                            ],
                          ),
                        ),
                ),
                appProvider.recipes != null
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(children: [
                            for (int i = 0;
                                i < appProvider.recipes!.length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child:
                                    RecipeCard(data: appProvider.recipes![i]),
                              ),
                          ]),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(children: [
                            for (int i = 0; i < 5; i++)
                              const Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: RecipeCardSkeleton(),
                              ),
                          ]),
                        ),
                      ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular recipes',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                appProvider.popularRecipes != null
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(children: [
                            for (int i = 0;
                                i < appProvider.recipes!.length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: PopularRecipeCard(
                                  recipe: appProvider.popularRecipes![i],
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
                            for (int i = 0; i < 5; i++)
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

class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const Skeleton({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
