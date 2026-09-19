import 'package:dio/dio.dart';
import 'package:tracking_app/features/profile/data/models/request/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/request/update_profile_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/profile_action_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/user_profile_response_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfileResponseDto> getProfile();
  Future<ProfileActionResponseDto> updateProfile(
    UpdateProfileRequestDto request,
  );
  Future<ProfileActionResponseDto> updateVehicle(FormData formData);
  Future<ProfileActionResponseDto> changePassword(
    ChangePasswordRequestDto request,
  );
}
