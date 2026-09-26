import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_cubit.dart';

class MockDriverOrdersRepository implements DriverOrdersRepository {
  OrderDetailsEntity? details;
  String? lastUpdatedStatus;
  String? lastUpdatedNote;
  bool shouldFailUpdate = false;
  String? failMessage;

  @override
  Future<ApiResults<List<OrderEntity>>> getAvailableOrders() async =>
      const Success([]);

  @override
  Future<ApiResults<String>> claimOrder(String orderId) async =>
      const Success('Claimed');

  @override
  Future<ApiResults<OrderDetailsEntity>> getOrderDetails(String orderId) async =>
      Success(details!);

  @override
  Future<ApiResults<String>> updateOrderStatus(
    String orderId,
    String status, {
    String? note,
  }) async {
    if (shouldFailUpdate) {
      return Failure(
        failMessage ?? 'An order cannot go from Placed to OutForDelivery.',
        AppError.conflict,
      );
    }
    lastUpdatedStatus = status;
    lastUpdatedNote = note;
    return const Success('Order status updated');
  }

  @override
  Future<ApiResults<OrderDetailsEntity?>> getActiveOrder() async =>
      Success(details);
}

void main() {
  late MockDriverOrdersRepository mockRepo;
  late GetDriverOrderDetailsUseCase getDetailsUseCase;
  late UpdateOrderStatusUseCase updateStatusUseCase;
  late OrderDetailsCubit cubit;

  const baseOrder = OrderDetailsEntity(
    id: 'ord-test-1',
    orderNumber: 'TEST-1',
    status: OrderFulfillmentStatus.accepted,
    formattedDate: 'Wed, 03 Sep 2024, 11:00 AM',
    store: StoreAddressEntity(name: 'Store', address: 'Store Address'),
    user: UserAddressEntity(name: 'User', address: 'User Address'),
    items: [],
    total: 150,
    paymentMethod: 'Cash on delivery',
  );

  setUp(() {
    mockRepo = MockDriverOrdersRepository();
    mockRepo.details = baseOrder;
    getDetailsUseCase = GetDriverOrderDetailsUseCase(mockRepo);
    updateStatusUseCase = UpdateOrderStatusUseCase(mockRepo);
    cubit = OrderDetailsCubit(getDetailsUseCase, updateStatusUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('OrderDetailsCubit.updateNextStatus', () {
    test('Step 1 (accepted) -> sends PICKED_UP and transitions to picked',
        () async {
      await cubit.getOrderDetails('ord-test-1');

      await cubit.updateNextStatus('ord-test-1');

      expect(mockRepo.lastUpdatedStatus, equals('PICKED_UP'));
      expect(mockRepo.lastUpdatedNote, equals('Collected from pickup store'));
      expect(cubit.state.orderDetailsState.data?.status,
          equals(OrderFulfillmentStatus.picked));
      expect(cubit.state.isUpdatingStatus, isFalse);
    });

    test('Step 2 (picked) -> sends OUT_FOR_DELIVERY and transitions to outForDelivery',
        () async {
      mockRepo.details = OrderDetailsEntity(
        id: baseOrder.id,
        orderNumber: baseOrder.orderNumber,
        status: OrderFulfillmentStatus.picked,
        formattedDate: baseOrder.formattedDate,
        store: baseOrder.store,
        user: baseOrder.user,
        items: baseOrder.items,
        total: baseOrder.total,
        paymentMethod: baseOrder.paymentMethod,
      );
      await cubit.getOrderDetails('ord-test-1');

      await cubit.updateNextStatus('ord-test-1');

      expect(mockRepo.lastUpdatedStatus, equals('OUT_FOR_DELIVERY'));
      expect(mockRepo.lastUpdatedNote, equals('Heading to customer'));
      expect(cubit.state.orderDetailsState.data?.status,
          equals(OrderFulfillmentStatus.outForDelivery));
      expect(cubit.state.isUpdatingStatus, isFalse);
    });

    test('Step 3 (outForDelivery) -> sends ARRIVED and transitions to arrived',
        () async {
      mockRepo.details = OrderDetailsEntity(
        id: baseOrder.id,
        orderNumber: baseOrder.orderNumber,
        status: OrderFulfillmentStatus.outForDelivery,
        formattedDate: baseOrder.formattedDate,
        store: baseOrder.store,
        user: baseOrder.user,
        items: baseOrder.items,
        total: baseOrder.total,
        paymentMethod: baseOrder.paymentMethod,
      );
      await cubit.getOrderDetails('ord-test-1');

      await cubit.updateNextStatus('ord-test-1');

      expect(mockRepo.lastUpdatedStatus, equals('ARRIVED'));
      expect(mockRepo.lastUpdatedNote,
          equals('Driver reached the delivery address'));
      expect(cubit.state.orderDetailsState.data?.status,
          equals(OrderFulfillmentStatus.arrived));
      expect(cubit.state.isUpdatingStatus, isFalse);
    });

    test(
        'Step 4 (arrived) -> sends AWAITING_DELIVERY_CONFIRMATION and transitions to delivered',
        () async {
      mockRepo.details = OrderDetailsEntity(
        id: baseOrder.id,
        orderNumber: baseOrder.orderNumber,
        status: OrderFulfillmentStatus.arrived,
        formattedDate: baseOrder.formattedDate,
        store: baseOrder.store,
        user: baseOrder.user,
        items: baseOrder.items,
        total: baseOrder.total,
        paymentMethod: baseOrder.paymentMethod,
      );
      await cubit.getOrderDetails('ord-test-1');

      await cubit.updateNextStatus('ord-test-1');

      expect(mockRepo.lastUpdatedStatus,
          equals('AWAITING_DELIVERY_CONFIRMATION'));
      expect(mockRepo.lastUpdatedNote, equals('Order handed to customer'));
      expect(cubit.state.orderDetailsState.data?.status,
          equals(OrderFulfillmentStatus.delivered));
      expect(cubit.state.isUpdatingStatus, isFalse);
    });

    test('Conflict (409) -> resets isUpdatingStatus and emits DisplayError',
        () async {
      mockRepo.shouldFailUpdate = true;
      mockRepo.failMessage =
          'An order cannot go from Placed to OutForDelivery.';

      await cubit.getOrderDetails('ord-test-1');

      final emittedEvents = <BaseEvent>[];
      final subscription = cubit.eventStream.listen(emittedEvents.add);

      await cubit.updateNextStatus('ord-test-1');
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isUpdatingStatus, isFalse);
      expect(cubit.state.updateStatusState.errorMessage,
          equals('An order cannot go from Placed to OutForDelivery.'));
      expect(emittedEvents, hasLength(1));
      expect(
        (emittedEvents.first as DisplayError).errorMsg,
        equals('An order cannot go from Placed to OutForDelivery.'),
      );

      await subscription.cancel();
    });
  });
}
