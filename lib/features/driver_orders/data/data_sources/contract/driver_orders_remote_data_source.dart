import 'package:tracking_app/features/driver_orders/data/models/request/update_order_status_request_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_action_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_details_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/update_order_status_response_dto.dart';

abstract class DriverOrdersRemoteDataSource {
  Future<AvailableOrdersResponseDto> getAvailableOrders();
  Future<OrderActionResponseDto> claimOrder(String orderId);
  Future<OrderDetailsResponseDto> getOrderDetails(String orderId);
  Future<UpdateOrderStatusResponseDto> updateOrderStatus(
    String orderId,
    UpdateOrderStatusRequestDto request,
  );
  Future<OrderDetailsResponseDto> getAssignedOrder();
}
