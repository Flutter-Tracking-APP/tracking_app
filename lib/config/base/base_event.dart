abstract base class BaseEvent {
  const BaseEvent();
}

final class DisplayError extends BaseEvent {
  final String errorMsg;
  const DisplayError(this.errorMsg);
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
