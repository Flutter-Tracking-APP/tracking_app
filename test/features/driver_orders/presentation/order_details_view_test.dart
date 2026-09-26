import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_item_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/order_details_view.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_status_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_status_progress_bar.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/whatsapp_icon.dart';

class FakeOrderDetailsRepository implements DriverOrdersRepository {
  OrderDetailsEntity? details;
  bool returnError = false;
  String? updatedStatus;

  @override
  Future<ApiResults<List<OrderEntity>>> getAvailableOrders() async =>
      const Success([]);

  @override
  Future<ApiResults<String>> claimOrder(String orderId) async =>
      const Success('ok');

  @override
  Future<ApiResults<OrderDetailsEntity>> getOrderDetails(String orderId) async {
    if (returnError) {
      return const Failure('Failed to load order details', AppError.noConnection);
    }
    return Success(details!);
  }

  @override
  Future<ApiResults<String>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    updatedStatus = status;
    return const Success('Status updated successfully');
  }

  @override
  Future<ApiResults<OrderDetailsEntity?>> getActiveOrder() async =>
      const Success(null);
}

Widget createOrderDetailsTestWidget({
  required String orderId,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    home: OrderDetailsView(orderId: orderId),
  );
}

void main() {
  late FakeOrderDetailsRepository fakeRepo;

  setUp(() async {
    await getIt.reset();
    fakeRepo = FakeOrderDetailsRepository();

    fakeRepo.details = const OrderDetailsEntity(
      id: 'ord-123456',
      orderNumber: '123456',
      status: OrderFulfillmentStatus.accepted,
      formattedDate: 'Wed, 03 Sep 2024, 11:00 AM',
      store: StoreAddressEntity(
        name: 'Flowery store',
        address: '20th st, Sheikh Zayed, Giza',
      ),
      user: UserAddressEntity(
        name: 'Nour mohamed',
        address: '20th st, Sheikh Zayed, Giza',
      ),
      items: [
        OrderItemEntity(
          id: 'item-1',
          title: 'Red roses,15 Pink Rose Bouquet',
          price: 600,
          quantity: 1,
        ),
      ],
      total: 3000,
      paymentMethod: 'Cash on delivery',
    );

    getIt.registerLazySingleton<DriverOrdersRepository>(() => fakeRepo);
    getIt.registerFactory(() => GetDriverOrderDetailsUseCase(fakeRepo));
    getIt.registerFactory(() => UpdateOrderStatusUseCase(fakeRepo));
    getIt.registerFactory(
      () => OrderDetailsCubit(
        getIt<GetDriverOrderDetailsUseCase>(),
        getIt<UpdateOrderStatusUseCase>(),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders all order details, progress bar, items, and action button',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createOrderDetailsTestWidget(orderId: 'ord-123456'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderStatusProgressBar), findsOneWidget);
    expect(find.byType(OrderStatusCard), findsOneWidget);
    expect(find.text('Order ID : # 123456'), findsOneWidget);
    expect(find.text('Wed, 03 Sep 2024, 11:00 AM'), findsOneWidget);
    expect(find.text('Red roses,15 Pink Rose Bouquet'), findsOneWidget);
    expect(find.text('EGP 3000'), findsOneWidget);
    expect(find.text('Cash on delivery'), findsOneWidget);
    expect(find.text('Arrived at Pickup point'), findsOneWidget);
    expect(find.byType(WhatsAppIcon), findsNWidgets(2));
    expect(find.byIcon(Icons.phone_outlined), findsNWidgets(2));
  });

  testWidgets('tapping dynamic action button triggers updateOrderStatus',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createOrderDetailsTestWidget(orderId: 'ord-123456'));
    await tester.pumpAndSettle();

    final actionButton =
        find.widgetWithText(ElevatedButton, 'Arrived at Pickup point');
    expect(actionButton, findsOneWidget);

    await tester.tap(actionButton);
    await tester.pump();

    expect(fakeRepo.updatedStatus, equals('arrived_at_pickup'));
  });

  testWidgets('renders error message when order details fails to load',
      (tester) async {
    fakeRepo.returnError = true;

    await tester.pumpWidget(createOrderDetailsTestWidget(orderId: 'ord-123456'));
    await tester.pumpAndSettle();

    expect(find.text('Failed to load order details'), findsAtLeast(1));
  });

  testWidgets('renders properly in Arabic (RTL) without layout overflow',
      (tester) async {
    await tester.pumpWidget(
      createOrderDetailsTestWidget(
        orderId: 'ord-123456',
        locale: const Locale('ar'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OrderStatusCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
