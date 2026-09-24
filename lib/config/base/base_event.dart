sealed class BaseEvent {
  const BaseEvent();
}

class DisplayError extends BaseEvent {
  final String errorMsg;
  const DisplayError(this.errorMsg);
}

class DisplaySuccess extends BaseEvent {
  final String successMsg;
  const DisplaySuccess(this.successMsg);
}

class NavigateEvent extends BaseEvent {
  final String routeName;
  final Object? extra;
  const NavigateEvent(this.routeName, {this.extra});
}

class CustomUiEvent extends BaseEvent {
  final Object? data;
  const CustomUiEvent([this.data]);
}
