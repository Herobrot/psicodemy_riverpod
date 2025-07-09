// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(secureStorageRepository)
const secureStorageRepositoryProvider = SecureStorageRepositoryProvider._();

final class SecureStorageRepositoryProvider
    extends
        $FunctionalProvider<
          SecureStorageRepository,
          SecureStorageRepository,
          SecureStorageRepository
        >
    with $Provider<SecureStorageRepository> {
  const SecureStorageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageRepositoryHash();

  @$internal
  @override
  $ProviderElement<SecureStorageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureStorageRepository create(Ref ref) {
    return secureStorageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorageRepository>(value),
    );
  }
}

String _$secureStorageRepositoryHash() =>
    r'a57390c9e0447cc960e0164be5433f614dc46784';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
