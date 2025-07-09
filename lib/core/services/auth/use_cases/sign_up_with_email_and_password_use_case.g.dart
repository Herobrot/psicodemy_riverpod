// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_with_email_and_password_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(signUpWithEmailAndPasswordUseCase)
const signUpWithEmailAndPasswordUseCaseProvider =
    SignUpWithEmailAndPasswordUseCaseProvider._();

final class SignUpWithEmailAndPasswordUseCaseProvider
    extends
        $FunctionalProvider<
          SignUpWithEmailAndPasswordUseCase,
          SignUpWithEmailAndPasswordUseCase,
          SignUpWithEmailAndPasswordUseCase
        >
    with $Provider<SignUpWithEmailAndPasswordUseCase> {
  const SignUpWithEmailAndPasswordUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signUpWithEmailAndPasswordUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$signUpWithEmailAndPasswordUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignUpWithEmailAndPasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignUpWithEmailAndPasswordUseCase create(Ref ref) {
    return signUpWithEmailAndPasswordUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignUpWithEmailAndPasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignUpWithEmailAndPasswordUseCase>(
        value,
      ),
    );
  }
}

String _$signUpWithEmailAndPasswordUseCaseHash() =>
    r'ad18aed5bd9c61c2bb6b03afb6eccba0a0382df9';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
