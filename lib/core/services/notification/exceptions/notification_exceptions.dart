import 'notification_failure.dart';

class NotificationExceptions {
  static NotificationFailure handleNotificationException(Exception exception) {
    final exceptionMessage = exception.toString();
    if (exceptionMessage.contains('permission_denied')) {
      return NotificationFailure.permissionDenied(exceptionMessage);
    }
    else if (exceptionMessage.contains('not_initialized')) {
      return NotificationFailure.notInitialized(exceptionMessage);
    }
    else if (exceptionMessage.contains('invalid_notification')) {
      return NotificationFailure.invalidNotification(exceptionMessage);
    }
    else if (exceptionMessage.contains('cancellation_failed')) {
      return NotificationFailure.cancellationFailed(exceptionMessage);
    }
    else if (exceptionMessage.contains('platform_error')) {
      return NotificationFailure.platformError(exceptionMessage);
    }
    else if (exceptionMessage.contains('scheduling_failed')) {
      return NotificationFailure.schedulingFailed(exceptionMessage);
    }
    else {
      return NotificationFailure.unknown(exceptionMessage);
    }
  }
}