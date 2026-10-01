import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_history_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_state.dart';

@injectable
class DriverOrderHistoryCubit
    extends BaseCubit<DriverOrderHistoryState, BaseEvent> {
  final GetDriverOrderHistoryUseCase _getOrderHistoryUseCase;

  DriverOrderHistoryCubit(this._getOrderHistoryUseCase)
    : super(const DriverOrderHistoryState());

  void doEvent(DriverOrderHistoryEvent event) {
    switch (event) {
      case GetDriverOrderHistoryEvent(
        :final page,
        :final pageSize,
        :final status,
      ):
        getOrderHistory(page: page, pageSize: pageSize, status: status);
      case RefreshOrderHistoryEvent():
        getOrderHistory();
    }
  }

  Future<void> getOrderHistory({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        historyState: BaseState(
          isLoading: true,
          errorMessage: null,
          data: state.historyState.data,
        ),
      ),
    );

    final result = await _getOrderHistoryUseCase.call(
      page: page,
      pageSize: pageSize,
      status: status,
    );

    if (isClosed) return;

    switch (result) {
      case Success(data: final orders):
        final sorted = _sortOrders(orders);
        final cancelled = sorted.where((o) => o.isCancelled).length;
        final completed = sorted.where((o) => o.isCompleted).length;
        if (isClosed) return;
        emit(
          state.copyWith(
            historyState: BaseState.success(sorted),
            cancelledCount: cancelled,
            completedCount: completed,
          ),
        );
      case Failure(:final failure, error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        if (isClosed) return;
        emit(
          state.copyWith(
            historyState: BaseState(
              isLoading: false,
              errorMessage: errorMsg,
              failure: failure,
              data: state.historyState.data,
            ),
          ),
        );
        if (isClosed) return;
        emitEvent(DisplayError(errorMsg, failure: failure));
    }
  }

  List<OrderHistoryEntity> _sortOrders(List<OrderHistoryEntity> orders) {
    return List<OrderHistoryEntity>.from(orders)..sort((a, b) {
      if (a.placedAt != null && b.placedAt != null) {
        final dateA = DateTime.tryParse(a.placedAt!);
        final dateB = DateTime.tryParse(b.placedAt!);
        if (dateA != null && dateB != null) {
          final cmp = dateB.compareTo(dateA); // newest first
          if (cmp != 0) return cmp;
        }
      }
      return b.id.compareTo(a.id);
    });
  }
}
