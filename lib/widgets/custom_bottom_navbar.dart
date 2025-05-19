import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomNavbar extends ConsumerWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appProviderNotifier = ref.watch(appControlProvider.notifier);
    final appProvider = ref.watch(appControlProvider);
    final user = appProvider.user.asData?.value;
    final items = [
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.home_outlined),
        ),
        activeIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.home_rounded),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.explore_outlined),
        ),
        activeIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.explore_rounded),
        ),
        label: 'Discover',
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_awesome_outlined),
        ),
        activeIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_awesome_rounded),
        ),
        label: 'AI',
      ),
      user != null
          ? BottomNavigationBarItem(
              icon: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person_outline)),
              activeIcon: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded),
              ),
              label: 'Profile',
            )
          : BottomNavigationBarItem(
              icon: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person_outline)),
              activeIcon: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded),
              ),
              label: 'Login',
            ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: appProvider.bottomNavbarIndex,
        onTap: (index) {
          appProviderNotifier.setBottomNavbarIndex(index);
          if (index == 0) {
            Navigator.of(context).pushNamed('/home');
          }
          if (index == 1) {
            Navigator.of(context).pushNamed('/filter');
          }
          if (index == 2) {
            Navigator.of(context).pushNamed('/ai');
          }
          if (index == 3) {
            if (user != null) {
              Navigator.of(context).pushNamed('/profile');
            } else {
              Navigator.of(context).pushNamed('/login');
            }
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        items: items,
      ),
    );
  }
}
