import 'package:tracking_app/core/errors/app_failure.dart';

abstract base class BaseEvent {
  const BaseEvent();
}

final class DisplayError extends BaseEvent {
  final String errorMsg;
  final AppFailure? failure;

  const DisplayError(this.errorMsg, {this.failure});

  factory DisplayError.fromFailure(
    AppFailure failure, [
    String fallback = 'An error occurred',
  ]) => DisplayError(
        failure is ServerMessageFailure ? failure.message : fallback,
        failure: failure,
      );
}

final class DisplaySuccess extends BaseEvent {
  final String successMsg;
  const DisplaySuccess(this.successMsg);
}

final class NavigateEvent extends BaseEvent {
  final String routeName;
  final Object? extra;
  const NavigateEvent(this.routeName, {this.extra});
}
