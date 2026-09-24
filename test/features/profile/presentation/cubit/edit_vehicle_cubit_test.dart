import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_vehicle_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_state.dart';
import '../../../../helpers/fake_image_picker_service.dart';

class FakeVehicleApplyRepo implements ApplyDriverRepository {
  ApiResults<List<VehicleTypeEntity>>? vehicleTypesResult;

  @override
  Future<ApiResults<DriverApplicationEntity>> applyAsDriver(
    ApplyDriverParams params,
  ) async => const Failure('not needed', AppError.general);

  @override
  Future<ApiResults<List<VehicleTypeEntity>>> getVehicleTypes() async =>
      vehicleTypesResult!;
}

class FakeVehicleProfileRepo implements ProfileRepository {
  ApiResults<String>? updateResult;

  @override
  Future<ApiResults<UserProfileEntity>> getProfile() async =>
      const Failure('not needed', AppError.general);

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) async =>
      const Success('ok');

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) async =>
      updateResult!;

  @override
  Future<ApiResults<String>> changePassword(
    ChangePasswordParams params,
  ) async => const Success('ok');
}

void main() {
  late FakeVehicleApplyRepo fakeApplyRepo;
  late FakeVehicleProfileRepo fakeProfileRepo;
  late GetVehicleTypesUseCase getVehicleTypesUseCase;
  late UpdateVehicleUseCase updateVehicleUseCase;
  late FakeImagePickerService fakeImagePicker;

  setUp(() {
    fakeApplyRepo = FakeVehicleApplyRepo();
    fakeProfileRepo = FakeVehicleProfileRepo();
    getVehicleTypesUseCase = GetVehicleTypesUseCase(fakeApplyRepo);
    updateVehicleUseCase = UpdateVehicleUseCase(fakeProfileRepo);
    fakeImagePicker = FakeImagePickerService();
  });

  const testTypes = [VehicleTypeEntity(id: 'v-1', name: 'Car')];
  const testParams = UpdateVehicleParams(
    vehicleTypeId: 'v-1',
    plateNumber: '222',
  );

  group('EditVehicleCubit', () {
    blocTest<EditVehicleCubit, EditVehicleState>(
      'emits loading then success on LoadVehicleTypesEvent',
      build: () {
        fakeApplyRepo.vehicleTypesResult = const Success(testTypes);
        return EditVehicleCubit(
          getVehicleTypesUseCase,
          updateVehicleUseCase,
          fakeImagePicker,
        );
      },
      act: (cubit) => cubit.doEvent(const LoadVehicleTypesEvent()),
      expect: () => [
        predicate<EditVehicleState>((s) => s.vehicleTypesState.isLoading),
        predicate<EditVehicleState>(
          (s) =>
              s.vehicleTypesState.data?.length == 1 &&
              s.selectedVehicleType?.name == 'Car',
        ),
      ],
    );

    blocTest<EditVehicleCubit, EditVehicleState>(
      'updates selectedVehicleType on SelectVehicleTypeEvent',
      build: () => EditVehicleCubit(
        getVehicleTypesUseCase,
        updateVehicleUseCase,
        fakeImagePicker,
      ),
      act: (cubit) => cubit.doEvent(SelectVehicleTypeEvent(testTypes.first)),
      expect: () => [
        predicate<EditVehicleState>((s) => s.selectedVehicleType?.id == 'v-1'),
      ],
    );

    blocTest<EditVehicleCubit, EditVehicleState>(
      'updates licenseFile on PickLicenseDocumentEvent with explicit file',
      build: () => EditVehicleCubit(
        getVehicleTypesUseCase,
        updateVehicleUseCase,
        fakeImagePicker,
      ),
      act: (cubit) => cubit.doEvent(PickLicenseDocumentEvent(File('lic.png'))),
      expect: () => [
        predicate<EditVehicleState>((s) => s.licenseFile?.path == 'lic.png'),
      ],
    );

    blocTest<EditVehicleCubit, EditVehicleState>(
      'picks license document via ImagePickerService when file is null',
      build: () {
        fakeImagePicker.fileToReturn = File('picked_lic.png');
        return EditVehicleCubit(
          getVehicleTypesUseCase,
          updateVehicleUseCase,
          fakeImagePicker,
        );
      },
      act: (cubit) => cubit.doEvent(const PickLicenseDocumentEvent()),
      expect: () => [
        predicate<EditVehicleState>(
          (s) => s.licenseFile?.path == 'picked_lic.png',
        ),
      ],
    );

    blocTest<EditVehicleCubit, EditVehicleState>(
      'emits loading then success on SubmitVehicleInfoEvent',
      build: () {
        fakeProfileRepo.updateResult = const Success('Updated');
        return EditVehicleCubit(
          getVehicleTypesUseCase,
          updateVehicleUseCase,
          fakeImagePicker,
        );
      },
      act: (cubit) => cubit.doEvent(const SubmitVehicleInfoEvent(testParams)),
      expect: () => [
        predicate<EditVehicleState>((s) => s.updateVehicleState.isLoading),
        predicate<EditVehicleState>(
          (s) => s.updateVehicleState.data == 'Updated',
        ),
      ],
    );
  });
}
