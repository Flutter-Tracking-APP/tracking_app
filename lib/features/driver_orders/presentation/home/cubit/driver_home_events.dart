import 'package:tracking_app/config/base/base_event.dart';

sealed class DriverHomeEvent {
  const DriverHomeEvent();
}

final class InitHomeEvent extends DriverHomeEvent {
  const InitHomeEvent();
}

final class GetAvailableOrdersEvent extends DriverHomeEvent {
  const GetAvailableOrdersEvent();
}

final class ClaimOrderEvent extends DriverHomeEvent {
  final String orderId;
  const ClaimOrderEvent(this.orderId);
}

sealed class DriverHomeUiEvent extends BaseEvent {
  const DriverHomeUiEvent();
}

final class OrderClaimedSuccessUiEvent extends DriverHomeUiEvent {
  final String orderId;
  const OrderClaimedSuccessUiEvent(this.orderId);
}

final class NavigateToActiveOrderEvent extends DriverHomeUiEvent {
  final String orderId;
  const NavigateToActiveOrderEvent(this.orderId);
}

typedef HasActiveOrderUiEvent = NavigateToActiveOrderEvent;
