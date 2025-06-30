// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_popular_recipes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPopularRecipesHash() =>
    r'8772ffbe5e1cd6570940ee262cd1dad5890a5167';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fetchPopularRecipes].
@ProviderFor(fetchPopularRecipes)
const fetchPopularRecipesProvider = FetchPopularRecipesFamily();

/// See also [fetchPopularRecipes].
class FetchPopularRecipesFamily extends Family {
  /// See also [fetchPopularRecipes].
  const FetchPopularRecipesFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchPopularRecipesProvider';

  /// See also [fetchPopularRecipes].
  FetchPopularRecipesProvider call(
    int page,
  ) {
    return FetchPopularRecipesProvider(
      page,
    );
  }

  @visibleForOverriding
  @override
  FetchPopularRecipesProvider getProviderOverride(
    covariant FetchPopularRecipesProvider provider,
  ) {
    return call(
      provider.page,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<Recipe>> Function(FetchPopularRecipesRef ref) create) {
    return _$FetchPopularRecipesFamilyOverride(this, create);
  }
}

class _$FetchPopularRecipesFamilyOverride implements FamilyOverride {
  _$FetchPopularRecipesFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<Recipe>> Function(FetchPopularRecipesRef ref) create;

  @override
  final FetchPopularRecipesFamily overriddenFamily;

  @override
  FetchPopularRecipesProvider getProviderOverride(
    covariant FetchPopularRecipesProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchPopularRecipes].
class FetchPopularRecipesProvider
    extends AutoDisposeFutureProvider<List<Recipe>> {
  /// See also [fetchPopularRecipes].
  FetchPopularRecipesProvider(
    int page,
  ) : this._internal(
          (ref) => fetchPopularRecipes(
            ref as FetchPopularRecipesRef,
            page,
          ),
          from: fetchPopularRecipesProvider,
          name: r'fetchPopularRecipesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPopularRecipesHash,
          dependencies: FetchPopularRecipesFamily._dependencies,
          allTransitiveDependencies:
              FetchPopularRecipesFamily._allTransitiveDependencies,
          page: page,
        );

  FetchPopularRecipesProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
  }) : super.internal();

  final int page;

  @override
  Override overrideWith(
    FutureOr<List<Recipe>> Function(FetchPopularRecipesRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPopularRecipesProvider._internal(
        (ref) => create(ref as FetchPopularRecipesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
      ),
    );
  }

  @override
  (int,) get argument {
    return (page,);
  }

  @override
  AutoDisposeFutureProviderElement<List<Recipe>> createElement() {
    return _FetchPopularRecipesProviderElement(this);
  }

  FetchPopularRecipesProvider _copyWith(
    FutureOr<List<Recipe>> Function(FetchPopularRecipesRef ref) create,
  ) {
    return FetchPopularRecipesProvider._internal(
      (ref) => create(ref as FetchPopularRecipesRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      page: page,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPopularRecipesProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchPopularRecipesRef on AutoDisposeFutureProviderRef<List<Recipe>> {
  /// The parameter `page` of this provider.
  int get page;
}

class _FetchPopularRecipesProviderElement
    extends AutoDisposeFutureProviderElement<List<Recipe>>
    with FetchPopularRecipesRef {
  _FetchPopularRecipesProviderElement(super.provider);

  @override
  int get page => (origin as FetchPopularRecipesProvider).page;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
