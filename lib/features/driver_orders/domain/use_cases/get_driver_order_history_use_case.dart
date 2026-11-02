import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class GetDriverOrderHistoryUseCase {
  final DriverOrdersRepository _repository;

  GetDriverOrderHistoryUseCase(this._repository);

  Future<ApiResults<List<OrderHistoryEntity>>> call({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) {
    return _repository.getDriverOrderHistory(
      page: page,
      pageSize: pageSize,
      status: status,
    );
  }
}
