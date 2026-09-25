import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_cubit.dart';
import 'package:tracking_app/features/profile/presentation/view/change_password_view.dart';

class FakeChangePasswordTestRepo implements ProfileRepository {
  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async =>
      const Failure('not needed', AppError.general);

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<VehicleInfoEntity>> getVehicleInfo() async =>
      const Failure('not needed', AppError.general);

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => const Success('Password changed successfully');
}

class FakeChangePasswordTestSession implements SessionService {
  @override
  Future<void> clearSession() async {}

  @override
  Future<String> getToken() async => '';

  @override
  Future<String> getRefreshToken() async => '';

  @override
  Future<bool> isRemembered() async => false;

  @override
  Future<bool> isGuest() async => false;

  @override
  Future<void> setGuestMode(bool value) async {}

  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {}

  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {}

  @override
  Future<void> setRememberMe(bool value) async {}
}

Widget createTestWidget({Locale locale = const Locale('en')}) {
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
    home: const ChangePasswordView(),
  );
}

void main() {
  setUp(() {
    if (getIt.isRegistered<ChangePasswordCubit>()) {
      getIt.unregister<ChangePasswordCubit>();
    }
    final repo = FakeChangePasswordTestRepo();
    final session = FakeChangePasswordTestSession();

    getIt.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(ChangePasswordUseCase(repo), session),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<ChangePasswordCubit>()) {
      getIt.unregister<ChangePasswordCubit>();
    }
  });

  testWidgets('renders all 3 password fields and update button', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Current password'), findsOneWidget);
    expect(find.text('New password'), findsOneWidget);
    expect(find.text('Confirm new password'), findsNWidgets(2));
    expect(find.text('Update'), findsOneWidget);
  });

  testWidgets('toggles visibility for each field independently', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final eyeOffIcons = find.byIcon(Icons.visibility_off_outlined);
    expect(eyeOffIcons, findsNWidgets(3));

    // Tap first eye icon (current password)
    await tester.tap(eyeOffIcons.first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
  });

  testWidgets('validates required fields on submit empty', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsWidgets);
  });

  testWidgets('renders properly in Arabic (RTL)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(createTestWidget(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('تغيير كلمة المرور'), findsOneWidget);
    expect(find.text('تحديث'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
