import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/apply_as_driver_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_cubit.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_events.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_state.dart';

class FakeApplyDriverRepo implements ApplyDriverRepository {
  ApiResults<DriverApplicationEntity>? applyResult;
  ApiResults<List<VehicleTypeEntity>>? vehicleTypesResult;

  @override
  Future<ApiResults<DriverApplicationEntity>> applyAsDriver(
    ApplyDriverParams params,
  ) async {
    return applyResult!;
  }

  @override
  Future<ApiResults<List<VehicleTypeEntity>>> getVehicleTypes() async {
    return vehicleTypesResult!;
  }
}

void main() {
  late FakeApplyDriverRepo fakeRepo;
  late ApplyAsDriverUseCase applyUseCase;
  late GetVehicleTypesUseCase getVehicleTypesUseCase;

  setUp(() {
    fakeRepo = FakeApplyDriverRepo();
    applyUseCase = ApplyAsDriverUseCase(fakeRepo);
    getVehicleTypesUseCase = GetVehicleTypesUseCase(fakeRepo);
  });

  const dummyEntity = DriverApplicationEntity(
    id: 'd-1',
    name: 'Mohamed',
    email: 'm@test.com',
    phone: '01011111111',
    createdAt: '2026-01-01',
    updatedAt: '2026-01-01',
    gender: 'Male',
    notificationStatus: 'on',
  );

  final dummyFile = File('dummy.png');
  final testParams = ApplyDriverParams(
    firstName: 'Mohamed',
    lastName: 'Ahmed',
    email: 'm@test.com',
    phone: '01011111111',
    password: 'Password123!',
    confirmPassword: 'Password123!',
    gender: 1,
    nid: '12345678901234',
    nidImage: dummyFile,
    vehicleTypeId: 'v-1',
    vehiclePlateNumber: '123',
    vehicleCapacity: 4,
    licenceImage: dummyFile,
    fcmToken: 'fcm',
  );

  group('ApplyDriverCubit', () {
    test('initial state has default gender 0 and initial BaseStates', () {
      final cubit = ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase);
      expect(cubit.state.selectedGender, 0);
      expect(cubit.state.applyState.isLoading, false);
      expect(cubit.state.vehicleTypesState.isLoading, false);
      cubit.close();
    });

    blocTest<ApplyDriverCubit, ApplyDriverState>(
      'emits loading then success when GetVehicleTypesEvent succeeds',
      build: () {
        fakeRepo.vehicleTypesResult = const Success([
          VehicleTypeEntity(id: 'v-1', name: 'Car'),
        ]);
        return ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase);
      },
      act: (cubit) => cubit.doEvent(const GetVehicleTypesEvent()),
      expect: () => [
        predicate<ApplyDriverState>((s) => s.vehicleTypesState.isLoading),
        predicate<ApplyDriverState>(
          (s) =>
              s.vehicleTypesState.data?.length == 1 &&
              s.selectedVehicleType?.name == 'Car',
        ),
      ],
    );

    blocTest<ApplyDriverCubit, ApplyDriverState>(
      'emits loading then error when GetVehicleTypesEvent fails',
      build: () {
        fakeRepo.vehicleTypesResult = const Failure(
          'Network failure',
          AppError.noConnection,
        );
        return ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase);
      },
      act: (cubit) => cubit.doEvent(const GetVehicleTypesEvent()),
      expect: () => [
        predicate<ApplyDriverState>((s) => s.vehicleTypesState.isLoading),
        predicate<ApplyDriverState>(
          (s) => s.vehicleTypesState.errorMessage == 'Network failure',
        ),
      ],
    );

    blocTest<ApplyDriverCubit, ApplyDriverState>(
      'emits loading then success when SubmitApplyDriverEvent succeeds',
      build: () {
        fakeRepo.applyResult = const Success(dummyEntity);
        return ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase);
      },
      act: (cubit) => cubit.doEvent(SubmitApplyDriverEvent(testParams)),
      expect: () => [
        predicate<ApplyDriverState>((s) => s.applyState.isLoading),
        predicate<ApplyDriverState>((s) => s.applyState.data == dummyEntity),
      ],
    );

    blocTest<ApplyDriverCubit, ApplyDriverState>(
      'emits loading then error when SubmitApplyDriverEvent fails',
      build: () {
        fakeRepo.applyResult = const Failure(
          'Phone already in use',
          AppError.conflict,
        );
        return ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase);
      },
      act: (cubit) => cubit.doEvent(SubmitApplyDriverEvent(testParams)),
      expect: () => [
        predicate<ApplyDriverState>((s) => s.applyState.isLoading),
        predicate<ApplyDriverState>(
          (s) => s.applyState.errorMessage == 'Phone already in use',
        ),
      ],
    );

    blocTest<ApplyDriverCubit, ApplyDriverState>(
      'updates gender when SelectGenderEvent is triggered',
      build: () => ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase),
      act: (cubit) => cubit.doEvent(const SelectGenderEvent(1)),
      expect: () => [predicate<ApplyDriverState>((s) => s.selectedGender == 1)],
    );

    blocTest<ApplyDriverCubit, ApplyDriverState>(
      'toggles isPasswordVisible when TogglePasswordVisibilityEvent is triggered',
      build: () => ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase),
      act: (cubit) => cubit.doEvent(const TogglePasswordVisibilityEvent()),
      expect: () => [
        predicate<ApplyDriverState>((s) => s.isPasswordVisible == true),
      ],
    );

    blocTest<ApplyDriverCubit, ApplyDriverState>(
      'toggles isConfirmPasswordVisible when ToggleConfirmPasswordVisibilityEvent is triggered',
      build: () => ApplyDriverCubit(applyUseCase, getVehicleTypesUseCase),
      act: (cubit) =>
          cubit.doEvent(const ToggleConfirmPasswordVisibilityEvent()),
      expect: () => [
        predicate<ApplyDriverState>((s) => s.isConfirmPasswordVisible == true),
      ],
    );
  });
}
