import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/data/data_sources/contract/driver_orders_remote_data_source.dart';
import 'package:tracking_app/features/driver_orders/data/models/request/update_order_status_request_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_action_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_details_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/update_order_status_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/repositories/driver_orders_repository_impl.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

class FakeRemoteDataSource implements DriverOrdersRemoteDataSource {
  OrderDetailsResponseDto? assignedOrderResponse;
  bool shouldThrowOnAssigned = false;
  int assignedThrowStatusCode = 404;

  @override
  Future<AvailableOrdersResponseDto> getAvailableOrders() async =>
      const AvailableOrdersResponseDto(orders: []);

  @override
  Future<OrderActionResponseDto> claimOrder(String orderId) async =>
      const OrderActionResponseDto(message: 'Claimed');

  @override
  Future<OrderDetailsResponseDto> getOrderDetails(String orderId) async =>
      const OrderDetailsResponseDto(
        order: OrderDetailsDataDto(
          orderId: 'ord-details-1',
          status: 'accepted',
        ),
      );

  @override
  Future<UpdateOrderStatusResponseDto> updateOrderStatus(
    String orderId,
    UpdateOrderStatusRequestDto request,
  ) async =>
      const UpdateOrderStatusResponseDto(message: 'Updated');

  @override
  Future<OrderDetailsResponseDto> getAssignedOrder() async {
    if (shouldThrowOnAssigned) {
      throw DioException(
        requestOptions: RequestOptions(path: 'api/orders/drivers/me/assigned-order'),
        response: Response(
          requestOptions: RequestOptions(path: 'api/orders/drivers/me/assigned-order'),
          statusCode: assignedThrowStatusCode,
        ),
      );
    }
    return assignedOrderResponse ?? const OrderDetailsResponseDto();
  }
}

void main() {
  late FakeRemoteDataSource fakeRemoteDataSource;
  late DriverOrdersRepositoryImpl repository;

  setUp(() {
    fakeRemoteDataSource = FakeRemoteDataSource();
    repository = DriverOrdersRepositoryImpl(fakeRemoteDataSource);
  });

  group('DriverOrdersRepositoryImpl.getActiveOrder (getAssignedOrder)', () {
    test('returns Success(entity) when assigned order is active', () async {
      fakeRemoteDataSource.assignedOrderResponse = const OrderDetailsResponseDto(
        data: OrderDetailsDataDto(
          id: 'f9e9668b-1fbc-4149-ac10-2339e51c21f2',
          orderNumber: 'ORD-20260905-4D13D1',
          status: 'PLACED',
          total: 58.98,
        ),
      );

      final result = await repository.getActiveOrder();

      expect(result, isA<Success<OrderDetailsEntity?>>());
      final data = (result as Success<OrderDetailsEntity?>).data;
      expect(data, isNotNull);
      expect(data!.id, equals('f9e9668b-1fbc-4149-ac10-2339e51c21f2'));
      expect(data.orderNumber, equals('ORD-20260905-4D13D1'));
      expect(data.status, equals(OrderFulfillmentStatus.accepted));
      expect(data.total, equals(58.98));
    });

    test('returns Success(null) when assigned order response has no data', () async {
      fakeRemoteDataSource.assignedOrderResponse = const OrderDetailsResponseDto(
        data: null,
      );

      final result = await repository.getActiveOrder();

      expect(result, isA<Success<OrderDetailsEntity?>>());
      expect((result as Success<OrderDetailsEntity?>).data, isNull);
    });

    test('returns Success(null) when assigned order is delivered', () async {
      fakeRemoteDataSource.assignedOrderResponse = const OrderDetailsResponseDto(
        data: OrderDetailsDataDto(
          id: 'ord-delivered',
          status: 'DELIVERED',
        ),
      );

      final result = await repository.getActiveOrder();

      expect(result, isA<Success<OrderDetailsEntity?>>());
      expect((result as Success<OrderDetailsEntity?>).data, isNull);
    });

    test('returns Success(null) when getAssignedOrder throws 404 (no assigned order)', () async {
      fakeRemoteDataSource.shouldThrowOnAssigned = true;
      fakeRemoteDataSource.assignedThrowStatusCode = 404;

      final result = await repository.getActiveOrder();

      expect(result, isA<Success<OrderDetailsEntity?>>());
      expect((result as Success<OrderDetailsEntity?>).data, isNull);
    });

    test('claimOrder and updateOrderStatus execute successfully', () async {
      final claimResult = await repository.claimOrder('ord-123');
      expect(claimResult, isA<Success<String>>());

      final updateResult = await repository.updateOrderStatus('ord-123', 'delivered');
      expect(updateResult, isA<Success<String>>());
    });
  });
}
