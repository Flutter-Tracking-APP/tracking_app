import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

sealed class OrderDetailsEvent {
  const OrderDetailsEvent();
}

final class GetOrderDetailsEvent extends OrderDetailsEvent {
  final String orderId;
  const GetOrderDetailsEvent(this.orderId);
}

final class UpdateOrderStatusEvent extends OrderDetailsEvent {
  final String orderId;
  final OrderFulfillmentStatus targetStatus;
  const UpdateOrderStatusEvent({
    required this.orderId,
    required this.targetStatus,
  });
}

sealed class OrderDetailsUiEvent extends BaseEvent {
  const OrderDetailsUiEvent();
}

final class OrderStatusUpdatedUiEvent extends OrderDetailsUiEvent {
  final OrderFulfillmentStatus newStatus;
  const OrderStatusUpdatedUiEvent(this.newStatus);
}

final class OrderDeliveredUiEvent extends OrderDetailsUiEvent {
  const OrderDeliveredUiEvent();
}
