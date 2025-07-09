// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_with_email_and_password_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(signInWithEmailAndPasswordUseCase)
const signInWithEmailAndPasswordUseCaseProvider =
    SignInWithEmailAndPasswordUseCaseProvider._();

final class SignInWithEmailAndPasswordUseCaseProvider
    extends
        $FunctionalProvider<
          SignInWithEmailAndPasswordUseCase,
          SignInWithEmailAndPasswordUseCase,
          SignInWithEmailAndPasswordUseCase
        >
    with $Provider<SignInWithEmailAndPasswordUseCase> {
  const SignInWithEmailAndPasswordUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInWithEmailAndPasswordUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$signInWithEmailAndPasswordUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInWithEmailAndPasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInWithEmailAndPasswordUseCase create(Ref ref) {
    return signInWithEmailAndPasswordUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInWithEmailAndPasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInWithEmailAndPasswordUseCase>(
        value,
      ),
    );
  }
}

String _$signInWithEmailAndPasswordUseCaseHash() =>
    r'd1ec785d9e6416733b28d01f3179eeabadbd9c90';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
