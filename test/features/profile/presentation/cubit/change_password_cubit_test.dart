import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_state.dart';

class FakeChangePasswordRepo implements ProfileRepository {
  ApiResults<String>? changeResult;

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
  ) async => changeResult!;
}

class FakeChangePasswordSessionService implements SessionService {
  bool cleared = false;

  @override
  Future<void> clearSession() async {
    cleared = true;
  }

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

  @override
  Future<void> clearActiveOrderId() async {}

  @override
  Future<String?> getActiveOrderId() async => null;

  @override
  Future<void> saveActiveOrderId(String orderId) async {}
}

void main() {
  late FakeChangePasswordRepo fakeRepo;
  late FakeChangePasswordSessionService fakeSession;
  late ChangePasswordUseCase changePasswordUseCase;

  setUp(() {
    fakeRepo = FakeChangePasswordRepo();
    fakeSession = FakeChangePasswordSessionService();
    changePasswordUseCase = ChangePasswordUseCase(fakeRepo);
  });

  const testParams = ChangePasswordParams(
    currentPassword: 'old',
    newPassword: 'new',
    confirmNewPassword: 'new',
  );

  group('ChangePasswordCubit', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'toggles current password visibility',
      build: () => ChangePasswordCubit(changePasswordUseCase, fakeSession),
      act: (cubit) =>
          cubit.doEvent(const ToggleCurrentPasswordVisibilityEvent()),
      expect: () => [
        predicate<ChangePasswordState>(
          (s) => s.isCurrentPasswordVisible == true,
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'toggles new password visibility',
      build: () => ChangePasswordCubit(changePasswordUseCase, fakeSession),
      act: (cubit) => cubit.doEvent(const ToggleNewPasswordVisibilityEvent()),
      expect: () => [
        predicate<ChangePasswordState>((s) => s.isNewPasswordVisible == true),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'toggles confirm password visibility',
      build: () => ChangePasswordCubit(changePasswordUseCase, fakeSession),
      act: (cubit) =>
          cubit.doEvent(const ToggleConfirmNewPasswordVisibilityEvent()),
      expect: () => [
        predicate<ChangePasswordState>(
          (s) => s.isConfirmNewPasswordVisible == true,
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits loading then success and clears session on success',
      build: () {
        fakeRepo.changeResult = const Success('Password changed');
        return ChangePasswordCubit(changePasswordUseCase, fakeSession);
      },
      act: (cubit) =>
          cubit.doEvent(const SubmitChangePasswordEvent(testParams)),
      expect: () => [
        predicate<ChangePasswordState>((s) => s.changePasswordState.isLoading),
        predicate<ChangePasswordState>(
          (s) => s.changePasswordState.data == 'Password changed',
        ),
      ],
      verify: (_) {
        expect(fakeSession.cleared, true);
      },
    );
  });
}
