import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/data_sources/contract/apply_driver_remote_data_source.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/request/apply_driver_request_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/apply_driver_response_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/vehicle_types_response_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/repositories/apply_driver_repository_impl.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';

class FakeApplyDriverRemoteDataSource implements ApplyDriverRemoteDataSource {
  ApplyDriverResponseDto? applyResponse;
  VehicleTypesResponseDto? vehicleTypesResponse;
  Exception? exceptionToThrow;

  @override
  Future<ApplyDriverResponseDto> applyAsDriver(
    ApplyDriverRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return applyResponse!;
  }

  @override
  Future<VehicleTypesResponseDto> getVehicleTypes() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return vehicleTypesResponse!;
  }
}

void main() {
  late FakeApplyDriverRemoteDataSource fakeDataSource;
  late ApplyDriverRepositoryImpl repository;
  late ApplyDriverParams testParams;
  late Directory tempDir;
  late File dummyFile;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('repo_test');
    dummyFile = File('${tempDir.path}/test_file.png')
      ..writeAsBytesSync([0, 1, 2, 3]);

    fakeDataSource = FakeApplyDriverRemoteDataSource();
    repository = ApplyDriverRepositoryImpl(fakeDataSource);

    testParams = ApplyDriverParams(
      firstName: 'Ahmed',
      lastName: 'Ali',
      email: 'ahmed@test.com',
      phone: '01012345678',
      password: 'Password123!',
      confirmPassword: 'Password123!',
      gender: 1,
      nid: '12345678901234',
      nidImage: dummyFile,
      vehicleTypeId: 'v-123',
      vehiclePlateNumber: 'ABC 123',
      vehicleCapacity: 4,
      licenceImage: dummyFile,
      fcmToken: 'mock_token',
    );
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('applyAsDriver', () {
    test(
      'returns Success when remote data source returns valid response',
      () async {
        fakeDataSource.applyResponse = const ApplyDriverResponseDto(
          status: true,
          code: 200,
          message: 'Success',
          data: DriverDataDto(
            id: 'driver-1',
            name: 'Ahmed Ali',
            email: 'ahmed@test.com',
            phone: '01012345678',
            createdAt: '2026-01-01',
            updatedAt: '2026-01-01',
            gender: 'Male',
            notifcationStatus: 'on',
          ),
        );

        final result = await repository.applyAsDriver(testParams);

        expect(result, isA<Success<DriverApplicationEntity>>());
        final success = result as Success<DriverApplicationEntity>;
        expect(success.data.id, 'driver-1');
        expect(success.data.name, 'Ahmed Ali');
      },
    );

    test(
      'returns Failure with AppError via safeCall when DioException occurs',
      () async {
        fakeDataSource.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionTimeout,
        );

        final result = await repository.applyAsDriver(testParams);

        expect(result, isA<Failure<DriverApplicationEntity>>());
        final failure = result as Failure<DriverApplicationEntity>;
        expect(failure.error, AppError.timeout);
      },
    );
  });

  group('getVehicleTypes', () {
    test('returns Success with mapped entities on successful call', () async {
      fakeDataSource.vehicleTypesResponse = const VehicleTypesResponseDto(
        status: true,
        code: 200,
        message: 'Retrieved',
        data: [
          VehicleTypeDto(id: 'v-1', name: 'Car'),
          VehicleTypeDto(id: 'v-2', name: 'Motorcycle'),
        ],
      );

      final result = await repository.getVehicleTypes();

      expect(result, isA<Success<List<VehicleTypeEntity>>>());
      final success = result as Success<List<VehicleTypeEntity>>;
      expect(success.data.length, 2);
      expect(success.data.first.name, 'Car');
    });

    test('returns Failure when an exception is thrown', () async {
      fakeDataSource.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );

      final result = await repository.getVehicleTypes();

      expect(result, isA<Failure<List<VehicleTypeEntity>>>());
      final failure = result as Failure<List<VehicleTypeEntity>>;
      expect(failure.error, AppError.noConnection);
    });
  });
}
