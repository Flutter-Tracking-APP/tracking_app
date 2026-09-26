import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';

abstract class DriverOrdersRepository {
  Future<ApiResults<List<OrderEntity>>> getAvailableOrders();
  Future<ApiResults<String>> claimOrder(String orderId);
  Future<ApiResults<OrderDetailsEntity>> getOrderDetails(String orderId);
  Future<ApiResults<String>> updateOrderStatus(
    String orderId,
    String status, {
    String? note,
  });
  Future<ApiResults<OrderDetailsEntity?>> getActiveOrder();
}
