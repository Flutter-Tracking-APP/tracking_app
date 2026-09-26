import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class UpdateOrderStatusUseCase {
  final DriverOrdersRepository _repository;

  UpdateOrderStatusUseCase(this._repository);

  Future<ApiResults<String>> call(
    String orderId,
    String status, {
    String? note,
  }) {
    return _repository.updateOrderStatus(orderId, status, note: note);
  }
}
