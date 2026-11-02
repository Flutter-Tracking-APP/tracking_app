import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class GetAvailableOrdersUseCase {
  final DriverOrdersRepository _repository;

  GetAvailableOrdersUseCase(this._repository);

  Future<ApiResults<List<OrderEntity>>> call() {
    return _repository.getAvailableOrders();
  }
}
