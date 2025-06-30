import 'package:dekorner_recipe/services/flushbar_service.dart';
import 'package:dekorner_recipe/widgets/widget_with_bottom_navbar.dart';
import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  final String? message;
  final String? screenToNavigate;
  const LoginScreen({super.key, this.message, this.screenToNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoginInProgress = useState(false);
    final appProviderNotifier = ref.read(appControlProvider.notifier);
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 250), () {
        appProviderNotifier.setUser(null);
      });
      return () {};
    }, []);
    ref.listen(appControlProvider.select((value) => value.user.asData?.value),
        (prevValue, newValue) {
      if (prevValue == null && newValue != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (screenToNavigate != null) {
            Navigator.of(context).pushReplacementNamed(screenToNavigate!);
          } else {
            Navigator.of(context).pushReplacementNamed('/profile');
          }
        });
      }
    });
    useEffect(() {
      if (message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FlushService.flushbarAlert(
            context: context,
            title: 'Info',
            message: message!,
            seconds: 3,
          );
        });
      }
      return () {};
    }, []);
    final theme = Theme.of(context);

    return WidgetWithBottomNavbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // App Logo or Name
            Text(
              'Recipify',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.primaryColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your Personal Recipe Assistant',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Cooking Illustration
            Expanded(
              child: SvgPicture.asset(
                'assets/images/cooking_illustration.svg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            // Welcome Text
            Text(
              'Welcome to Recipify',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Discover, cook, and share delicious recipes with our community',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Google Sign In Button
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  isLoginInProgress.value = true;
                  final appProviderNotifier =
                      ref.read(appControlProvider.notifier);
                  await appProviderNotifier.loginWithGoogle();
                  if (context.mounted) {
                    isLoginInProgress.value = false;
                  }
                } catch (e) {
                  isLoginInProgress.value = false;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error signing in'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: isLoginInProgress.value
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/images/google_logo.svg',
                      height: 24,
                      width: 24,
                    ),
              label: const Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

extension on Object {
  get message => null;
}
