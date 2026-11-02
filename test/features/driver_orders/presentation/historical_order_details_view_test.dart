import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
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
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/view/historical_order_details_view.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/view/widgets/historical_order_status_header.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/dynamic_action_button.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_item_tile.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_summary_section.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/store_address_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/user_address_card.dart';

class FakeHistoricalDetailsRepo implements DriverOrdersRepository {
  HistoricalOrderDetailsEntity? details;
  bool returnError = false;

  @override
  Future<ApiResults<HistoricalOrderDetailsEntity>> getHistoricalOrderDetails(
    String orderId,
  ) async {
    if (returnError) {
      return const Failure('Details failed', AppError.server);
    }
    return Success(details!);
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

  @override
  Future<ApiResults<void>> updateDriverLocation({
    required double lat,
    required double lng,
    required DateTime recordedAt,
  }) async => const Success(null);
}

Widget createHistoricalDetailsTestWidget({
  Locale locale = const Locale('en'),
  String orderId = 'ord-hist-99',
}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: locale,
    supportedLocales: const [Locale('en'), Locale('ar')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: HistoricalOrderDetailsView(orderId: orderId),
  );
}

void main() {
  late FakeHistoricalDetailsRepo fakeRepo;

  const sampleDetails = HistoricalOrderDetailsEntity(
    id: 'ord-hist-99',
    orderNumber: 'ORD-20260926-F6057D',
    status: 'DELIVERED',
    statusDisplay: 'Delivered',
    placedAt: '2026-09-26T16:36:38Z',
    subtotal: 16.99,
    deliveryFee: 25.0,
    total: 41.99,
    paymentMethod: 'Cod',
    paymentMethodDisplay: 'Cash on delivery',
    store: StoreAddressEntity(
      name: 'Flowery Store Zayed',
      address: '20th st, Sheikh Zayed, Giza',
    ),
    user: UserAddressEntity(name: 'Ali Recipient', address: 'Dokki, Giza'),
    items: [
      OrderItemEntity(
        id: 'item-flower-1',
        title: 'Red roses bouquet',
        price: 41.99,
        quantity: 1,
      ),
    ],
  );

  setUp(() {
    fakeRepo = FakeHistoricalDetailsRepo();
    if (getIt.isRegistered<HistoricalOrderDetailsCubit>()) {
      getIt.unregister<HistoricalOrderDetailsCubit>();
    }
    getIt.registerFactory<HistoricalOrderDetailsCubit>(
      () => HistoricalOrderDetailsCubit(
        GetHistoricalOrderDetailsUseCase(fakeRepo),
      ),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<HistoricalOrderDetailsCubit>()) {
      getIt.unregister<HistoricalOrderDetailsCubit>();
    }
  });

  group('HistoricalOrderDetailsView Widget Tests', () {
    testWidgets(
      'renders all sections and verifies read-only (zero DynamicActionButton)',
      (tester) async {
        fakeRepo.details = sampleDetails;

        await tester.pumpWidget(createHistoricalDetailsTestWidget());
        await tester.pumpAndSettle();

        // Top status row
        expect(find.byType(HistoricalOrderStatusHeader), findsOneWidget);
        expect(find.text('# ORD-20260926-F6057D'), findsOneWidget);

        // Address cards
        expect(find.byType(StoreAddressCard), findsOneWidget);
        expect(find.text('Flowery Store Zayed'), findsOneWidget);
        expect(find.byType(UserAddressCard), findsOneWidget);
        expect(find.text('Ali Recipient'), findsOneWidget);

        // Items list
        expect(find.byType(OrderItemTile), findsOneWidget);
        expect(find.text('Red roses bouquet'), findsOneWidget);

        // Summary section
        expect(find.byType(OrderSummarySection), findsOneWidget);
        expect(find.text('Cash on delivery'), findsOneWidget);
        // Price is rounded whole integer
        expect(
          find.text('EGP 42'),
          findsNWidgets(2),
        ); // item tile + summary total

        // Crucial: NO DynamicActionButton
        expect(find.byType(DynamicActionButton), findsNothing);
      },
    );

    testWidgets('renders correctly in Arabic (RTL) without UI overflow', (
      tester,
    ) async {
      fakeRepo.details = sampleDetails;

      await tester.pumpWidget(
        createHistoricalDetailsTestWidget(locale: const Locale('ar')),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HistoricalOrderStatusHeader), findsOneWidget);
      expect(find.byType(StoreAddressCard), findsOneWidget);
      expect(find.byType(UserAddressCard), findsOneWidget);
      expect(find.byType(OrderSummarySection), findsOneWidget);
    });

    testWidgets('displays error state with retry button on failure', (
      tester,
    ) async {
      fakeRepo.returnError = true;

      await tester.pumpWidget(createHistoricalDetailsTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Details failed'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      fakeRepo.returnError = false;
      fakeRepo.details = sampleDetails;

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(OrderSummarySection), findsOneWidget);
    });
  });
}
