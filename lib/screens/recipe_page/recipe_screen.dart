// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dekorner_recipe/constants.dart';
import 'package:dekorner_recipe/models/tab_bar_item.dart';
import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:dekorner_recipe/screens/login/login_screen_arguments.dart';
import 'package:dekorner_recipe/screens/recipe_page/components/recipe_page_skeleton.dart';
import 'package:dekorner_recipe/services/flushbar_service.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/services/recipe_service.dart';
import 'package:dekorner_recipe/widgets/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:dekorner_recipe/models/recipe.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:readmore/readmore.dart';
import 'package:dekorner_recipe/widgets/custom_tab_bar.dart';

class RecipeScreen extends HookConsumerWidget {
  static const String routeName = '/recipe';

  final Recipe? recipe;
  final int? recipeId;
  const RecipeScreen({
    super.key,
    this.recipe,
    this.recipeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeService = locator<RecipeService>();
    final appProvider = ref.watch(appControlProvider);
    final appProviderNotifier = ref.read(appControlProvider.notifier);
    final user = appProvider.user.asData?.value;
    final isRecipeInFavorites = user != null
        ? user.favoriteRecipes
            .map((recipe) => recipe.id)
            .contains(recipe?.id ?? recipeId)
        : false;
    final isRecipeAlreadyCooked = user != null
        ? user.cookingHistory
            .map((recipe) => recipe.recipe.id)
            .contains(recipe?.id ?? recipeId)
        : false;
    final carouselIndex = useState(0);
    final recipeData = useState(recipe);
    final pageController = usePageController();
    const greyColor = Color.fromARGB(255, 104, 111, 117);
    fetchData() async {
      recipeData.value = await recipeService.getRecipe(recipeId!);
    }

    useEffect(() {
      if (recipe == null) {
        fetchData();
      }
      return () {};
    }, []);
    final fetchedRecipe = recipeData.value;

    return ColorfulSafeArea(
      color: Color.fromARGB(255, 52, 45, 40),
      child: Scaffold(
        body: fetchedRecipe == null
            ? const RecipePageSkeleton()
            : CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 90,
                      maxHeight: 400,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: fetchedRecipe.images.length,
                            itemBuilder: (context, index) => SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                imageUrl: fetchedRecipe.images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            onPageChanged: (index) {
                              carouselIndex.value = index;
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Colors.grey.withOpacity(0.05),
                                    Colors.black,
                                  ],
                                  stops: const [0.0, 1.0],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 75.0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 35.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0;
                                        i < fetchedRecipe.images.length;
                                        i++)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Container(
                                          width:
                                              carouselIndex.value == i ? 30 : 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff119a62),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 6,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffe4ebec),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedArrowLeft01,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (user != null) {
                                          appProviderNotifier
                                              .addRecipeToCookingHistory(
                                                  recipe!);
                                          FlushService.flushbarAlert(
                                            context: context,
                                            title: 'Success',
                                            message:
                                                'Recipe added to cooking history',
                                            seconds: 3,
                                          );
                                        } else {
                                          appProviderNotifier.setBottomNavbarIndex(3);
                                          Navigator.of(context).pushNamed(
                                            '/login',
                                            arguments:
                                                LoginScreenArguments(
                                              message: 'Login to continue!',
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            isRecipeAlreadyCooked
                                                ? Icons.schedule
                                                : Icons.schedule_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (user != null) {
                                          if (isRecipeInFavorites) {
                                            appProviderNotifier
                                                .removeRecipeFromFavorites(
                                                    recipe!);
                                            FlushService.flushbarAlert(
                                              context: context,
                                              title: 'Success',
                                              message:
                                                  'Recipe removed from favorites',
                                              seconds: 3,
                                            );
                                          } else {
                                            FlushService.flushbarAlert(
                                              context: context,
                                              title: 'Success',
                                              message:
                                                  'Recipe added to favorites',
                                              seconds: 3,
                                            );
                                            appProviderNotifier
                                                .addRecipeToFavorites(recipe!);
                                          }
                                        } else {
                                          appProviderNotifier.setBottomNavbarIndex(3);
                                          Navigator.of(context).pushNamed(
                                            '/login',
                                            arguments:
                                                LoginScreenArguments(
                                              message: 'Login to continue!',
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            isRecipeInFavorites
                                                ? 'assets/svg/bookmark-filled.svg'
                                                : 'assets/svg/bookmark.svg',
                                            color: Colors.black,
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 4.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    fetchedRecipe.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ReadMoreText(
                            fetchedRecipe.description,
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            colorClickableText: Colors.pink,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            moreStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            lessStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            style: const TextStyle(
                              color: greyColor,
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 40) /
                                          2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffe6ebf3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: SvgPicture.asset(
                                              'assets/svg/clock.svg',
                                              color: const Color.fromARGB(
                                                  255, 83, 79, 79),
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          fetchedRecipe.totalTime,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflowReplacement: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              fetchedRecipe.totalTime,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 40) /
                                          2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffe6ebf3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: SvgPicture.asset(
                                              'assets/svg/fire-filled.svg',
                                              color: const Color.fromARGB(
                                                  255, 83, 79, 79),
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${fetchedRecipe.calories} calories',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflowReplacement: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              fetchedRecipe.totalTime,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 40) /
                                          2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffe6ebf3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            MyFlutterApp.pizza,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${fetchedRecipe.fatContent} gm',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflowReplacement: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              fetchedRecipe.totalTime,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 40) /
                                          2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffe6ebf3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            MyFlutterApp.protien,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${fetchedRecipe.proteinContent} gm',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflowReplacement: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              fetchedRecipe.totalTime,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CustomTabBar(
                              items: [
                                TabBarItem(
                                  title: 'Ingredients',
                                  child: IngredientSection(
                                    recipe: fetchedRecipe,
                                  ),
                                ),
                                TabBarItem(
                                  title: 'Instructions',
                                  child: Container(
                                    child: InstructionSection(
                                      recipe: fetchedRecipe,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class InstructionSection extends StatelessWidget {
  final Recipe recipe;
  const InstructionSection({super.key, required this.recipe});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < recipe.instructions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    recipe.instructions[i],
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )),
              ],
            ),
          )
      ],
    );
  }
}

class IngredientSection extends HookWidget {
  final Recipe recipe;
  const IngredientSection({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    const greyColor = Color.fromARGB(255, 104, 111, 117);
    final noOfServings = useState<int>(recipe.noOfServings);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Persons',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'How many servings',
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SvgPicture.asset(
                      'assets/svg/yield.svg',
                      height: 20,
                      width: 20,
                      color: greyColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      noOfServings.value = noOfServings.value - 1;
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xffe6ebf3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    noOfServings.value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  InkWell(
                    onTap: () {
                      noOfServings.value = noOfServings.value + 1;
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xffe6ebf3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 22,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 2.0,
            top: 4.0,
          ),
          child: Row(
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: SvgPicture.asset(
                  'assets/svg/ingredients.svg',
                  height: 20,
                  width: 20,
                  color: greyColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
          ),
          child: Text(
            '${recipe.ingredients.length.toString()} items',
            style: const TextStyle(
              fontSize: 15,
              color: greyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Column(
          children: recipe.ingredients.map((e) {
            final res = extractFraction(e.quantity ?? '');
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 60,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          spreadRadius: -1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: res.$1
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          res.$2!.toString(),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            fontFeatures: [
                                              FontFeature.superscripts(),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          '/',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            fontFeatures: [
                                              FontFeature.subscripts(),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          res.$3!.toString(),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            fontFeatures: [
                                              FontFeature.subscripts(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      e.quantity ?? '',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                e.ingredientText,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          if (e.ingredient.affiliateLink != null)
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/images/amazon-fresh-logo.png',
                                height: 30,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
