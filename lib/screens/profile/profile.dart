import 'package:cached_network_image/cached_network_image.dart';
import 'package:dekorner_recipe/models/user.dart';
import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:dekorner_recipe/screens/home/widgets/cooked_recipe_card.dart';
import 'package:dekorner_recipe/screens/home/widgets/popular_recipe_card.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/widgets/widget_with_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dekorner_recipe/services/local_storage_service.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appProvider = ref.watch(appControlProvider);
    final appProviderNotifier = ref.read(appControlProvider.notifier);
    final user = appProvider.user.asData?.value;
    return WidgetWithBottomNavbar(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(4),
                      child: user != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      CachedNetworkImageProvider(user.photoUrl),
                                ),
                                if (user.name.trim() != "")
                                  const SizedBox(height: 16),
                                if (user.name.trim() != "")
                                  Text(
                                    user.name,
                                    style: theme.textTheme.displayMedium,
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            )
                          : null,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () async {
                          await appProviderNotifier.logout();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                          }
                        },
                        icon: Icon(
                          Icons.logout_rounded,
                          color: theme.colorScheme.error,
                          size: 24,
                        ),
                        style: IconButton.styleFrom(
                          side: BorderSide(
                            color: theme.colorScheme.error.withOpacity(0.5),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: theme.primaryColor,
                    unselectedLabelColor: theme.textTheme.bodyLarge?.color,
                    indicatorColor: theme.primaryColor,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.bookmark),
                        text: 'Saved Recipes',
                      ),
                      Tab(
                        icon: Icon(Icons.restaurant),
                        text: 'Cooked Recipes',
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Saved Recipes Tab
              _buildSavedRecipeGrid(context, true, user!),
              // Cooked Recipes Tab
              _buildCookedRecipeGrid(context, false, user),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedRecipeGrid(BuildContext context, bool isSaved, User user) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(children: [
          for (int i = 0; i < user.favoriteRecipes.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PopularRecipeCard(
                recipe: user.favoriteRecipes[i],
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildCookedRecipeGrid(BuildContext context, bool isSaved, User user) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(children: [
          for (int i = 0; i < user.cookingHistory.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CookedRecipeCard(
                cookedRecipe: user.cookingHistory[i],
              ),
            ),
        ]),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
