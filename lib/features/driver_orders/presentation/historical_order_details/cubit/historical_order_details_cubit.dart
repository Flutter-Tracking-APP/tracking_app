import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_historical_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/cubit/historical_order_details_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/cubit/historical_order_details_state.dart';

@injectable
class HistoricalOrderDetailsCubit
    extends BaseCubit<HistoricalOrderDetailsState, BaseEvent> {
  final GetHistoricalOrderDetailsUseCase _getOrderDetailsUseCase;

  HistoricalOrderDetailsCubit(this._getOrderDetailsUseCase)
    : super(const HistoricalOrderDetailsState());

  void doEvent(HistoricalOrderDetailsEvent event) {
    switch (event) {
      case GetHistoricalOrderDetailsEvent(:final orderId):
        getHistoricalOrderDetails(orderId);
    }
  }

  Future<void> getHistoricalOrderDetails(String orderId) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        detailsState: BaseState(
          isLoading: true,
          errorMessage: null,
          data: state.detailsState.data,
        ),
      ),
    );

    final result = await _getOrderDetailsUseCase.call(orderId);

    if (isClosed) return;

    switch (result) {
      case Success(data: final details):
        if (isClosed) return;
        emit(state.copyWith(detailsState: BaseState.success(details)));
      case FailureResponse(:final failure):
        final errorMsg = failure is ServerFailure ? failure.message : null;
        if (isClosed) return;
        emit(
          state.copyWith(
            detailsState: BaseState(
              isLoading: false,
              errorMessage: errorMsg,
              failure: failure,
              data: state.detailsState.data,
            ),
          ),
        );
        if (isClosed) return;
        emitEvent(DisplayError(errorMsg, failure: failure));
    }
  }
}
