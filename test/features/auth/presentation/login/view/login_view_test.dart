import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/auth/domain/entities/login_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/user_entity.dart';
import 'package:tracking_app/features/auth/domain/params/login_params.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/view/login_view.dart';

class FakeAuthRepository implements AuthRepository {
  ApiResults<LoginEntity>? loginResult;

  FakeAuthRepository({this.loginResult});

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params, bool rememberMe) async {
    return loginResult ??
        const Success(
          LoginEntity(
            user: UserEntity(
              id: '1',
              name: 'Test User',
              email: 'test@example.com',
              phone: '01012345678',
            ),
            token: 'token',
            refreshToken: 'refresh',
          ),
        );
  }

  @override
  Future<ApiResults<void>> forgotPassword({required String email}) async =>
      const Success(null);

  @override
  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) async =>
      const Success(null);

  @override
  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async =>
      const Success({});
}

Widget createTestWidget({
  required LoginCubit loginCubit,
  Locale locale = const Locale('en'),
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider<LoginCubit>.value(
          value: loginCubit,
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
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
  group('LoginView Widget Tests', () {
    testWidgets('renders login form elements properly', (tester) async {
      final fakeRepo = FakeAuthRepository();
      final cubit = LoginCubit(LoginUseCase(fakeRepo));

      await tester.pumpWidget(createTestWidget(loginCubit: cubit));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Remember me'), findsOneWidget);
      expect(find.text('Forget Password?'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('displays validation errors on invalid inputs', (tester) async {
      final fakeRepo = FakeAuthRepository();
      final cubit = LoginCubit(LoginUseCase(fakeRepo));

      await tester.pumpWidget(createTestWidget(loginCubit: cubit));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'invalid-email');
      await tester.enterText(textFields.at(1), '');
      await tester.pumpAndSettle();

      final formFinder = find.byType(Form);
      final formState = tester.state<FormState>(formFinder);
      formState.validate();
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('This field is required'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('displays localized SnackBar on NetworkFailure', (tester) async {
      final fakeRepo = FakeAuthRepository(
        loginResult: const FailureResponse(
          NetworkFailure(AppError.noConnection),
        ),
      );
      final cubit = LoginCubit(LoginUseCase(fakeRepo));

      await tester.pumpWidget(createTestWidget(loginCubit: cubit));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'user@example.com');
      await tester.enterText(textFields.at(1), 'P@ssw0rd123');
      await tester.pumpAndSettle();

      // Tap Sign in
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(
          'No internet connection. Please check your network and try again.',
        ),
        findsOneWidget,
      );

      await cubit.close();
    });

    testWidgets('displays localized SnackBar on ServerFailure', (
      tester,
    ) async {
      final fakeRepo = FakeAuthRepository(
        loginResult: const FailureResponse(
          ServerFailure(
            error: AppError.unauthorized,
            message: 'Invalid credentials',
          ),
        ),
      );
      final cubit = LoginCubit(LoginUseCase(fakeRepo));

      await tester.pumpWidget(createTestWidget(loginCubit: cubit));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'user@example.com');
      await tester.enterText(textFields.at(1), 'P@ssw0rd123');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('displays localized success SnackBar and navigates to home on successful login', (
      tester,
    ) async {
      final fakeRepo = FakeAuthRepository();
      final cubit = LoginCubit(LoginUseCase(fakeRepo));

      await tester.pumpWidget(createTestWidget(loginCubit: cubit));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'user@example.com');
      await tester.enterText(textFields.at(1), 'P@ssw0rd123');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Login Successfully'), findsOneWidget);
      expect(find.text('Home Screen'), findsOneWidget);

      await cubit.close();
    });
  });
}
