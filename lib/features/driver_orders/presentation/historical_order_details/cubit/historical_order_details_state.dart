import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/historical_order_details_entity.dart';

class HistoricalOrderDetailsState extends Equatable {
  final BaseState<HistoricalOrderDetailsEntity> detailsState;

  const HistoricalOrderDetailsState({
    this.detailsState = const BaseState.initial(),
  });

  HistoricalOrderDetailsState copyWith({
    BaseState<HistoricalOrderDetailsEntity>? detailsState,
  }) {
    return HistoricalOrderDetailsState(
      detailsState: detailsState ?? this.detailsState,
    );
  }

  @override
  List<Object?> get props => [detailsState];
}
