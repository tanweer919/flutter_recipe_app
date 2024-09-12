import 'package:cached_network_image/cached_network_image.dart';
import 'package:dekorner_recipe/constants.dart';
import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:dekorner_recipe/screens/home/widgets/categories_skeleton.dart';
import 'package:dekorner_recipe/screens/home/widgets/recipe_card.dart';
import 'package:dekorner_recipe/screens/home/widgets/recipe_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = useState(0);
    final appProviderNotifier = ref.watch(appControlProvider.notifier);
    final appProvider = ref.watch(appControlProvider);
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
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://pbs.twimg.com/profile_images/1035928584697696256/_eg6oELD_400x400.jpg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
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
                                          appProvider.homeCategories![i].name.toCapitalized,
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
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
