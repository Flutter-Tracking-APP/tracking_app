import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/claim_order_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_available_orders_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_active_order_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/view/driver_home_view.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/view/widgets/available_order_card.dart';

import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/order_details_view.dart';

class FakeDriverOrdersRepository implements DriverOrdersRepository {
  List<OrderEntity> orders = [];
  bool returnError = false;
  String? claimedOrderId;
  Completer<ApiResults<String>>? claimCompleter;
  OrderDetailsEntity? activeOrderToReturn;
  Completer<ApiResults<OrderDetailsEntity?>>? activeOrderCompleter;
  AppError? claimError;
  String? claimErrorMessage;

  @override
  Future<ApiResults<List<OrderEntity>>> getAvailableOrders() async {
    if (returnError) {
      return const Failure('Failed to fetch available orders', AppError.noConnection);
    }
    return Success(orders);
  }

  @override
  Future<ApiResults<String>> claimOrder(String orderId) async {
    claimedOrderId = orderId;
    if (claimCompleter != null) {
      return claimCompleter!.future;
    }
    if (claimError != null) {
      return Failure(claimErrorMessage, claimError!);
    }
    return const Success('Order claimed successfully');
  }

  @override
  Future<ApiResults<OrderDetailsEntity>> getOrderDetails(String orderId) async {
    return Success(activeOrderToReturn ?? const OrderDetailsEntity(
      id: 'active-ord-777',
      orderNumber: 'ORD-777',
      status: OrderFulfillmentStatus.accepted,
      formattedDate: '2026-09-26',
      store: StoreAddressEntity(name: 'Store', address: 'Addr'),
      user: UserAddressEntity(name: 'User', address: 'Addr'),
      items: [],
      total: 100,
      paymentMethod: 'Cash',
    ));
  }

  @override
  Future<ApiResults<String>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    return const Success('Status updated successfully');
  }

  @override
  Future<ApiResults<OrderDetailsEntity?>> getActiveOrder() async {
    if (activeOrderCompleter != null) {
      return activeOrderCompleter!.future;
    }
    return Success(activeOrderToReturn);
  }
}

Widget createHomeTestWidget({Locale locale = const Locale('en')}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: DriverHomeView()),
      ),
      GoRoute(
        path: '/order-details/:orderId',
        builder: (context, state) => const Scaffold(body: Text('Order Details Screen')),
      ),
    ],
  );

  return MaterialApp.router(
    theme: AppTheme.lightTheme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    routerConfig: router,
  );
}

void main() {
  late FakeDriverOrdersRepository fakeRepo;

  setUp(() async {
    await getIt.reset();
    fakeRepo = FakeDriverOrdersRepository();

    fakeRepo.orders = [
      OrderEntity(
        id: 'ord-123',
        title: 'Flower order',
        totalAmount: 3000,
        status: 'pending',
        storeName: 'Flowery store',
        storeAddress: '20th st, Sheikh Zayed, Giza',
        customerName: 'Nour mohamed',
        customerAddress: '20th st, Sheikh Zayed, Giza',
      ),
    ];

    getIt.registerLazySingleton<DriverOrdersRepository>(() => fakeRepo);
    getIt.registerFactory(() => GetAvailableOrdersUseCase(fakeRepo));
    getIt.registerFactory(() => GetDriverActiveOrderUseCase(fakeRepo));
    getIt.registerFactory(() => ClaimOrderUseCase(fakeRepo));
    getIt.registerFactory(() => GetDriverOrderDetailsUseCase(fakeRepo));
    getIt.registerFactory(() => UpdateOrderStatusUseCase(fakeRepo));
    getIt.registerFactory(
      () => OrderDetailsCubit(
        getIt<GetDriverOrderDetailsUseCase>(),
        getIt<UpdateOrderStatusUseCase>(),
      ),
    );
    getIt.registerFactory(
      () => DriverHomeCubit(
        getIt<GetAvailableOrdersUseCase>(),
        getIt<GetDriverActiveOrderUseCase>(),
        getIt<ClaimOrderUseCase>(),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders Flowery rider header and available order card with details',
      (tester) async {
    await tester.pumpWidget(createHomeTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Flowery rider'), findsOneWidget);
    expect(find.text('Flower order'), findsOneWidget);
    expect(find.text('Flowery store'), findsOneWidget);
    expect(find.text('Nour mohamed'), findsOneWidget);
    expect(find.text('EGP 3000'), findsOneWidget);
    expect(find.text('Accept'), findsOneWidget);
  });

  testWidgets('tapping Accept button calls claimOrder', (tester) async {
    await tester.pumpWidget(createHomeTestWidget());
    await tester.pumpAndSettle();

    final acceptButton = find.widgetWithText(ElevatedButton, 'Accept');
    expect(acceptButton, findsOneWidget);

    await tester.tap(acceptButton);
    await tester.pump();

    expect(fakeRepo.claimedOrderId, equals('ord-123'));
  });

  testWidgets(
      'tapping Accept on one card shows loading only for that card while other cards remain normal',
      (tester) async {
    final completer = Completer<ApiResults<String>>();
    fakeRepo.claimCompleter = completer;

    fakeRepo.orders = [
      OrderEntity(
        id: 'ord-1',
        title: 'Flower order 1',
        totalAmount: 1000,
        status: 'pending',
        storeName: 'Store 1',
        storeAddress: 'Address 1',
        customerName: 'Customer 1',
        customerAddress: 'Cust Address 1',
      ),
      OrderEntity(
        id: 'ord-2',
        title: 'Flower order 2',
        totalAmount: 2000,
        status: 'pending',
        storeName: 'Store 2',
        storeAddress: 'Address 2',
        customerName: 'Customer 2',
        customerAddress: 'Cust Address 2',
      ),
    ];

    await tester.pumpWidget(createHomeTestWidget());
    await tester.pumpAndSettle();

    // Verify two cards rendered with Accept buttons
    expect(find.byType(AvailableOrderCard), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Accept'), findsNWidgets(2));
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Tap Accept on the first order
    final firstAcceptButton = find.widgetWithText(ElevatedButton, 'Accept').first;
    await tester.tap(firstAcceptButton);
    await tester.pump(); // Pump frame to trigger state update while future is pending

    // First card's button shows loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Second card's button still shows text 'Accept'
    expect(find.widgetWithText(ElevatedButton, 'Accept'), findsOneWidget);

    // Complete the claim operation
    completer.complete(const Success('Order claimed successfully'));
    await tester.pumpAndSettle();

    expect(fakeRepo.claimedOrderId, equals('ord-1'));
  });

  testWidgets('displays error state and retry button when fetching fails',
      (tester) async {
    fakeRepo.returnError = true;

    await tester.pumpWidget(createHomeTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Failed to fetch available orders'), findsAtLeast(1));
  });

  testWidgets('renders properly in Arabic (RTL) without overflow',
      (tester) async {
    await tester.pumpWidget(createHomeTestWidget(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.byType(AvailableOrderCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'displays OrderDetailsView directly when active order exists on initialization',
      (tester) async {
    fakeRepo.activeOrderToReturn = const OrderDetailsEntity(
      id: 'active-ord-777',
      orderNumber: 'ORD-777',
      status: OrderFulfillmentStatus.accepted,
      formattedDate: '2026-09-26',
      store: StoreAddressEntity(name: 'Store', address: 'Addr'),
      user: UserAddressEntity(name: 'User', address: 'Addr'),
      items: [],
      total: 100,
      paymentMethod: 'Cash',
    );

    await tester.pumpWidget(createHomeTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsView), findsOneWidget);
    expect(find.byType(AvailableOrderCard), findsNothing);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
  });

  testWidgets(
      'displays OrderDetailsView when claiming order returns 409 Conflict',
      (tester) async {
    fakeRepo.claimError = AppError.conflict;
    fakeRepo.claimErrorMessage =
        'Finish your current assigned order before claiming another one';

    // Initially no active order
    fakeRepo.activeOrderToReturn = null;

    await tester.pumpWidget(createHomeTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(AvailableOrderCard), findsOneWidget);

    // Active order returns when checked after conflict
    fakeRepo.activeOrderToReturn = const OrderDetailsEntity(
      id: 'active-ord-conflict-888',
      orderNumber: 'ORD-888',
      status: OrderFulfillmentStatus.accepted,
      formattedDate: '2026-09-26',
      store: StoreAddressEntity(name: 'Store', address: 'Addr'),
      user: UserAddressEntity(name: 'User', address: 'Addr'),
      items: [],
      total: 100,
      paymentMethod: 'Cash',
    );

    final acceptButton = find.widgetWithText(ElevatedButton, 'Accept');
    await tester.tap(acceptButton);
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsView), findsOneWidget);
    expect(find.byType(AvailableOrderCard), findsNothing);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
  });

  testWidgets(
      'displays CircularProgressIndicator and does not flash available orders while checking active order',
      (tester) async {
    final completer = Completer<ApiResults<OrderDetailsEntity?>>();
    fakeRepo.activeOrderCompleter = completer;

    await tester.pumpWidget(createHomeTestWidget());
    await tester.pump();

    // Verify loading indicator is displayed and AvailableOrderCard is NOT rendered
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(AvailableOrderCard), findsNothing);

    // Complete checking active order with null
    completer.complete(const Success(null));
    await tester.pumpAndSettle();

    // Now available orders are shown
    expect(find.byType(AvailableOrderCard), findsOneWidget);
  });
}
