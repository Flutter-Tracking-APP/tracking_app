import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/view/edit_profile_view.dart';
import '../../../../helpers/fake_image_picker_service.dart';

class FakeEditRepo implements ProfileRepository {
  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async => const Success(
    UserProfileEntity(
      id: 'p-1',
      firstName: 'Nour',
      lastName: 'Mohamed',
      email: 'nour@test.com',
      phoneNumber: '01010522698',
      gender: 0,
    ),
  );

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      const Success('Profile updated successfully');

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => const Success('ok');
}

Widget createTestWidget({
  Locale locale = const Locale('en'),
  UserProfileEntity? profile,
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
    home: EditProfileView(initialProfile: profile),
  );
}

void main() {
  const dummyProfile = UserProfileEntity(
    id: 'p-1',
    firstName: 'Nour',
    lastName: 'Mohamed',
    email: 'nour@test.com',
    phoneNumber: '01010522698',
    gender: 0,
  );

  setUp(() {
    if (getIt.isRegistered<EditProfileCubit>()) {
      getIt.unregister<EditProfileCubit>();
    }
    final fakeRepo = FakeEditRepo();
    getIt.registerFactory<EditProfileCubit>(
      () => EditProfileCubit(
        UpdateProfileUseCase(fakeRepo),
        FakeImagePickerService(),
      ),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<EditProfileCubit>()) {
      getIt.unregister<EditProfileCubit>();
    }
  });

  testWidgets('renders all input fields with initial data', (tester) async {
    await tester.pumpWidget(createTestWidget(profile: dummyProfile));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Nour'), findsOneWidget);
    expect(find.text('Mohamed'), findsOneWidget);
    expect(find.text('nour@test.com'), findsOneWidget);
    expect(find.text('01010522698'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
  });

  testWidgets('email field is readOnly', (tester) async {
    await tester.pumpWidget(createTestWidget(profile: dummyProfile));
    await tester.pumpAndSettle();

    final emailFieldFinder = find.widgetWithText(AppTextField, 'Email');
    final textField = tester.widget<TextField>(
      find.descendant(of: emailFieldFinder, matching: find.byType(TextField)),
    );

    expect(textField.readOnly, isTrue);
  });

  testWidgets('update button starts disabled when form is pristine', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget(profile: dummyProfile));
    await tester.pumpAndSettle();

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Update');
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.enabled, isFalse);
  });

  testWidgets('update button enables when field is modified and valid', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget(profile: dummyProfile));
    await tester.pumpAndSettle();

    final firstNameField = find.widgetWithText(AppTextField, 'First legal name');
    await tester.enterText(
      find.descendant(of: firstNameField, matching: find.byType(TextField)),
      'Ahmed',
    );
    await tester.pumpAndSettle();

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Update');
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.enabled, isTrue);
  });

  testWidgets('update button disables when field is cleared', (tester) async {
    await tester.pumpWidget(createTestWidget(profile: dummyProfile));
    await tester.pumpAndSettle();

    final firstNameField = find.widgetWithText(AppTextField, 'First legal name');
    await tester.enterText(
      find.descendant(of: firstNameField, matching: find.byType(TextField)),
      '',
    );
    await tester.pumpAndSettle();

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Update');
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.enabled, isFalse);
  });

  testWidgets('update button disables when reverted back to initial value', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget(profile: dummyProfile));
    await tester.pumpAndSettle();

    final firstNameField = find.widgetWithText(AppTextField, 'First legal name');
    final textFinder = find.descendant(
      of: firstNameField,
      matching: find.byType(TextField),
    );
    await tester.enterText(textFinder, 'Ahmed');
    await tester.pumpAndSettle();
    expect(
      tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Update')).enabled,
      isTrue,
    );

    await tester.enterText(textFinder, 'Nour');
    await tester.pumpAndSettle();
    expect(
      tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Update')).enabled,
      isFalse,
    );
  });

  testWidgets('renders properly in Arabic (RTL)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(
      createTestWidget(locale: const Locale('ar'), profile: dummyProfile),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعديل الملف الشخصي'), findsOneWidget);
    expect(find.text('تحديث'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
