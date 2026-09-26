import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

class OrderDetailsState extends Equatable {
  final BaseState<OrderDetailsEntity> orderDetailsState;
  final BaseState<String> updateStatusState;

  const OrderDetailsState({
    this.orderDetailsState = const BaseState.initial(),
    this.updateStatusState = const BaseState.initial(),
  });

  OrderDetailsState copyWith({
    BaseState<OrderDetailsEntity>? orderDetailsState,
    BaseState<String>? updateStatusState,
  }) {
    return OrderDetailsState(
      orderDetailsState: orderDetailsState ?? this.orderDetailsState,
      updateStatusState: updateStatusState ?? this.updateStatusState,
    );
  }

  @override
  List<Object?> get props => [orderDetailsState, updateStatusState];
}
