import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/claim_order_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_available_orders_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_active_order_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_state.dart';

@injectable
class DriverHomeCubit extends BaseCubit<DriverHomeState, BaseEvent> {
  final GetAvailableOrdersUseCase _getAvailableOrdersUseCase;
  final GetDriverActiveOrderUseCase _getActiveOrderUseCase;
  final ClaimOrderUseCase _claimOrderUseCase;

  DriverHomeCubit(
    this._getAvailableOrdersUseCase,
    this._getActiveOrderUseCase,
    this._claimOrderUseCase,
  ) : super(const DriverHomeState());

  void doEvent(DriverHomeEvent event) {
    switch (event) {
      case InitHomeEvent():
        _initHome();
      case GetAvailableOrdersEvent():
        _getAvailableOrders();
      case ClaimOrderEvent(:final orderId):
        _claimOrder(orderId);
      case ClearActiveOrderEvent():
        clearActiveOrder();
    }
  }

  void clearActiveOrder() {
    if (isClosed) return;
    emit(state.copyWith(activeOrder: null, checkingActiveOrder: false));
  }

  Future<void> _initHome() async {
    log(
      'DriverHomeCubit: _initHome started, emitting checkingActiveOrder = true',
    );
    if (isClosed) return;
    emit(state.copyWith(checkingActiveOrder: true));

    final activeResult = await _getActiveOrderUseCase.call();
    log('DriverHomeCubit: _getActiveOrderUseCase result: $activeResult');
    if (isClosed) return;

    switch (activeResult) {
      case Success(data: final active)
          when active != null && active.id.isNotEmpty:
        log(
          'DriverHomeCubit: active order found -> id: ${active.id}, status: ${active.status}',
        );
        if (isClosed) return;
        emit(
          state.copyWith(
            checkingActiveOrder: false,
            activeOrder: active,
            ordersState: const BaseState.initial(),
          ),
        );
        if (isClosed) return;
        emitEvent(NavigateToActiveOrderEvent(active.id));
        return;
      case Success(data: final active):
        log('DriverHomeCubit: no active order found (active: $active)');
      case Failure(error: final error, message: final msg):
        log('DriverHomeCubit: getActiveOrder failure: msg=$msg, error=$error');
    }

    if (isClosed) return;
    emit(state.copyWith(checkingActiveOrder: false, activeOrder: null));
    await _getAvailableOrders();
  }

  Future<void> _getAvailableOrders() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        ordersState: BaseState(
          isLoading: true,
          errorMessage: null,
          data: state.ordersState.data,
        ),
      ),
    );

    final result = await _getAvailableOrdersUseCase.call();
    if (isClosed) return;
    switch (result) {
      case Success(data: final orders):
        emit(
          state.copyWith(ordersState: BaseState.success(_sortOrders(orders))),
        );
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(
          state.copyWith(
            ordersState: BaseState(
              isLoading: false,
              errorMessage: errorMsg,
              data: state.ordersState.data,
            ),
          ),
        );
        if (isClosed) return;
        emitEvent(DisplayError(errorMsg));
    }
  }

  List<OrderEntity> _sortOrders(List<OrderEntity> orders) {
    return List<OrderEntity>.from(orders)..sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        final dateA = DateTime.tryParse(a.createdAt!);
        final dateB = DateTime.tryParse(b.createdAt!);
        if (dateA != null && dateB != null) {
          final cmp = dateB.compareTo(dateA);
          if (cmp != 0) return cmp;
        }
      }
      return b.id.compareTo(a.id);
    });
  }

  Future<void> _claimOrder(String orderId) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        claimingOrderId: orderId,
        claimOrderState: BaseState.loading(),
      ),
    );
    final result = await _claimOrderUseCase.call(orderId);
    if (isClosed) return;
    switch (result) {
      case Success(data: final message):
        emit(
          state.copyWith(
            claimingOrderId: null,
            claimOrderState: BaseState.success(message),
          ),
        );
        if (isClosed) return;
        emitEvent(OrderClaimedSuccessUiEvent(orderId));
      case Failure(error: final error, message: final msg)
          when error == AppError.conflict:
        emit(
          state.copyWith(
            claimingOrderId: null,
            claimOrderState: BaseState.error(msg ?? 'Conflict'),
          ),
        );
        if (msg != null && msg.isNotEmpty && !isClosed) {
          emitEvent(DisplayError(msg));
        }
        await _handleConflictActiveOrder();
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(
          state.copyWith(
            claimingOrderId: null,
            claimOrderState: BaseState.error(errorMsg),
          ),
        );
        if (isClosed) return;
        emitEvent(DisplayError(errorMsg));
    }
  }

  Future<void> _handleConflictActiveOrder() async {
    log('DriverHomeCubit: _handleConflictActiveOrder started');
    if (isClosed) return;
    emit(state.copyWith(checkingActiveOrder: true));
    final activeResult = await _getActiveOrderUseCase.call();
    log('DriverHomeCubit: _handleConflictActiveOrder result: $activeResult');
    if (isClosed) return;
    switch (activeResult) {
      case Success(data: final active)
          when active != null && active.id.isNotEmpty:
        log(
          'DriverHomeCubit: active order found from conflict -> id: ${active.id}',
        );
        emit(
          state.copyWith(
            checkingActiveOrder: false,
            activeOrder: active,
            ordersState: const BaseState.initial(),
          ),
        );
        if (isClosed) return;
        emitEvent(NavigateToActiveOrderEvent(active.id));
        return;
      case _:
        emit(state.copyWith(checkingActiveOrder: false));
        break;
    }
  }
}
