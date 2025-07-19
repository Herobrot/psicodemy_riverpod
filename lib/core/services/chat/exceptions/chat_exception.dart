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

  ChatApiException(String message, this.statusCode, {String? code, List<String>? details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ChatApiException: $message (Status: $statusCode)';
}

class ChatNetworkException extends ChatException {
  ChatNetworkException(String message, {String? code, List<String>? details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ChatNetworkException: $message';
}

class ChatValidationException extends ChatException {
  ChatValidationException(String message, {String? code, List<String>? details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ChatValidationException: $message';
}

class ChatUnauthorizedException extends ChatException {
  ChatUnauthorizedException(String message, {String? code, List<String>? details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ChatUnauthorizedException: $message';
}

class ChatNotFoundException extends ChatException {
  ChatNotFoundException(String message, {String? code, List<String>? details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ChatNotFoundException: $message';
} 