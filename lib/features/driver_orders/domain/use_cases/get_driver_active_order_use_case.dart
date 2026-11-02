import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class GetDriverActiveOrderUseCase {
  final DriverOrdersRepository _repository;

  GetDriverActiveOrderUseCase(this._repository);

  Future<ApiResults<OrderDetailsEntity?>> call() {
    return _repository.getActiveOrder();
  }
}
