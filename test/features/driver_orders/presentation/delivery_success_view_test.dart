import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/delivery_success_view.dart';

Widget createSuccessTestWidget({
  VoidCallback? onDone,
  Locale locale = const Locale('en'),
}) {
  final router = GoRouter(
    initialLocation: '/success',
    routes: [
      GoRoute(
        path: '/success',
        builder: (context, state) => DeliverySuccessView(onDone: onDone),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(body: Text('Home Screen')),
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
  testWidgets('renders all DeliverySuccessView elements properly', (tester) async {
    await tester.pumpWidget(createSuccessTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Success'), findsOneWidget);
    expect(find.text('Thank you!!'), findsOneWidget);
    expect(find.text('The order delivered successfully'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Done'), findsOneWidget);
  });

  testWidgets('tapping Done calls onDone callback and routes to home', (tester) async {
    bool doneCalled = false;
    await tester.pumpWidget(createSuccessTestWidget(onDone: () => doneCalled = true));
    await tester.pumpAndSettle();

    final doneButton = find.widgetWithText(ElevatedButton, 'Done');
    await tester.tap(doneButton);
    await tester.pumpAndSettle();

    expect(doneCalled, isTrue);
    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('renders properly in Arabic (RTL) without layout overflow', (tester) async {
    await tester.pumpWidget(createSuccessTestWidget(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('نجاح'), findsOneWidget);
    expect(find.text('شكراً لك!!'), findsOneWidget);
    expect(find.text('تم توصيل الطلب بنجاح'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'تم'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
