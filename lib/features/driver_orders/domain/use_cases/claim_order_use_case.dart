import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class ClaimOrderUseCase {
  final DriverOrdersRepository _repository;

  ClaimOrderUseCase(this._repository);

  Future<ApiResults<String>> call(String orderId) {
    return _repository.claimOrder(orderId);
  }
}
