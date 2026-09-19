import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_vehicle_use_case.dart';

class FakeProfileRepository implements ProfileRepository {
  ApiResults<UserProfileEntity>? profileResult;
  ApiResults<String>? stringResult;

  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async => profileResult!;

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      stringResult!;

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) async =>
      stringResult!;

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => stringResult!;
}

void main() {
  late FakeProfileRepository fakeRepo;
  late GetProfileUseCase getProfileUseCase;
  late UpdateProfileUseCase updateProfileUseCase;
  late UpdateVehicleUseCase updateVehicleUseCase;
  late ChangePasswordUseCase changePasswordUseCase;

  setUp(() {
    fakeRepo = FakeProfileRepository();
    getProfileUseCase = GetProfileUseCase(fakeRepo);
    updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
    updateVehicleUseCase = UpdateVehicleUseCase(fakeRepo);
    changePasswordUseCase = ChangePasswordUseCase(fakeRepo);
  });

  const testEntity = UserProfileEntity(
    id: 'p-1',
    firstName: 'Nour',
    lastName: 'Mohamed',
    email: 'nour@test.com',
    phoneNumber: '01010522698',
    gender: 0,
  );

  group('Profile UseCases', () {
    test('GetProfileUseCase delegates directly to repository', () async {
      fakeRepo.profileResult = const Success(testEntity);
      final result = await getProfileUseCase.call();
      expect(result, isA<Success<UserProfileEntity>>());
    });

    test('UpdateProfileUseCase delegates directly to repository', () async {
      fakeRepo.stringResult = const Success('Updated');
      const params = UpdateProfileParams(
        firstName: 'Nour',
        lastName: 'Mohamed',
        phoneNumber: '01010522698',
        gender: 0,
        profilePictureUrl: '',
      );
      final result = await updateProfileUseCase.call(params);
      expect(result, isA<Success<String>>());
    });

    test('UpdateVehicleUseCase delegates directly to repository', () async {
      fakeRepo.stringResult = const Success('Updated');
      const params = UpdateVehicleParams(plateNumber: '222');
      final result = await updateVehicleUseCase.call(params);
      expect(result, isA<Success<String>>());
    });

    test('ChangePasswordUseCase delegates directly to repository', () async {
      fakeRepo.stringResult = const Success('Changed');
      const params = ChangePasswordParams(
        currentPassword: 'Password123!',
        newPassword: 'Password456!',
        confirmNewPassword: 'Password456!',
      );
      final result = await changePasswordUseCase.call(params);
      expect(result, isA<Success<String>>());
    });
  });
}
