// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_recipes_by_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRecipesByFilterHash() =>
    r'c9b042513c302b78c0f276720147a6389bc4bc48';

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

/// See also [fetchRecipesByFilter].
@ProviderFor(fetchRecipesByFilter)
const fetchRecipesByFilterProvider = FetchRecipesByFilterFamily();

/// See also [fetchRecipesByFilter].
class FetchRecipesByFilterFamily extends Family {
  /// See also [fetchRecipesByFilter].
  const FetchRecipesByFilterFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchRecipesByFilterProvider';

  /// See also [fetchRecipesByFilter].
  FetchRecipesByFilterProvider call(
    List<RecipeFilter> filters,
    int page,
  ) {
    return FetchRecipesByFilterProvider(
      filters,
      page,
    );
  }

  @visibleForOverriding
  @override
  FetchRecipesByFilterProvider getProviderOverride(
    covariant FetchRecipesByFilterProvider provider,
  ) {
    return call(
      provider.filters,
      provider.page,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<Recipe>> Function(FetchRecipesByFilterRef ref) create) {
    return _$FetchRecipesByFilterFamilyOverride(this, create);
  }
}

class _$FetchRecipesByFilterFamilyOverride implements FamilyOverride {
  _$FetchRecipesByFilterFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<Recipe>> Function(FetchRecipesByFilterRef ref) create;

  @override
  final FetchRecipesByFilterFamily overriddenFamily;

  @override
  FetchRecipesByFilterProvider getProviderOverride(
    covariant FetchRecipesByFilterProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchRecipesByFilter].
class FetchRecipesByFilterProvider
    extends AutoDisposeFutureProvider<List<Recipe>> {
  /// See also [fetchRecipesByFilter].
  FetchRecipesByFilterProvider(
    List<RecipeFilter> filters,
    int page,
  ) : this._internal(
          (ref) => fetchRecipesByFilter(
            ref as FetchRecipesByFilterRef,
            filters,
            page,
          ),
          from: fetchRecipesByFilterProvider,
          name: r'fetchRecipesByFilterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRecipesByFilterHash,
          dependencies: FetchRecipesByFilterFamily._dependencies,
          allTransitiveDependencies:
              FetchRecipesByFilterFamily._allTransitiveDependencies,
          filters: filters,
          page: page,
        );

  FetchRecipesByFilterProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filters,
    required this.page,
  }) : super.internal();

  final List<RecipeFilter> filters;
  final int page;

  @override
  Override overrideWith(
    FutureOr<List<Recipe>> Function(FetchRecipesByFilterRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchRecipesByFilterProvider._internal(
        (ref) => create(ref as FetchRecipesByFilterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filters: filters,
        page: page,
      ),
    );
  }

  @override
  (
    List<RecipeFilter>,
    int,
  ) get argument {
    return (
      filters,
      page,
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Recipe>> createElement() {
    return _FetchRecipesByFilterProviderElement(this);
  }

  FetchRecipesByFilterProvider _copyWith(
    FutureOr<List<Recipe>> Function(FetchRecipesByFilterRef ref) create,
  ) {
    return FetchRecipesByFilterProvider._internal(
      (ref) => create(ref as FetchRecipesByFilterRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      filters: filters,
      page: page,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRecipesByFilterProvider &&
        other.filters == filters &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filters.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchRecipesByFilterRef on AutoDisposeFutureProviderRef<List<Recipe>> {
  /// The parameter `filters` of this provider.
  List<RecipeFilter> get filters;

  /// The parameter `page` of this provider.
  int get page;
}

class _FetchRecipesByFilterProviderElement
    extends AutoDisposeFutureProviderElement<List<Recipe>>
    with FetchRecipesByFilterRef {
  _FetchRecipesByFilterProviderElement(super.provider);

  @override
  List<RecipeFilter> get filters =>
      (origin as FetchRecipesByFilterProvider).filters;
  @override
  int get page => (origin as FetchRecipesByFilterProvider).page;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
