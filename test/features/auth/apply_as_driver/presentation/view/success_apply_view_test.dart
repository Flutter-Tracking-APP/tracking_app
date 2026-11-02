import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/success_apply_view.dart';

Widget createSuccessTestWidget({Locale locale = const Locale('en')}) {
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
    home: const SuccessApplyView(),
  );
}

void main() {
  testWidgets('renders checkmark badge, headline, body, and login button', (
    tester,
  ) async {
    await tester.pumpWidget(createSuccessTestWidget());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.text('Your application has been submitted!'), findsOneWidget);
    expect(
      find.text(
        'Thank you for providing your application, we will review your application and will get back to you soon.',
      ),
      findsOneWidget,
    );
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('renders without overflow in RTL (Arabic)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(
      createSuccessTestWidget(locale: const Locale('ar')),
    );
    await tester.pumpAndSettle();

    expect(find.text('تم إرسال طلبك بنجاح!'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
