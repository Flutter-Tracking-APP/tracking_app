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
        getOrderDetails(orderId);
      case UpdateOrderStatusEvent(:final orderId, :final targetStatus):
        _updateOrderStatus(orderId, targetStatus);
      case UpdateNextStatusEvent(:final orderId):
        updateNextStatus(orderId);
    }
  }

  Future<void> getOrderDetails(String orderId) async {
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

  Future<void> updateNextStatus(String orderId) async {
    final currentOrder = state.orderDetailsState.data;
    if (currentOrder == null) return;

    final transition = _getNextTransition(currentOrder.status);
    if (transition == null) return;

    final (targetStatus, note, nextEnum) = transition;
    emit(state.copyWith(
      isUpdatingStatus: true,
      updateStatusState: BaseState.loading(),
    ));

    final result = await _updateOrderStatusUseCase.call(
      orderId,
      targetStatus,
      note: note,
    );

    _handleUpdateResult(result, nextEnum);
  }

  void _handleUpdateResult(
    ApiResults<String> result,
    OrderFulfillmentStatus nextStatus,
  ) {
    switch (result) {
      case Success(data: final message):
        _onUpdateSuccess(message, nextStatus);
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(state.copyWith(
          isUpdatingStatus: false,
          updateStatusState: BaseState.error(errorMsg),
        ));
        emitEvent(DisplayError(errorMsg));
    }
  }

  void _onUpdateSuccess(String message, OrderFulfillmentStatus nextStatus) {
    final currentData = state.orderDetailsState.data;
    if (currentData != null) {
      final updatedData = OrderDetailsEntity(
        id: currentData.id,
        orderNumber: currentData.orderNumber,
        status: nextStatus,
        formattedDate: currentData.formattedDate,
        store: currentData.store,
        user: currentData.user,
        items: currentData.items,
        total: currentData.total,
        paymentMethod: currentData.paymentMethod,
      );
      emit(state.copyWith(
        orderDetailsState: BaseState.success(updatedData),
        isUpdatingStatus: false,
        updateStatusState: BaseState.success(message),
      ));
    } else {
      emit(state.copyWith(
        isUpdatingStatus: false,
        updateStatusState: BaseState.success(message),
      ));
    }
    emitEvent(OrderStatusUpdatedUiEvent(nextStatus));
    if (nextStatus == OrderFulfillmentStatus.delivered) {
      emitEvent(const OrderDeliveredUiEvent());
    }
  }

  (String, String, OrderFulfillmentStatus)? _getNextTransition(
    OrderFulfillmentStatus currentStatus,
  ) {
    return switch (currentStatus) {
      OrderFulfillmentStatus.accepted ||
      OrderFulfillmentStatus.arrivedAtPickup => (
          'PICKED_UP',
          'Collected from pickup store',
          OrderFulfillmentStatus.picked,
        ),
      OrderFulfillmentStatus.picked => (
          'OUT_FOR_DELIVERY',
          'Heading to customer',
          OrderFulfillmentStatus.outForDelivery,
        ),
      OrderFulfillmentStatus.outForDelivery => (
          'ARRIVED',
          'Driver reached the delivery address',
          OrderFulfillmentStatus.arrived,
        ),
      OrderFulfillmentStatus.arrived => (
          'AWAITING_DELIVERY_CONFIRMATION',
          'Order handed to customer',
          OrderFulfillmentStatus.delivered,
        ),
      OrderFulfillmentStatus.delivered => null,
    };
  }

  Future<void> _updateOrderStatus(
    String orderId,
    OrderFulfillmentStatus targetStatus,
  ) =>
      updateNextStatus(orderId);
}
