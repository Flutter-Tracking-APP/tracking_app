import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';

class DriverHomeState extends Equatable {
  final BaseState<List<OrderEntity>> ordersState;
  final BaseState<String> claimOrderState;
  final String? claimingOrderId;
  final OrderDetailsEntity? activeOrder;
  final bool checkingActiveOrder;

  const DriverHomeState({
    this.ordersState = const BaseState.initial(),
    this.claimOrderState = const BaseState.initial(),
    this.claimingOrderId,
    this.activeOrder,
    this.checkingActiveOrder = true,
  });

  DriverHomeState copyWith({
    BaseState<List<OrderEntity>>? ordersState,
    BaseState<String>? claimOrderState,
    Object? claimingOrderId = unset,
    Object? activeOrder = unset,
    bool? checkingActiveOrder,
  }) {
    return DriverHomeState(
      ordersState: ordersState ?? this.ordersState,
      claimOrderState: claimOrderState ?? this.claimOrderState,
      claimingOrderId: identical(claimingOrderId, unset)
          ? this.claimingOrderId
          : claimingOrderId as String?,
      activeOrder: identical(activeOrder, unset)
          ? this.activeOrder
          : activeOrder as OrderDetailsEntity?,
      checkingActiveOrder: checkingActiveOrder ?? this.checkingActiveOrder,
    );
  }

  @override
  List<Object?> get props => [
    ordersState,
    claimOrderState,
    claimingOrderId,
    activeOrder,
    checkingActiveOrder,
  ];
}
