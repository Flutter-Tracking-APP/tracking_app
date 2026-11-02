import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/historical_order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class GetHistoricalOrderDetailsUseCase {
  final DriverOrdersRepository _repository;

  GetHistoricalOrderDetailsUseCase(this._repository);

  Future<ApiResults<HistoricalOrderDetailsEntity>> call(String orderId) {
    return _repository.getHistoricalOrderDetails(orderId);
  }
}
