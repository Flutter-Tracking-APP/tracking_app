import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';
import 'package:tracking_app/core/utils/app_validators.dart';

Widget buildTestWidget({
  required Widget child,
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
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)),
  );
}

void main() {
  group('AppTextField Widget Tests', () {
    testWidgets('renders label, hint, and initial text correctly', (tester) async {
      final controller = TextEditingController(text: 'Initial');

      await tester.pumpWidget(
        buildTestWidget(
          child: AppTextField(
            label: 'Email Address',
            hint: 'Enter your email',
            controller: controller,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Initial'), findsOneWidget);
    });

    testWidgets('displays validation error when errorValidator returns ValidationError', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildTestWidget(
          child: Form(
            key: formKey,
            child: AppTextField(
              label: 'Email',
              hint: 'Enter email',
              errorValidator: (val) => AppValidators.validateEmail(val),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('displays validation error when standard validator returns String', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildTestWidget(
          child: Form(
            key: formKey,
            child: AppTextField(
              label: 'Custom',
              hint: 'Enter custom',
              validator: (val) => (val == null || val.isEmpty) ? 'Custom error' : null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Custom error'), findsOneWidget);
    });

    testWidgets('triggers onChange callback when text changes', (tester) async {
      String typed = '';

      await tester.pumpWidget(
        buildTestWidget(
          child: AppTextField(
            label: 'Input',
            hint: 'Enter input',
            onChange: (val) => typed = val,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Hello Antigravity');
      await tester.pumpAndSettle();

      expect(typed, equals('Hello Antigravity'));
    });
  });
}
