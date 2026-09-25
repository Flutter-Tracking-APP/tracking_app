import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/config/storage/secure_storage_service.dart';
import 'package:tracking_app/core/localization/locale_cubit.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/view/profile_view.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/language_bottom_sheet.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/logout_dialog.dart';

class FakeWidgetProfileRepo implements ProfileRepository {
  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async {
    return const Success(
      UserProfileEntity(
        id: 'p-1',
        firstName: 'Nour',
        lastName: 'Mohamed',
        email: 'nour@test.com',
        phoneNumber: '01010522698',
        gender: 0,
      ),
    );
  }

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<VehicleInfoEntity>> getVehicleInfo() async {
    return const Success(
      VehicleInfoEntity(
        vehicleId: 'v-1',
        vehicleTypeId: 'vt-1',
        vehicleTypeName: 'Bike',
        plateNumber: 'UP16DL0007',
        capacity: 2,
        licenseDocument: 'doc.png',
      ),
    );
  }

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => const Success('ok');
}

class FakeWidgetSessionService implements SessionService {
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

class FakeStorageService implements SecureStorageService {
  @override
  Future<void> delete(String key) async {}

  @override
  Future<String> get(String key) async => 'en';

  @override
  Future<void> save(String key, String value) async {}
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
    home: const ProfileView(),
  );
}

void main() {
  setUp(() {
    if (getIt.isRegistered<LocaleCubit>()) {
      getIt.unregister<LocaleCubit>();
    }
    if (getIt.isRegistered<ProfileCubit>()) {
      getIt.unregister<ProfileCubit>();
    }

    final fakeRepo = FakeWidgetProfileRepo();
    final fakeSession = FakeWidgetSessionService();
    final fakeStorage = FakeStorageService();

    getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit(fakeStorage));
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        GetProfileUseCase(fakeRepo),
        GetVehicleInfoUseCase(fakeRepo),
        fakeSession,
      ),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<LocaleCubit>()) {
      getIt.unregister<LocaleCubit>();
    }
    if (getIt.isRegistered<ProfileCubit>()) {
      getIt.unregister<ProfileCubit>();
    }
  });

  testWidgets('renders profile header, vehicle tile, and menu tiles', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Nour Mohamed'), findsOneWidget);
    expect(find.text('nour@test.com'), findsOneWidget);
    expect(find.text('01010522698'), findsOneWidget);
    expect(find.text('Vehicle Info'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('UP16DL0007'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('v 6.3.0 - (446)'), findsOneWidget);
  });

  testWidgets('opens LanguageBottomSheet when language tile is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.byType(LanguageBottomSheet), findsOneWidget);
    expect(find.text('Change Language'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LanguageBottomSheet),
        matching: find.text('English'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('opens LogoutDialog when logout tile is tapped', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(LogoutDialog), findsOneWidget);
    expect(find.text('LOGOUT'), findsOneWidget);
    expect(find.text('Confirm logout!!'), findsOneWidget);
  });

  testWidgets('renders correctly in Arabic (RTL)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(createTestWidget(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('الملف الشخصي'), findsOneWidget);
    expect(find.text('بيانات المركبة'), findsOneWidget);
    expect(find.text('اللغة'), findsOneWidget);
    expect(find.text('تسجيل الخروج'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
