import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/errors/app_failure.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/historical_order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/claim_order_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_available_orders_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_active_order_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_events.dart';

class FakeDriverHomeRepository implements DriverOrdersRepository {
  ApiResults<List<OrderEntity>> availableOrdersResult = const Success([]);
  ApiResults<OrderDetailsEntity?> activeOrderResult = const Success(null);
  ApiResults<String> claimOrderResult = const Success('Claimed');

  @override
  Future<ApiResults<List<OrderEntity>>> getAvailableOrders() async =>
      availableOrdersResult;

  @override
  Future<ApiResults<OrderDetailsEntity?>> getActiveOrder() async =>
      activeOrderResult;

  @override
  Future<ApiResults<String>> claimOrder(String orderId) async =>
      claimOrderResult;

  @override
  Future<ApiResults<OrderDetailsEntity>> getOrderDetails(String orderId) =>
      throw UnimplementedError();

  @override
  Future<ApiResults<List<OrderHistoryEntity>>> getDriverOrderHistory({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) =>
      throw UnimplementedError();

  @override
  Future<ApiResults<HistoricalOrderDetailsEntity>> getHistoricalOrderDetails(
    String orderId,
  ) =>
      throw UnimplementedError();

  @override
  Future<ApiResults<String>> updateOrderStatus(
    String orderId,
    String status, {
    String? note,
  }) =>
      throw UnimplementedError();
}

OrderEntity createDummyOrder({required String id, String? createdAt}) {
  return OrderEntity(
    id: id,
    title: 'Order $id',
    totalAmount: 100,
    status: 'pending',
    storeName: 'Test Store',
    storeAddress: 'Test Store Address',
    customerName: 'Test Customer',
    customerAddress: 'Test Customer Address',
    createdAt: createdAt,
  );
}

void main() {
  group('DriverHomeCubit AppFailure Propagation Tests', () {
    late FakeDriverHomeRepository repo;
    late DriverHomeCubit cubit;

    setUp(() {
      repo = FakeDriverHomeRepository();
      cubit = DriverHomeCubit(
        GetAvailableOrdersUseCase(repo),
        GetDriverActiveOrderUseCase(repo),
        ClaimOrderUseCase(repo),
      );
    });

    tearDown(() {
      cubit.close();
    });

    test(
      'captures and emits NetworkFailure in ordersState and DisplayError event',
      () async {
        const failure = NetworkFailure(AppError.noConnection);
        repo.availableOrdersResult = const Failure(
          'No internet connection',
          AppError.noConnection,
          failure,
        );

        final events = <BaseEvent>[];
        final subscription = cubit.eventStream.listen(events.add);

        cubit.doEvent(const GetAvailableOrdersEvent());
        await pumpEventQueue();

        expect(cubit.state.ordersState.isLoading, isFalse);
        expect(cubit.state.ordersState.failure, equals(failure));
        expect(events, hasLength(1));
        expect(events.first, isA<DisplayError>());
        final displayError = events.first as DisplayError;
        expect(displayError.failure, equals(failure));

        await subscription.cancel();
      },
    );

    test(
      'captures and emits ServerMessageFailure in ordersState and DisplayError event',
      () async {
        const failure = ServerMessageFailure('Internal server error');
        repo.availableOrdersResult = const Failure(
          'Internal server error',
          AppError.server,
          failure,
        );

        final events = <BaseEvent>[];
        final subscription = cubit.eventStream.listen(events.add);

        cubit.doEvent(const GetAvailableOrdersEvent());
        await pumpEventQueue();

        expect(cubit.state.ordersState.isLoading, isFalse);
        expect(cubit.state.ordersState.failure, equals(failure));
        expect(
          cubit.state.ordersState.errorMessage,
          equals('Internal server error'),
        );
        expect(events, hasLength(1));
        expect(events.first, isA<DisplayError>());
        final displayError = events.first as DisplayError;
        expect(displayError.failure, equals(failure));
        expect(displayError.errorMsg, equals('Internal server error'));

        await subscription.cancel();
      },
    );

    test(
      'propagates AppFailure in claimOrderState and DisplayError on claim failure',
      () async {
        const failure = ServerMessageFailure('Order already taken');
        repo.claimOrderResult = const Failure(
          'Order already taken',
          AppError.badRequest,
          failure,
        );

        final events = <BaseEvent>[];
        final subscription = cubit.eventStream.listen(events.add);

        cubit.doEvent(const ClaimOrderEvent('order-123'));
        await pumpEventQueue();

        expect(cubit.state.claimOrderState.isLoading, isFalse);
        expect(cubit.state.claimOrderState.failure, equals(failure));
        expect(events, hasLength(1));
        expect(events.first, isA<DisplayError>());
        final displayError = events.first as DisplayError;
        expect(displayError.failure, equals(failure));

        await subscription.cancel();
      },
    );

    test('sorts available orders descending by createdAt and then id', () async {
      repo.availableOrdersResult = Success([
        createDummyOrder(id: '1', createdAt: '2026-10-01T10:00:00Z'),
        createDummyOrder(id: '3', createdAt: '2026-10-01T12:00:00Z'),
        createDummyOrder(id: '2', createdAt: '2026-10-01T11:00:00Z'),
      ]);

      cubit.doEvent(const GetAvailableOrdersEvent());
      await pumpEventQueue();

      expect(cubit.state.ordersState.isLoading, isFalse);
      expect(cubit.state.ordersState.data?.map((o) => o.id).toList(), [
        '3',
        '2',
        '1',
      ]);
    });
  });
}
