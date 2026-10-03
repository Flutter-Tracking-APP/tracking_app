import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/historical_order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_item_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_historical_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/cubit/historical_order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/cubit/historical_order_details_events.dart';

class MockHistoricalDetailsRepository implements DriverOrdersRepository {
  HistoricalOrderDetailsEntity? detailsToReturn;
  bool returnError = false;

  @override
  Future<ApiResults<HistoricalOrderDetailsEntity>> getHistoricalOrderDetails(
    String orderId,
  ) async {
    if (returnError) {
      return const FailureResponse(
        ServerFailure(
          error: AppError.server,
          message: 'Details error',
        ),
      );
    }
    return Success(detailsToReturn!);
  }

  @override
  Future<ApiResults<List<OrderHistoryEntity>>> getDriverOrderHistory({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async => const Success([]);

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
}

void main() {
  late MockHistoricalDetailsRepository repository;
  late GetHistoricalOrderDetailsUseCase useCase;
  late HistoricalOrderDetailsCubit cubit;

  const sampleDetails = HistoricalOrderDetailsEntity(
    id: 'ord-hist-1',
    orderNumber: 'ORD-999',
    status: 'DELIVERED',
    statusDisplay: 'Delivered',
    placedAt: '2026-09-26T10:00:00Z',
    subtotal: 100,
    deliveryFee: 20,
    total: 120,
    paymentMethod: 'Cod',
    paymentMethodDisplay: 'Cash on delivery',
    store: StoreAddressEntity(name: 'Store Flowery', address: 'Cairo'),
    user: UserAddressEntity(name: 'Ali Recipient', address: 'Giza'),
    items: [
      OrderItemEntity(
        id: 'item-1',
        title: 'Red Roses',
        price: 100,
        quantity: 1,
      ),
    ],
  );

  setUp(() {
    repository = MockHistoricalDetailsRepository();
    useCase = GetHistoricalOrderDetailsUseCase(repository);
    cubit = HistoricalOrderDetailsCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('HistoricalOrderDetailsCubit', () {
    test('initial state is initial', () {
      expect(cubit.state.detailsState.isLoading, isFalse);
      expect(cubit.state.detailsState.data, isNull);
    });

    test('getHistoricalOrderDetails emits loading then success', () async {
      repository.detailsToReturn = sampleDetails;

      await cubit.getHistoricalOrderDetails('ord-hist-1');

      expect(cubit.state.detailsState.isLoading, isFalse);
      expect(cubit.state.detailsState.data?.id, equals('ord-hist-1'));
      expect(cubit.state.detailsState.data?.isCompleted, isTrue);
      expect(cubit.state.detailsState.data?.items.length, equals(1));
    });

    test('getHistoricalOrderDetails handles failure', () async {
      repository.returnError = true;

      BaseEvent? emittedEvent;
      final sub = cubit.eventStream.listen((event) => emittedEvent = event);

      await cubit.getHistoricalOrderDetails('ord-hist-1');
      await pumpEventQueue();

      expect(cubit.state.detailsState.isLoading, isFalse);
      expect(cubit.state.detailsState.errorMessage, equals('Details error'));
      expect(emittedEvent, isA<DisplayError>());

      await sub.cancel();
    });

    test('safe emit does not throw when cubit is closed', () async {
      repository.detailsToReturn = sampleDetails;
      await cubit.close();
      expect(
        () => cubit.getHistoricalOrderDetails('ord-hist-1'),
        returnsNormally,
      );
    });

    test('doEvent handles GetHistoricalOrderDetailsEvent', () async {
      repository.detailsToReturn = sampleDetails;

      cubit.doEvent(const GetHistoricalOrderDetailsEvent('ord-hist-1'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.detailsState.data?.id, equals('ord-hist-1'));
    });
  });
}
