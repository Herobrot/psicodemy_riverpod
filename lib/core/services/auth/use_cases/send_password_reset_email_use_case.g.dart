// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_password_reset_email_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(sendPasswordResetEmailUseCase)
const sendPasswordResetEmailUseCaseProvider =
    SendPasswordResetEmailUseCaseProvider._();

final class SendPasswordResetEmailUseCaseProvider
    extends
        $FunctionalProvider<
          SendPasswordResetEmailUseCase,
          SendPasswordResetEmailUseCase,
          SendPasswordResetEmailUseCase
        >
    with $Provider<SendPasswordResetEmailUseCase> {
  const SendPasswordResetEmailUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPasswordResetEmailUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPasswordResetEmailUseCaseHash();

  @$internal
  @override
  $ProviderElement<SendPasswordResetEmailUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SendPasswordResetEmailUseCase create(Ref ref) {
    return sendPasswordResetEmailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendPasswordResetEmailUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendPasswordResetEmailUseCase>(
        value,
      ),
    );
  }
}

String _$sendPasswordResetEmailUseCaseHash() =>
    r'cd77a2aa76071ac034ea50fb40e95ae6a0946aac';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
