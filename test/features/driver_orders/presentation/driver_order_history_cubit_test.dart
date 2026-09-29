import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_history_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/historical_order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_events.dart';

class MockOrderHistoryRepository implements DriverOrdersRepository {
  List<OrderHistoryEntity> ordersToReturn = [];
  bool returnError = false;

  @override
  Future<ApiResults<List<OrderHistoryEntity>>> getDriverOrderHistory({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    if (returnError) {
      return const Failure('Network error', AppError.noConnection);
    }
    return Success(ordersToReturn);
  }

  @override
  Future<ApiResults<List<OrderEntity>>> getAvailableOrders() async =>
      const Success([]);

  @override
  Future<ApiResults<String>> claimOrder(String orderId) async =>
      const Success('ok');

  @override
  Future<ApiResults<OrderDetailsEntity>> getOrderDetails(
    String orderId,
  ) async => throw UnimplementedError();

  @override
  Future<ApiResults<String>> updateOrderStatus(
    String orderId,
    String status, {
    String? note,
  }) async => const Success('ok');

  @override
  Future<ApiResults<OrderDetailsEntity?>> getActiveOrder() async =>
      const Success(null);

  @override
  Future<ApiResults<HistoricalOrderDetailsEntity>> getHistoricalOrderDetails(
    String orderId,
  ) async => throw UnimplementedError();
}

void main() {
  late MockOrderHistoryRepository repository;
  late GetDriverOrderHistoryUseCase useCase;
  late DriverOrderHistoryCubit cubit;

  final sampleOrders = [
    const OrderHistoryEntity(
      id: 'ord-1',
      orderNumber: '111',
      status: 'DELIVERED',
      statusDisplay: 'Delivered',
      placedAt: '2026-09-25T10:00:00Z',
      itemCount: 1,
      total: 100,
      store: StoreAddressEntity(name: 'Store 1', address: 'Address 1'),
      user: UserAddressEntity(name: 'User 1', address: 'User Address 1'),
    ),
    const OrderHistoryEntity(
      id: 'ord-2',
      orderNumber: '222',
      status: 'CANCELLED',
      statusDisplay: 'Cancelled',
      placedAt: '2026-09-26T12:00:00Z', // newer
      itemCount: 2,
      total: 200,
      store: StoreAddressEntity(name: 'Store 2', address: 'Address 2'),
      user: UserAddressEntity(name: 'User 2', address: 'User Address 2'),
    ),
  ];

  setUp(() {
    repository = MockOrderHistoryRepository();
    useCase = GetDriverOrderHistoryUseCase(repository);
    cubit = DriverOrderHistoryCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('DriverOrderHistoryCubit', () {
    test('initial state has default empty values', () {
      expect(cubit.state.historyState.isLoading, isFalse);
      expect(cubit.state.historyState.data, isNull);
      expect(cubit.state.cancelledCount, equals(0));
      expect(cubit.state.completedCount, equals(0));
    });

    test(
      'getOrderHistory sorts descending by placedAt and updates counts',
      () async {
        repository.ordersToReturn = sampleOrders;

        await cubit.getOrderHistory();

        expect(cubit.state.historyState.isLoading, isFalse);
        expect(cubit.state.historyState.data?.length, equals(2));
        // ord-2 is newer so should be first
        expect(cubit.state.historyState.data?.first.id, equals('ord-2'));
        expect(cubit.state.historyState.data?.last.id, equals('ord-1'));
        expect(cubit.state.cancelledCount, equals(1));
        expect(cubit.state.completedCount, equals(1));
      },
    );

    test(
      'getOrderHistory handles failure and emits DisplayError event',
      () async {
        repository.returnError = true;

        BaseEvent? emittedEvent;
        final sub = cubit.eventStream.listen((event) => emittedEvent = event);

        await cubit.getOrderHistory();
        await pumpEventQueue();

        expect(cubit.state.historyState.isLoading, isFalse);
        expect(cubit.state.historyState.errorMessage, equals('Network error'));
        expect(emittedEvent, isA<DisplayError>());

        await sub.cancel();
      },
    );

    test('safe emit does not throw when cubit is closed', () async {
      repository.ordersToReturn = sampleOrders;
      await cubit.close();
      expect(() => cubit.getOrderHistory(), returnsNormally);
    });

    test(
      'doEvent handles GetDriverOrderHistoryEvent and RefreshOrderHistoryEvent',
      () async {
        repository.ordersToReturn = sampleOrders;

        cubit.doEvent(const GetDriverOrderHistoryEvent());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(cubit.state.historyState.data?.length, equals(2));

        cubit.doEvent(const RefreshOrderHistoryEvent());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(cubit.state.historyState.data?.length, equals(2));
      },
    );
  });
}
