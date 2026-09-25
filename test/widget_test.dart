import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';

void main() {
  testWidgets('AppTheme light theme smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: Text('Tracking App')),
      ),
    );
    expect(find.text('Tracking App'), findsOneWidget);
  });
}
