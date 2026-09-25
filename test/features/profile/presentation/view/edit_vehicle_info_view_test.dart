import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_vehicle_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_cubit.dart';
import 'package:tracking_app/features/profile/presentation/view/edit_vehicle_info_view.dart';
import '../../../../helpers/fake_image_picker_service.dart';

class FakeVehicleApplyTestRepo implements ApplyDriverRepository {
  @override
  Future<ApiResults<DriverApplicationEntity>> applyAsDriver(
    ApplyDriverParams params,
  ) async => const Failure('not needed', AppError.general);

  @override
  Future<ApiResults<List<VehicleTypeEntity>>> getVehicleTypes() async =>
      const Success([VehicleTypeEntity(id: 'v-1', name: 'Car')]);
}

class FakeVehicleProfileTestRepo implements ProfileRepository {
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
      const Success('Vehicle info updated successfully');

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => const Success('ok');
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
    home: const EditVehicleInfoView(),
  );
}

void main() {
  setUp(() {
    if (getIt.isRegistered<EditVehicleCubit>()) {
      getIt.unregister<EditVehicleCubit>();
    }
    final applyRepo = FakeVehicleApplyTestRepo();
    final profileRepo = FakeVehicleProfileTestRepo();

    getIt.registerFactory<EditVehicleCubit>(
      () => EditVehicleCubit(
        GetVehicleTypesUseCase(applyRepo),
        UpdateVehicleUseCase(profileRepo),
        FakeImagePickerService(),
      ),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<EditVehicleCubit>()) {
      getIt.unregister<EditVehicleCubit>();
    }
  });

  testWidgets(
    'renders vehicle dropdown, plate number input, and update button',
    (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Edit Vehicle Info'), findsOneWidget);
      expect(find.text('Car'), findsOneWidget);
      expect(find.text('Vehicle number'), findsOneWidget);
      expect(find.text('Vehicle license'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
    },
  );

  testWidgets('validates required fields on submit empty', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsOneWidget);
  });

  testWidgets('renders properly in Arabic (RTL)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(createTestWidget(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('تعديل بيانات المركبة'), findsOneWidget);
    expect(find.text('تحديث'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
