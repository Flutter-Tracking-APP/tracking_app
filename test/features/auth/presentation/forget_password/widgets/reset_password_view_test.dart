import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/auth/domain/entities/login_entity.dart';
import 'package:tracking_app/features/auth/domain/params/login_params.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/reset_password_view.dart';

class FakeResetPasswordAuthRepo implements AuthRepository {
  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params, bool rememberMe) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<void>> forgotPassword({required String email}) async =>
      const Success(null);

  @override
  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async =>
      const Success({});

  @override
  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) async =>
      const Success(null);
}

Widget createTestWidget(ForgetPasswordBloc bloc) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    home: Scaffold(
      body: BlocProvider<ForgetPasswordBloc>.value(
        value: bloc,
        child: const ResetPasswordView(),
      ),
    ),
  );
}

void main() {
  group('ResetPasswordView Widget Tests', () {
    late ForgetPasswordBloc bloc;
    late FakeResetPasswordAuthRepo fakeRepo;

    final newPassFinder = find.byKey(const Key('reset_new_password_field'));
    final confirmPassFinder = find.byKey(const Key('reset_confirm_password_field'));

    setUp(() {
      fakeRepo = FakeResetPasswordAuthRepo();
      bloc = ForgetPasswordBloc(
        ForgetPasswordUseCase(fakeRepo),
        VerifyOtpUseCase(fakeRepo),
        ResetPasswordUseCase(fakeRepo),
      );
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('renders reset password fields and button', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      expect(find.text('Create New Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Reset Password'), findsOneWidget);
    });

    testWidgets('validates empty password fields', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsNWidgets(2));
    });

    testWidgets('validates password too short', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.enterText(newPassFinder, 'short');
      await tester.enterText(confirmPassFinder, 'short');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('validates password missing uppercase', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.enterText(newPassFinder, 'nouppercase123!');
      await tester.enterText(confirmPassFinder, 'nouppercase123!');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Password must contain an uppercase letter'), findsOneWidget);
    });

    testWidgets('validates password missing lowercase', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.enterText(newPassFinder, 'NOLOWERCASE123!');
      await tester.enterText(confirmPassFinder, 'NOLOWERCASE123!');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Password must contain a lowercase letter'), findsOneWidget);
    });

    testWidgets('validates password missing number', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.enterText(newPassFinder, 'NoNumbersHere!');
      await tester.enterText(confirmPassFinder, 'NoNumbersHere!');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Password must contain a number'), findsOneWidget);
    });

    testWidgets('validates password missing special character', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.enterText(newPassFinder, 'NoSpecialChar123');
      await tester.enterText(confirmPassFinder, 'NoSpecialChar123');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Password must contain a special character'), findsOneWidget);
    });

    testWidgets('validates password mismatch', (tester) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.enterText(newPassFinder, 'ValidP@ssw0rd');
      await tester.enterText(confirmPassFinder, 'DifferentP@ssw0rd');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('happy path: enters matching valid passwords and submits successfully', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(bloc));
      await tester.pumpAndSettle();

      await tester.enterText(newPassFinder, 'P@ssw0rd123');
      await tester.enterText(confirmPassFinder, 'P@ssw0rd123');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsNothing);
      expect(find.text('This field is required'), findsNothing);
    });
  });
}
