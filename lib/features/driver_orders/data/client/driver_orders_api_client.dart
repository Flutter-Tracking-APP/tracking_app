import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/const/endpoints.dart';
import 'package:tracking_app/features/driver_orders/data/models/request/update_order_status_request_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_action_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_details_response_dto.dart';

part 'driver_orders_api_client.g.dart';

@singleton
@RestApi()
abstract class DriverOrdersApiClient {
  @factoryMethod
  factory DriverOrdersApiClient(Dio dio) = _DriverOrdersApiClient;

  @GET(Endpoints.availableOrders)
  Future<AvailableOrdersResponseDto> getAvailableOrders();

  @POST(Endpoints.claimOrder)
  Future<OrderActionResponseDto> claimOrder(@Path('orderId') String orderId);

  @GET(Endpoints.driverOrderDetails)
  Future<OrderDetailsResponseDto> getOrderDetails(
    @Path('orderId') String orderId,
  );

  @PUT(Endpoints.updateOrderStatus)
  Future<OrderActionResponseDto> updateOrderStatus(
    @Path('orderId') String orderId,
    @Body() UpdateOrderStatusRequestDto request,
  );

  @GET(Endpoints.driverAssignedOrder)
  Future<OrderDetailsResponseDto> getAssignedOrder();
}
