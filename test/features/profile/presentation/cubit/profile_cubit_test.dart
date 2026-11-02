import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_state.dart';

class FakeProfileRepo implements ProfileRepository {
  ApiResults<UserProfileEntity>? profileResult;
  ApiResults<VehicleInfoEntity>? vehicleInfoResult;

  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async => profileResult!;

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<VehicleInfoEntity>> getVehicleInfo() async =>
      vehicleInfoResult ?? const Failure('not needed', AppError.general);

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => const Success('ok');
}

class FakeSessionService implements SessionService {
  bool sessionCleared = false;

  @override
  Future<void> clearSession() async {
    sessionCleared = true;
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
  late FakeProfileRepo fakeRepo;
  late FakeSessionService fakeSessionService;
  late GetProfileUseCase getProfileUseCase;
  late GetVehicleInfoUseCase getVehicleInfoUseCase;

  setUp(() {
    fakeRepo = FakeProfileRepo();
    fakeSessionService = FakeSessionService();
    getProfileUseCase = GetProfileUseCase(fakeRepo);
    getVehicleInfoUseCase = GetVehicleInfoUseCase(fakeRepo);
  });

  const testEntity = UserProfileEntity(
    id: 'p-1',
    firstName: 'Nour',
    lastName: 'Mohamed',
    email: 'nour@test.com',
    phoneNumber: '01010522698',
    gender: 0,
  );

  const testVehicleEntity = VehicleInfoEntity(
    vehicleId: 'v-1',
    vehicleTypeId: 'vt-1',
    vehicleTypeName: 'Bike',
    plateNumber: 'UP16DL0007',
    capacity: 2,
    licenseDocument: 'doc.png',
  );

  group('ProfileCubit', () {
    test('initial state has initial BaseStates', () {
      final cubit = ProfileCubit(
        getProfileUseCase,
        getVehicleInfoUseCase,
        fakeSessionService,
      );
      expect(cubit.state.profileState.isLoading, false);
      expect(cubit.state.vehicleInfoState.isLoading, false);
      expect(cubit.state.logoutState.isLoading, false);
      cubit.close();
    });

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then success when GetProfileEvent succeeds',
      build: () {
        fakeRepo.profileResult = const Success(testEntity);
        return ProfileCubit(
          getProfileUseCase,
          getVehicleInfoUseCase,
          fakeSessionService,
        );
      },
      act: (cubit) => cubit.doEvent(const GetProfileEvent()),
      expect: () => [
        predicate<ProfileState>((s) => s.profileState.isLoading),
        predicate<ProfileState>((s) => s.profileState.data?.id == 'p-1'),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then error when GetProfileEvent fails',
      build: () {
        fakeRepo.profileResult = const Failure(
          'Failed to fetch',
          AppError.server,
        );
        return ProfileCubit(
          getProfileUseCase,
          getVehicleInfoUseCase,
          fakeSessionService,
        );
      },
      act: (cubit) => cubit.doEvent(const GetProfileEvent()),
      expect: () => [
        predicate<ProfileState>((s) => s.profileState.isLoading),
        predicate<ProfileState>(
          (s) => s.profileState.errorMessage == 'Failed to fetch',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then success when GetVehicleInfoEvent succeeds',
      build: () {
        fakeRepo.vehicleInfoResult = const Success(testVehicleEntity);
        return ProfileCubit(
          getProfileUseCase,
          getVehicleInfoUseCase,
          fakeSessionService,
        );
      },
      act: (cubit) => cubit.doEvent(const GetVehicleInfoEvent()),
      expect: () => [
        predicate<ProfileState>((s) => s.vehicleInfoState.isLoading),
        predicate<ProfileState>(
          (s) => s.vehicleInfoState.data?.vehicleTypeName == 'Bike',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then error when GetVehicleInfoEvent fails',
      build: () {
        fakeRepo.vehicleInfoResult = const Failure(
          'Failed to fetch vehicle',
          AppError.server,
        );
        return ProfileCubit(
          getProfileUseCase,
          getVehicleInfoUseCase,
          fakeSessionService,
        );
      },
      act: (cubit) => cubit.doEvent(const GetVehicleInfoEvent()),
      expect: () => [
        predicate<ProfileState>((s) => s.vehicleInfoState.isLoading),
        predicate<ProfileState>(
          (s) => s.vehicleInfoState.errorMessage == 'Failed to fetch vehicle',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'clears session and emits success on LogoutEvent',
      build: () => ProfileCubit(
        getProfileUseCase,
        getVehicleInfoUseCase,
        fakeSessionService,
      ),
      act: (cubit) => cubit.doEvent(const LogoutEvent()),
      expect: () => [
        predicate<ProfileState>((s) => s.logoutState.isLoading),
        predicate<ProfileState>(
          (s) => !s.logoutState.isLoading && s.logoutState.errorMessage == null,
        ),
      ],
      verify: (_) {
        expect(fakeSessionService.sessionCleared, true);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits success immediately when UpdateProfileLocallyEvent is received',
      build: () => ProfileCubit(
        getProfileUseCase,
        getVehicleInfoUseCase,
        fakeSessionService,
      ),
      act: (cubit) =>
          cubit.doEvent(const UpdateProfileLocallyEvent(testEntity)),
      expect: () => [
        predicate<ProfileState>(
          (s) => s.profileState.data?.id == 'p-1' && !s.profileState.isLoading,
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'preserves existing cached profile data when refreshing via GetProfileEvent',
      seed: () => const ProfileState(
        profileState: BaseState(
          isLoading: false,
          errorMessage: null,
          data: testEntity,
        ),
      ),
      build: () {
        fakeRepo.profileResult = const Success(
          UserProfileEntity(
            id: 'p-1',
            firstName: 'Updated',
            lastName: 'Name',
            email: 'nour@test.com',
            phoneNumber: '01010522698',
            gender: 0,
          ),
        );
        return ProfileCubit(
          getProfileUseCase,
          getVehicleInfoUseCase,
          fakeSessionService,
        );
      },
      act: (cubit) => cubit.doEvent(const GetProfileEvent()),
      expect: () => [
        predicate<ProfileState>(
          (s) => s.profileState.isLoading && s.profileState.data == testEntity,
        ),
        predicate<ProfileState>(
          (s) =>
              !s.profileState.isLoading &&
              s.profileState.data?.firstName == 'Updated',
        ),
      ],
    );
  });
}
