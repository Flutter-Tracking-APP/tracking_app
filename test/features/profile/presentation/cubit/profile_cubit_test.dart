import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_state.dart';

class FakeProfileRepo implements ProfileRepository {
  ApiResults<UserProfileEntity>? profileResult;

  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async => profileResult!;

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      const Success('ok');

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
  Future<bool> isRemembered() async => false;

  @override
  Future<void> saveToken(String token, {bool rememberMe = false}) async {}

  @override
  Future<void> setRememberMe(bool value) async {}
}

void main() {
  late FakeProfileRepo fakeRepo;
  late FakeSessionService fakeSessionService;
  late GetProfileUseCase getProfileUseCase;

  setUp(() {
    fakeRepo = FakeProfileRepo();
    fakeSessionService = FakeSessionService();
    getProfileUseCase = GetProfileUseCase(fakeRepo);
  });

  const testEntity = UserProfileEntity(
    id: 'p-1',
    firstName: 'Nour',
    lastName: 'Mohamed',
    email: 'nour@test.com',
    phoneNumber: '01010522698',
    gender: 0,
  );

  group('ProfileCubit', () {
    test('initial state has initial BaseStates', () {
      final cubit = ProfileCubit(getProfileUseCase, fakeSessionService);
      expect(cubit.state.profileState.isLoading, false);
      expect(cubit.state.logoutState.isLoading, false);
      cubit.close();
    });

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then success when GetProfileEvent succeeds',
      build: () {
        fakeRepo.profileResult = const Success(testEntity);
        return ProfileCubit(getProfileUseCase, fakeSessionService);
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
        return ProfileCubit(getProfileUseCase, fakeSessionService);
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
      'clears session and emits success on LogoutEvent',
      build: () => ProfileCubit(getProfileUseCase, fakeSessionService),
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
  });
}
