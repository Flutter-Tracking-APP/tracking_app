import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/profile/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/request/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/profile_action_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/user_profile_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/vehicle_info_response_dto.dart';
import 'package:tracking_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';

class FakeProfileRemoteDataSource implements ProfileRemoteDataSource {
  UserProfileResponseDto? profileResponse;
  ProfileActionResponseDto? actionResponse;
  Exception? exceptionToThrow;

  @override
  Future<UserProfileResponseDto> getProfile() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return profileResponse!;
  }

  @override
  Future<ProfileActionResponseDto> updateProfile(
    Map<String, dynamic> parts,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return actionResponse!;
  }

  @override
  Future<VehicleInfoResponseDto> getVehicleInfo() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return const VehicleInfoResponseDto();
  }

  @override
  Future<ProfileActionResponseDto> updateVehicle(FormData formData) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return actionResponse!;
  }

  @override
  Future<ProfileActionResponseDto> changePassword(
    ChangePasswordRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return actionResponse!;
  }
}

void main() {
  late FakeProfileRemoteDataSource fakeRemoteDataSource;
  late ProfileRepositoryImpl repository;

  setUp(() {
    fakeRemoteDataSource = FakeProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(fakeRemoteDataSource);
  });

  const testProfileDto = UserProfileResponseDto(
    status: true,
    code: 200,
    message: 'Profile retrieved',
    data: UserProfileDataDto(
      id: 'p-1',
      firstName: 'Nour',
      lastName: 'Mohamed',
      email: 'nour@test.com',
      phoneNumber: '01010522698',
      gender: 0,
      profilePictureUrl: null,
    ),
  );

  group('ProfileRepositoryImpl', () {
    test(
      'getProfile returns Success with mapped entity on valid response',
      () async {
        fakeRemoteDataSource.profileResponse = testProfileDto;

        final result = await repository.getProfile();

        expect(result, isA<Success>());
        final success = result as Success;
        expect(success.data.id, 'p-1');
        expect(success.data.firstName, 'Nour');
        expect(success.data.email, 'nour@test.com');
      },
    );

    test(
      'getProfile returns Failure with AppError via safeCall on DioException',
      () async {
        fakeRemoteDataSource.exceptionToThrow = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        final result = await repository.getProfile();

        expect(result, isA<Failure>());
        final failure = result as Failure;
        expect(failure.error, AppError.timeout);
      },
    );

    test(
      'updateProfile returns Success with message on valid response',
      () async {
        fakeRemoteDataSource.actionResponse = const ProfileActionResponseDto(
          status: true,
          code: 200,
          message: 'Profile updated successfully',
        );

        const params = UpdateProfileParams(
          firstName: 'Nour',
          lastName: 'Mohamed',
          phoneNumber: '01010522698',
          gender: 0,
          profilePicture: null,
        );

        final result = await repository.updateProfile(params);

        expect(result, isA<Success>());
        final success = result as Success;
        expect(success.data, 'Profile updated successfully');
      },
    );

    test(
      'updateVehicle returns Success with message on valid response',
      () async {
        fakeRemoteDataSource.actionResponse = const ProfileActionResponseDto(
          status: true,
          code: 200,
          message: 'Vehicle info updated successfully',
        );

        const params = UpdateVehicleParams(
          plateNumber: '222',
          vehicleTypeId: 'v-1',
        );

        final result = await repository.updateVehicle(params);

        expect(result, isA<Success>());
        final success = result as Success;
        expect(success.data, 'Vehicle info updated successfully');
      },
    );

    test(
      'changePassword returns Success with message on valid response',
      () async {
        fakeRemoteDataSource.actionResponse = const ProfileActionResponseDto(
          status: true,
          code: 200,
          message: 'Password changed successfully',
        );

        const params = ChangePasswordParams(
          currentPassword: 'Password123!',
          newPassword: 'Password456!',
          confirmNewPassword: 'Password456!',
        );

        final result = await repository.changePassword(params);

        expect(result, isA<Success>());
        final success = result as Success;
        expect(success.data, 'Password changed successfully');
      },
    );
  });
}
