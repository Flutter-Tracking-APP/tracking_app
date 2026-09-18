import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/apply_as_driver_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';

class FakeApplyDriverRepository implements ApplyDriverRepository {
  ApiResults<DriverApplicationEntity>? applyResponse;
  ApiResults<List<VehicleTypeEntity>>? vehicleTypesResponse;

  @override
  Future<ApiResults<DriverApplicationEntity>> applyAsDriver(
    ApplyDriverParams params,
  ) async {
    return applyResponse!;
  }

  @override
  Future<ApiResults<List<VehicleTypeEntity>>> getVehicleTypes() async {
    return vehicleTypesResponse!;
  }
}

void main() {
  late FakeApplyDriverRepository fakeRepository;
  late ApplyAsDriverUseCase applyUseCase;
  late GetVehicleTypesUseCase getVehicleTypesUseCase;

  setUp(() {
    fakeRepository = FakeApplyDriverRepository();
    applyUseCase = ApplyAsDriverUseCase(fakeRepository);
    getVehicleTypesUseCase = GetVehicleTypesUseCase(fakeRepository);
  });

  test('ApplyAsDriverUseCase delegates directly to repository', () async {
    const expectedEntity = DriverApplicationEntity(
      id: '123',
      name: 'Ahmed',
      email: 'ahmed@test.com',
      phone: '01012345678',
      createdAt: '2026-01-01',
      updatedAt: '2026-01-01',
      gender: 'Male',
      notificationStatus: 'on',
    );
    fakeRepository.applyResponse = const Success(expectedEntity);

    final dummyFile = File('dummy.png');
    final params = ApplyDriverParams(
      firstName: 'Ahmed',
      lastName: 'Ali',
      email: 'ahmed@test.com',
      phone: '01012345678',
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

    final result = await applyUseCase.call(params);

    expect(result, isA<Success<DriverApplicationEntity>>());
    expect((result as Success).data, expectedEntity);
  });

  test('GetVehicleTypesUseCase delegates directly to repository', () async {
    const types = [VehicleTypeEntity(id: '1', name: 'Car')];
    fakeRepository.vehicleTypesResponse = const Success(types);

    final result = await getVehicleTypesUseCase.call();

    expect(result, isA<Success<List<VehicleTypeEntity>>>());
    expect((result as Success).data, types);
  });
}
