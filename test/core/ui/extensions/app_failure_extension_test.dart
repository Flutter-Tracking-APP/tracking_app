import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/errors/app_failure.dart';
import 'package:tracking_app/core/ui/extensions/app_failure_extension.dart';

void main() {
  Widget buildTestContext(void Function(BuildContext context) callback,
      {Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          callback(context);
          return const SizedBox();
        },
      ),
    );
  }

  group('AppFailureLocalization Extension Tests', () {
    testWidgets('maps ServerMessageFailure to its raw message',
        (tester) async {
      late String localized;
      await tester.pumpWidget(
        buildTestContext((context) {
          const failure = ServerMessageFailure('Custom backend message');
          localized = failure.toLocalizedMessage(context);
        }),
      );

      expect(localized, equals('Custom backend message'));
    });

    testWidgets('maps NetworkFailure to localized string in English',
        (tester) async {
      late String timeoutMsg;
      late String noConnectionMsg;
      late String serverMsg;

      await tester.pumpWidget(
        buildTestContext((context) {
          timeoutMsg =
              const NetworkFailure(AppError.timeout).toLocalizedMessage(context);
          noConnectionMsg = const NetworkFailure(AppError.noConnection)
              .toLocalizedMessage(context);
          serverMsg =
              const NetworkFailure(AppError.server).toLocalizedMessage(context);
        }, locale: const Locale('en')),
      );

      expect(timeoutMsg, contains('Connection timeout'));
      expect(noConnectionMsg, contains('No internet connection'));
      expect(serverMsg, contains('Server is temporarily unavailable'));
    });

    testWidgets('maps NetworkFailure to localized string in Arabic',
        (tester) async {
      late String noConnectionMsg;

      await tester.pumpWidget(
        buildTestContext((context) {
          noConnectionMsg = const NetworkFailure(AppError.noConnection)
              .toLocalizedMessage(context);
        }, locale: const Locale('ar')),
      );

      expect(noConnectionMsg, contains('لا يوجد اتصال بالإنترنت'));
    });
  });
}
