// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_use_cases.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(authUseCases)
const authUseCasesProvider = AuthUseCasesProvider._();

final class AuthUseCasesProvider
    extends $FunctionalProvider<AuthUseCases, AuthUseCases, AuthUseCases>
    with $Provider<AuthUseCases> {
  const AuthUseCasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authUseCasesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authUseCasesHash();

  @$internal
  @override
  $ProviderElement<AuthUseCases> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthUseCases create(Ref ref) {
    return authUseCases(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUseCases value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUseCases>(value),
    );
  }
}

String _$authUseCasesHash() => r'c24fe11631c2cd8c433be46829fc08eb42559d2c';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
