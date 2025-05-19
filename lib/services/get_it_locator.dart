import 'package:dekorner_recipe/services/auth_service.dart';
import 'package:dekorner_recipe/services/http_service.dart';
import 'package:dekorner_recipe/services/local_storage_service.dart';
import 'package:dekorner_recipe/services/recipe_service.dart';
import 'package:dekorner_recipe/services/router_service.dart';
import 'package:get_it/get_it.dart';
GetIt locator = GetIt.instance;

void setupLocator() {
  locator
      .registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  locator.registerLazySingleton<HttpService>(() => HttpService());
  locator.registerLazySingleton<RecipeService>(() => RecipeService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<RouterService>(() => RouterService());
}
