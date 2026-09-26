import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders/data/client/driver_orders_api_client.dart';
import 'package:tracking_app/features/driver_orders/data/data_sources/contract/driver_orders_remote_data_source.dart';
import 'package:tracking_app/features/driver_orders/data/models/request/update_order_status_request_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_action_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_details_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/update_order_status_response_dto.dart';

@Injectable(as: DriverOrdersRemoteDataSource)
class DriverOrdersRemoteDataSourceImpl implements DriverOrdersRemoteDataSource {
  final DriverOrdersApiClient _apiClient;

  DriverOrdersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AvailableOrdersResponseDto> getAvailableOrders() {
    return _apiClient.getAvailableOrders();
  }

  @override
  Future<OrderActionResponseDto> claimOrder(String orderId) {
    return _apiClient.claimOrder(orderId);
  }

  @override
  Future<OrderDetailsResponseDto> getOrderDetails(String orderId) {
    return _apiClient.getOrderDetails(orderId);
  }

  @override
  Future<UpdateOrderStatusResponseDto> updateOrderStatus(
    String orderId,
    UpdateOrderStatusRequestDto request,
  ) {
    return _apiClient.updateOrderStatus(orderId, request);
  }

  @override
  Future<OrderDetailsResponseDto> getAssignedOrder() {
    return _apiClient.getAssignedOrder();
  }
}
