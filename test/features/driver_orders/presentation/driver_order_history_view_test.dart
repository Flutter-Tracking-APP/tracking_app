import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/historical_order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_history_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/driver_order_history_view.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/widgets/order_history_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/widgets/order_history_summary_card.dart';

class FakeOrderHistoryRepo implements DriverOrdersRepository {
  List<OrderHistoryEntity> orders = [];
  bool returnError = false;

  @override
  Future<ApiResults<List<OrderHistoryEntity>>> getDriverOrderHistory({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    if (returnError) {
      return const FailureResponse(
        ServerFailure(
          error: AppError.server,
          message: 'Failed to load history',
        ),
      );
    }
    return Success(orders);
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

Widget createHistoryTestWidget({
  Locale locale = const Locale('en'),
  String? navigatedRoute,
  void Function(String route)? onNavigate,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DriverOrderHistoryView(),
      ),
      GoRoute(
        path: '${AppRoutes.historicalOrderDetails}/:orderId',
        builder: (context, state) {
          final id = state.pathParameters['orderId'] ?? '';
          onNavigate?.call('${AppRoutes.historicalOrderDetails}/$id');
          return Scaffold(body: Text('Details for $id'));
        },
      ),
    ],
  );

  return MaterialApp.router(
    routerConfig: router,
    theme: AppTheme.lightTheme,
    locale: locale,
    supportedLocales: const [Locale('en'), Locale('ar')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  );
}

void main() {
  late FakeOrderHistoryRepo fakeRepo;

  final sampleOrders = [
    const OrderHistoryEntity(
      id: 'ord-hist-1',
      orderNumber: 'ORD-101',
      status: 'DELIVERED',
      statusDisplay: 'Delivered',
      placedAt: '2026-09-26T12:00:00Z',
      itemCount: 1,
      total: 150,
      store: StoreAddressEntity(
        name: 'Flowery Store 1',
        address: 'Sheikh Zayed',
      ),
      user: UserAddressEntity(name: 'Nour Mohamed', address: 'Giza'),
    ),
    const OrderHistoryEntity(
      id: 'ord-hist-2',
      orderNumber: 'ORD-102',
      status: 'CANCELLED',
      statusDisplay: 'Cancelled',
      placedAt: '2026-09-25T12:00:00Z',
      itemCount: 2,
      total: 250,
      store: StoreAddressEntity(name: 'Flowery Store 2', address: 'Dokki'),
      user: UserAddressEntity(name: 'Ali Ahmed', address: 'Cairo'),
    ),
  ];

  setUp(() {
    fakeRepo = FakeOrderHistoryRepo();
    if (getIt.isRegistered<DriverOrderHistoryCubit>()) {
      getIt.unregister<DriverOrderHistoryCubit>();
    }
    getIt.registerFactory<DriverOrderHistoryCubit>(
      () => DriverOrderHistoryCubit(GetDriverOrderHistoryUseCase(fakeRepo)),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<DriverOrderHistoryCubit>()) {
      getIt.unregister<DriverOrderHistoryCubit>();
    }
  });

  group('DriverOrderHistoryView Widget Tests', () {
    testWidgets('renders summary cards with counts and list of orders in LTR', (
      tester,
    ) async {
      fakeRepo.orders = sampleOrders;

      await tester.pumpWidget(createHistoryTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(OrderHistorySummaryCard), findsNWidgets(2));
      expect(find.text('1'), findsNWidgets(2)); // 1 completed, 1 cancelled

      expect(find.byType(OrderHistoryCard), findsNWidgets(2));
      expect(find.text('# ORD-101'), findsOneWidget);
      expect(find.text('# ORD-102'), findsOneWidget);
      expect(find.text('Flowery Store 1'), findsOneWidget);
      expect(find.text('Nour Mohamed'), findsOneWidget);
    });

    testWidgets('renders correctly in Arabic (RTL) without UI overflow', (
      tester,
    ) async {
      fakeRepo.orders = sampleOrders;

      await tester.pumpWidget(
        createHistoryTestWidget(locale: const Locale('ar')),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(OrderHistorySummaryCard), findsNWidgets(2));
      expect(find.byType(OrderHistoryCard), findsNWidgets(2));
    });

    testWidgets('displays error state with retry button on failure', (
      tester,
    ) async {
      fakeRepo.returnError = true;

      await tester.pumpWidget(createHistoryTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Failed to load history'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Tap retry after fixing error
      fakeRepo.returnError = false;
      fakeRepo.orders = sampleOrders;

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(OrderHistoryCard), findsNWidgets(2));
    });

    testWidgets('displays empty state when order history is empty', (
      tester,
    ) async {
      fakeRepo.orders = [];

      await tester.pumpWidget(createHistoryTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No orders found'), findsOneWidget);
      expect(find.byType(OrderHistoryCard), findsNothing);
    });

    testWidgets(
      'tapping an order card navigates to HistoricalOrderDetailsView',
      (tester) async {
        fakeRepo.orders = sampleOrders;
        String? destination;

        await tester.pumpWidget(
          createHistoryTestWidget(onNavigate: (route) => destination = route),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('# ORD-101'));
        await tester.pumpAndSettle();

        expect(
          destination,
          equals('${AppRoutes.historicalOrderDetails}/ord-hist-1'),
        );
        expect(find.text('Details for ord-hist-1'), findsOneWidget);
      },
    );
  });
}
