import 'package:dekorner_recipe/services/auth_service.dart';
import 'package:dekorner_recipe/services/http_service.dart';
import 'package:dekorner_recipe/services/local_storage_service.dart';
import 'package:dekorner_recipe/services/recipe_service.dart';
import 'package:dekorner_recipe/services/router_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) {
  final httpService = ref.read(httpServiceProvider);
  return RecipeService(httpService: httpService);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final localStorageService = ref.read(localStorageServiceProvider);
  return AuthService(httpService: httpService, localStorageService: localStorageService);
});

final httpServiceProvider = Provider<HttpService>((ref) {
  final localStorageService = ref.read(localStorageServiceProvider);
  return HttpService(localStorageService: localStorageService);
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final routerServiceProvider = Provider<RouterService>((ref) {
  return RouterService();
});
