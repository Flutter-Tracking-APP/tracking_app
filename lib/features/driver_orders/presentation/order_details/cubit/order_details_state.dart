import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

class OrderDetailsState extends Equatable {
  final BaseState<OrderDetailsEntity> orderDetailsState;
  final BaseState<String> updateStatusState;
  final bool isUpdatingStatus;

  const OrderDetailsState({
    this.orderDetailsState = const BaseState.initial(),
    this.updateStatusState = const BaseState.initial(),
    this.isUpdatingStatus = false,
  });

  OrderDetailsState copyWith({
    BaseState<OrderDetailsEntity>? orderDetailsState,
    BaseState<String>? updateStatusState,
    bool? isUpdatingStatus,
  }) {
    return OrderDetailsState(
      orderDetailsState: orderDetailsState ?? this.orderDetailsState,
      updateStatusState: updateStatusState ?? this.updateStatusState,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
    );
  }

  @override
  List<Object?> get props => [
        orderDetailsState,
        updateStatusState,
        isUpdatingStatus,
      ];
}
