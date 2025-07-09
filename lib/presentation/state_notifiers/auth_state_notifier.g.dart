// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AuthStateNotifier)
const authStateNotifierProvider = AuthStateNotifierProvider._();

final class AuthStateNotifierProvider
    extends $NotifierProvider<AuthStateNotifier, AuthState> {
  const AuthStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateNotifierHash();

  @$internal
  @override
  AuthStateNotifier create() => AuthStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authStateNotifierHash() => r'99b29c5526dedc9b3ff65b20784bf29be3b7dc08';

abstract class _$AuthStateNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LoginStateNotifier)
const loginStateNotifierProvider = LoginStateNotifierProvider._();

final class LoginStateNotifierProvider
    extends $NotifierProvider<LoginStateNotifier, LoginState> {
  const LoginStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginStateNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginStateNotifierHash();

  @$internal
  @override
  LoginStateNotifier create() => LoginStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginState>(value),
    );
  }
}

String _$loginStateNotifierHash() =>
    r'f7df83fbe581d5279c7009c0e50acb15558ef3bb';

abstract class _$LoginStateNotifier extends $Notifier<LoginState> {
  LoginState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LoginState, LoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoginState, LoginState>,
              LoginState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
