import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/profile/data/client/profile_api_client.dart';
import 'package:tracking_app/features/profile/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/request/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/profile_action_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/user_profile_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/vehicle_info_response_dto.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserProfileResponseDto> getProfile() {
    return _apiClient.getProfile();
  }

  @override
  Future<ProfileActionResponseDto> updateProfile(Map<String, dynamic> parts) {
    return _apiClient.updateProfile(parts);
  }

  @override
  Future<VehicleInfoResponseDto> getVehicleInfo() {
    return _apiClient.getVehicleInfo();
  }

  @override
  Future<ProfileActionResponseDto> updateVehicle(FormData formData) {
    return _apiClient.updateVehicle(formData);
  }

  @override
  Future<ProfileActionResponseDto> changePassword(
    ChangePasswordRequestDto request,
  ) {
    return _apiClient.changePassword(request);
  }
}
