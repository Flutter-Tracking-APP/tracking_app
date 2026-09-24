import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_state.dart';
import '../../../../helpers/fake_image_picker_service.dart';

class FakeEditProfileRepo implements ProfileRepository {
  ApiResults<String>? updateResult;

  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async =>
      const Failure('not needed', AppError.general);

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      updateResult!;

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => const Success('ok');
}

void main() {
  late FakeEditProfileRepo fakeRepo;
  late UpdateProfileUseCase updateProfileUseCase;
  late FakeImagePickerService fakeImagePicker;

  setUp(() {
    fakeRepo = FakeEditProfileRepo();
    updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
    fakeImagePicker = FakeImagePickerService();
  });

  const testParams = UpdateProfileParams(
    firstName: 'Nour',
    lastName: 'Mohamed',
    phoneNumber: '01010522698',
    gender: 0,
    profilePictureUrl: '',
  );

  group('EditProfileCubit', () {
    blocTest<EditProfileCubit, EditProfileState>(
      'updates gender on SelectEditGenderEvent',
      build: () => EditProfileCubit(updateProfileUseCase, fakeImagePicker),
      act: (cubit) => cubit.doEvent(const SelectEditGenderEvent(1)),
      expect: () => [predicate<EditProfileState>((s) => s.selectedGender == 1)],
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'updates avatarFile on PickAvatarEvent with explicit file',
      build: () => EditProfileCubit(updateProfileUseCase, fakeImagePicker),
      act: (cubit) => cubit.doEvent(PickAvatarEvent(File('dummy.png'))),
      expect: () => [
        predicate<EditProfileState>((s) => s.avatarFile?.path == 'dummy.png'),
      ],
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'picks avatar via ImagePickerService when file is null',
      build: () {
        fakeImagePicker.fileToReturn = File('picked_avatar.png');
        return EditProfileCubit(updateProfileUseCase, fakeImagePicker);
      },
      act: (cubit) => cubit.doEvent(const PickAvatarEvent()),
      expect: () => [
        predicate<EditProfileState>(
          (s) => s.avatarFile?.path == 'picked_avatar.png',
        ),
      ],
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'emits loading then success on SubmitEditProfileEvent',
      build: () {
        fakeRepo.updateResult = const Success('Updated');
        return EditProfileCubit(updateProfileUseCase, fakeImagePicker);
      },
      act: (cubit) => cubit.doEvent(const SubmitEditProfileEvent(testParams)),
      expect: () => [
        predicate<EditProfileState>((s) => s.updateProfileState.isLoading),
        predicate<EditProfileState>(
          (s) => s.updateProfileState.data == 'Updated',
        ),
      ],
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'emits loading then error on SubmitEditProfileEvent failure',
      build: () {
        fakeRepo.updateResult = const Failure(
          'Failed to update',
          AppError.server,
        );
        return EditProfileCubit(updateProfileUseCase, fakeImagePicker);
      },
      act: (cubit) => cubit.doEvent(const SubmitEditProfileEvent(testParams)),
      expect: () => [
        predicate<EditProfileState>((s) => s.updateProfileState.isLoading),
        predicate<EditProfileState>(
          (s) => s.updateProfileState.errorMessage == 'Failed to update',
        ),
      ],
    );
  });
}
