import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_state.dart';

@injectable
class OrderDetailsCubit extends BaseCubit<OrderDetailsState, BaseEvent> {
  final GetDriverOrderDetailsUseCase _getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  OrderDetailsCubit(
    this._getOrderDetailsUseCase,
    this._updateOrderStatusUseCase,
  ) : super(const OrderDetailsState());

  void doEvent(OrderDetailsEvent event) {
    switch (event) {
      case GetOrderDetailsEvent(:final orderId):
        _getOrderDetails(orderId);
      case UpdateOrderStatusEvent(:final orderId, :final targetStatus):
        _updateOrderStatus(orderId, targetStatus);
    }
  }

  Future<void> _getOrderDetails(String orderId) async {
    emit(
      state.copyWith(
        orderDetailsState: BaseState(
          isLoading: true,
          errorMessage: null,
          data: state.orderDetailsState.data,
        ),
      ),
    );

    final result = await _getOrderDetailsUseCase.call(orderId);
    switch (result) {
      case Success(data: final details):
        emit(state.copyWith(orderDetailsState: BaseState.success(details)));
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(
          state.copyWith(
            orderDetailsState: BaseState(
              isLoading: false,
              errorMessage: errorMsg,
              data: state.orderDetailsState.data,
            ),
          ),
        );
        emitEvent(DisplayError(errorMsg));
    }
  }

  Future<void> _updateOrderStatus(
    String orderId,
    OrderFulfillmentStatus targetStatus,
  ) async {
    emit(state.copyWith(updateStatusState: BaseState.loading()));

    final statusString = _statusToApiString(targetStatus);
    final result = await _updateOrderStatusUseCase.call(orderId, statusString);

    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(updateStatusState: BaseState.success(message)));
        final currentData = state.orderDetailsState.data;
        if (currentData != null) {
          final updatedData = OrderDetailsEntity(
            id: currentData.id,
            orderNumber: currentData.orderNumber,
            status: targetStatus,
            formattedDate: currentData.formattedDate,
            store: currentData.store,
            user: currentData.user,
            items: currentData.items,
            total: currentData.total,
            paymentMethod: currentData.paymentMethod,
          );
          emit(state.copyWith(orderDetailsState: BaseState.success(updatedData)));
        }
        emitEvent(OrderStatusUpdatedUiEvent(targetStatus));
        if (targetStatus == OrderFulfillmentStatus.delivered) {
          emitEvent(const OrderDeliveredUiEvent());
        }
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(state.copyWith(updateStatusState: BaseState.error(errorMsg)));
        emitEvent(DisplayError(errorMsg));
    }
  }

  String _statusToApiString(OrderFulfillmentStatus status) {
    return switch (status) {
      OrderFulfillmentStatus.accepted => 'accepted',
      OrderFulfillmentStatus.arrivedAtPickup => 'arrived_at_pickup',
      OrderFulfillmentStatus.picked => 'picked',
      OrderFulfillmentStatus.outForDelivery => 'out_for_delivery',
      OrderFulfillmentStatus.delivered => 'delivered',
    };
  }
}
