import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:dekorner_recipe/screens/home/home.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/services/router_service.dart';
import 'package:dekorner_recipe/widgets/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  setupLocator();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  final ThemeData theme = ThemeData(
      primaryColor: const Color(0xff12285e),
      primaryColorDark: const Color.fromARGB(255, 146, 146, 148),
      scaffoldBackgroundColor: const Color(0xfffefefe),
      fontFamily: 'OpenSans',
      brightness: Brightness.light,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xff12285e),
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xff77777c),
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          color: Color(0xff77777c),
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          color: Color(0xff77777c),
          fontWeight: FontWeight.w600,
        ),
      ),
      useMaterial3: true);
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerService = locator<RouterService>();
    final appProvider = ref.watch(appControlProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primaryContainer: const Color(0xffeaf4fd),
          secondary: const Color(0xff12285e),
          outline: const Color(0XFFEDEDED),
          surface: const Color(0XFFF8FAFC),
          onSurface: const Color(0xff7a7a7a),
          tertiary: const Color(0xffff8500),
          surfaceContainer: const Color.fromARGB(130, 226, 225, 249),
          // tertiary: Color.fromARGB(255, 146, 146, 148).withOpacity(0.5),
        ),
      ),
      navigatorKey: routerService.navigationKey,
      onGenerateRoute: routerService.generateRoutes,
      home: appProvider.user.when(
        data: (user) => const Home(),
        loading: () => const SplashScreen(),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
