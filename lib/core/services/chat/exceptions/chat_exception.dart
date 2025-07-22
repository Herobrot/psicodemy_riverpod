abstract class ChatException implements Exception {
  final String message;
  final String? code;
  final List<String>? details;

  ChatException(this.message, {this.code, this.details});

  @override
  String toString() => 'ChatException: $message';
}

class ChatApiException extends ChatException {
  final int statusCode;

  ChatApiException(super.message, this.statusCode, {super.code, super.details});

  @override
  String toString() => 'ChatApiException: $message (Status: $statusCode)';
}

class ChatNetworkException extends ChatException {
  ChatNetworkException(super.message, {super.code, super.details});

  @override
  String toString() => 'ChatNetworkException: $message';
}

class ChatValidationException extends ChatException {
  ChatValidationException(super.message, {super.code, super.details});

  @override
  String toString() => 'ChatValidationException: $message';
}

class ChatUnauthorizedException extends ChatException {
  ChatUnauthorizedException(super.message, {super.code, super.details});

  @override
  String toString() => 'ChatUnauthorizedException: $message';
}

class ChatNotFoundException extends ChatException {
  ChatNotFoundException(super.message, {super.code, super.details});

  @override
  String toString() => 'ChatNotFoundException: $message';
} 