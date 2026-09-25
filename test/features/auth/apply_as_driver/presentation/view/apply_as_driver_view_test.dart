import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/core/ui/themes/app_theme.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/apply_as_driver_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_cubit.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_events.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/apply_as_driver_view.dart';
import '../../../../../helpers/fake_image_picker_service.dart';

class FakeRepo implements ApplyDriverRepository {
  ApplyDriverParams? lastParams;

  @override
  Future<ApiResults<DriverApplicationEntity>> applyAsDriver(
    ApplyDriverParams params,
  ) async {
    lastParams = params;
    return const Success(
      DriverApplicationEntity(
        id: '1',
        name: 'Test',
        email: 'test@test.com',
        phone: '01012345678',
        createdAt: '',
        updatedAt: '',
        gender: 'Male',
        notificationStatus: 'on',
      ),
    );
  }

  @override
  Future<ApiResults<List<VehicleTypeEntity>>> getVehicleTypes() async {
    return const Success([VehicleTypeEntity(id: 'v-1', name: 'Car')]);
  }
}

Widget createTestWidget({Locale locale = const Locale('en')}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ApplyAsDriverView(),
      ),
      GoRoute(
        path: AppRoutes.applyDriverSuccess,
        builder: (context, state) =>
            const Scaffold(body: Text('Success Apply')),
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
  late FakeRepo fakeRepo;
  late ApplyDriverCubit cubit;
  late FakeImagePickerService fakeImagePicker;

  setUp(() {
    if (getIt.isRegistered<ApplyDriverCubit>()) {
      getIt.unregister<ApplyDriverCubit>();
    }
    fakeRepo = FakeRepo();
    fakeImagePicker = FakeImagePickerService();
    final applyUseCase = ApplyAsDriverUseCase(fakeRepo);
    final vehicleUseCase = GetVehicleTypesUseCase(fakeRepo);
    cubit = ApplyDriverCubit(applyUseCase, vehicleUseCase, fakeImagePicker);
    getIt.registerFactory<ApplyDriverCubit>(() => cubit);
  });

  tearDown(() {
    if (getIt.isRegistered<ApplyDriverCubit>()) {
      getIt.unregister<ApplyDriverCubit>();
    }
  });

  testWidgets('renders all form fields, headers, and continue button', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Welcome!!'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Car'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
  });

  testWidgets('validates required fields when Continue is tapped empty', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final continueBtn = find.text('Continue');
    await tester.ensureVisible(continueBtn);
    await tester.tap(continueBtn);
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsWidgets);
  });

  testWidgets('renders properly without layout overflow in RTL (Arabic)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(createTestWidget(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('التقديم'), findsOneWidget);
    expect(find.text('أهلاً بك!!'), findsOneWidget);
    expect(find.text('متابعة'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  testWidgets(
    'toggles password and confirm password obscureText on eye icon tap',
    (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final passwordFieldFinder = find.widgetWithText(AppTextField, 'Password');
      final confirmPasswordFieldFinder = find.widgetWithText(
        AppTextField,
        'Confirm password',
      );

      await tester.ensureVisible(passwordFieldFinder);

      TextField getTextField(Finder parent) {
        return tester.widget<TextField>(
          find.descendant(of: parent, matching: find.byType(TextField)),
        );
      }

      // Initially both fields are obscured
      expect(getTextField(passwordFieldFinder).obscureText, isTrue);
      expect(getTextField(confirmPasswordFieldFinder).obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      // Tap password eye icon
      final passwordEyeIcon = find.descendant(
        of: passwordFieldFinder,
        matching: find.byType(IconButton),
      );
      await tester.tap(passwordEyeIcon);
      await tester.pumpAndSettle();

      expect(getTextField(passwordFieldFinder).obscureText, isFalse);
      expect(getTextField(confirmPasswordFieldFinder).obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Tap confirm password eye icon
      final confirmPasswordEyeIcon = find.descendant(
        of: confirmPasswordFieldFinder,
        matching: find.byType(IconButton),
      );
      await tester.tap(confirmPasswordEyeIcon);
      await tester.pumpAndSettle();

      expect(getTextField(passwordFieldFinder).obscureText, isFalse);
      expect(getTextField(confirmPasswordFieldFinder).obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap password eye icon again to obscure
      await tester.tap(passwordEyeIcon);
      await tester.pumpAndSettle();

      expect(getTextField(passwordFieldFinder).obscureText, isTrue);
      expect(getTextField(confirmPasswordFieldFinder).obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    },
  );

  testWidgets(
    'submits form when all fields are valid and continue button is tapped',
    (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter First Name
      final firstNameFinder = find.widgetWithText(
        AppTextField,
        'First legal name',
      );
      await tester.ensureVisible(firstNameFinder);
      await tester.enterText(
        find.descendant(of: firstNameFinder, matching: find.byType(TextField)),
        'Mohamed',
      );

      // Enter Last Name
      final lastNameFinder = find.widgetWithText(
        AppTextField,
        'Second legal name',
      );
      await tester.ensureVisible(lastNameFinder);
      await tester.enterText(
        find.descendant(of: lastNameFinder, matching: find.byType(TextField)),
        'Ali',
      );

      // Enter Vehicle Number
      final vehicleNumberFinder = find.widgetWithText(
        AppTextField,
        'Vehicle number',
      );
      await tester.ensureVisible(vehicleNumberFinder);
      await tester.enterText(
        find.descendant(
          of: vehicleNumberFinder,
          matching: find.byType(TextField),
        ),
        '123ABC',
      );

      // Set licence and nid images directly on cubit
      cubit.doEvent(PickLicenceImageEvent(File('licence.png')));
      cubit.doEvent(PickNidImageEvent(File('nid.png')));
      await tester.pumpAndSettle();

      // Enter Email
      final emailFinder = find.widgetWithText(AppTextField, 'Email');
      await tester.ensureVisible(emailFinder);
      await tester.enterText(
        find.descendant(of: emailFinder, matching: find.byType(TextField)),
        'mohamed@test.com',
      );

      // Enter Phone
      final phoneFinder = find.widgetWithText(AppTextField, 'Phone number');
      await tester.ensureVisible(phoneFinder);
      await tester.enterText(
        find.descendant(of: phoneFinder, matching: find.byType(TextField)),
        '01012345678',
      );

      // Enter NID
      final nidFinder = find.widgetWithText(AppTextField, 'ID number');
      await tester.ensureVisible(nidFinder);
      await tester.enterText(
        find.descendant(of: nidFinder, matching: find.byType(TextField)),
        '12345678901234',
      );

      // Enter Password
      final passwordFinder = find.widgetWithText(AppTextField, 'Password');
      await tester.ensureVisible(passwordFinder);
      await tester.enterText(
        find.descendant(of: passwordFinder, matching: find.byType(TextField)),
        'Password123!',
      );

      // Enter Confirm Password
      final confirmPasswordFinder = find
          .widgetWithText(AppTextField, 'Confirm password')
          .first;
      await tester.ensureVisible(confirmPasswordFinder);
      await tester.enterText(
        find.descendant(
          of: confirmPasswordFinder,
          matching: find.byType(TextField),
        ),
        'Password123!',
      );

      // Tap Continue
      final continueBtn = find.text('Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(fakeRepo.lastParams, isNotNull);
      expect(fakeRepo.lastParams!.firstName, 'Mohamed');
      expect(fakeRepo.lastParams!.lastName, 'Ali');
      expect(fakeRepo.lastParams!.email, 'mohamed@test.com');
      expect(fakeRepo.lastParams!.phone, '01012345678');
    },
  );
}
