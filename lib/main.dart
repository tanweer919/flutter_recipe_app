import 'package:dekorner_recipe/providers/app/providers.dart';
import 'package:dekorner_recipe/screens/home/home.dart';
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
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  final ThemeData theme = ThemeData(
      primaryColor: const Color(0xff0165ff),
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
    final routerService = ref.watch(routerServiceProvider);
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
          // tertiary: Color.fromARGB(255, 146, 146, 148).withOpacity(0.5),
        ),
      ),
      navigatorKey: routerService.navigationKey,
      onGenerateRoute: routerService.generateRoutes,
      home: const Home(),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize providers by watching them.
    // By using "watch", the provider will stay alive and not be disposed.
    ref.watch(routerServiceProvider);
    return child;
  }
}
