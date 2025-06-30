import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:dekorner_recipe/screens/login/login_screen_arguments.dart';
import 'package:dekorner_recipe/widgets/widget_with_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AIComingSoonScreen extends HookConsumerWidget {
  const AIComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appProvider = ref.read(appControlProvider);
    final appProviderNotifier = ref.read(appControlProvider.notifier);
    final user = appProvider.user.asData?.value;

    Widget _buildFeatureCard(
      BuildContext context, {
      required IconData icon,
      required String title,
      required String description,
      required List<Color> gradient,
      bool isComingSoon = false,
    }) {
      return InkWell(
        onTap: isComingSoon
            ? null
            : () {
                if (user == null) {
                  appProviderNotifier.setBottomNavbarIndex(3);
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: LoginScreenArguments(
                      message: 'Please login to use ai features',
                      screenToNavigate: title == 'AI Cooking Assistant'
                          ? '/ai-chat'
                          : '/food-classification',
                    ),
                  );
                } else {
                  if (title == 'AI Cooking Assistant') {
                    Navigator.of(context).pushNamed('/ai-chat');
                    return;
                  }
                  Navigator.of(context).pushNamed('/food-classification');
                }
              },
        child: Opacity(
          opacity: isComingSoon ? 0.6 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: gradient[0].withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: gradient[0].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: gradient[0],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isComingSoon)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Coming Soon',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return WidgetWithBottomNavbar(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 48,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'AI Features',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'re cooking up something special!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  context,
                  icon: Icons.auto_awesome_rounded,
                  title: 'AI Cooking Assistant',
                  description: 'Chat with our AI assistant for cooking help',
                  gradient: [Colors.teal, Colors.teal.shade700],
                  isComingSoon: false,
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.camera_alt_rounded,
                  title: 'AI Food Recognition',
                  description:
                      'Instantly identify dishes and ingredients from photos',
                  gradient: [Colors.blue, Colors.blue.shade700],
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.monitor_heart_rounded,
                  title: 'Nutrition Analysis',
                  description:
                      'Get detailed nutritional information from food images',
                  gradient: [Colors.orange, Colors.orange.shade700],
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.kitchen_rounded,
                  title: 'Smart Recipe Suggestions',
                  description:
                      'Get personalized recipes based on ingredients in your fridge',
                  gradient: [Colors.green, Colors.green.shade700],
                  isComingSoon: true,
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.auto_fix_high_rounded,
                  title: 'AI Recipe Generator',
                  description:
                      'Create custom recipes tailored to your preferences',
                  gradient: [Colors.purple, Colors.purple.shade700],
                  isComingSoon: true,
                ),
                const SizedBox(height: 20),
                Text(
                  'Stay tuned for updates!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
