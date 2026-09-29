import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';

class DriverOrderHistoryState extends Equatable {
  final BaseState<List<OrderHistoryEntity>> historyState;
  final int cancelledCount;
  final int completedCount;

  const DriverOrderHistoryState({
    this.historyState = const BaseState.initial(),
    this.cancelledCount = 0,
    this.completedCount = 0,
  });

  DriverOrderHistoryState copyWith({
    BaseState<List<OrderHistoryEntity>>? historyState,
    int? cancelledCount,
    int? completedCount,
  }) {
    return DriverOrderHistoryState(
      historyState: historyState ?? this.historyState,
      cancelledCount: cancelledCount ?? this.cancelledCount,
      completedCount: completedCount ?? this.completedCount,
    );
  }

  @override
  List<Object?> get props => [historyState, cancelledCount, completedCount];
}
