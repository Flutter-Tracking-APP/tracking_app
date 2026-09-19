import 'package:dio/dio.dart';
import 'package:tracking_app/features/profile/data/models/request/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/request/update_profile_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/user_profile_response_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';

extension UserProfileResponseDtoMapper on UserProfileResponseDto {
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: data?.id ?? '',
      firstName: data?.firstName ?? '',
      lastName: data?.lastName ?? '',
      email: data?.email ?? '',
      phoneNumber: data?.phoneNumber ?? '',
      gender: data?.gender ?? 0,
      profilePictureUrl: data?.profilePictureUrl,
    );
  }
}

extension UpdateProfileParamsMapper on UpdateProfileParams {
  UpdateProfileRequestDto toDto() {
    return UpdateProfileRequestDto(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      gender: gender,
      profilePictureUrl: profilePictureUrl,
    );
  }
}

extension ChangePasswordParamsMapper on ChangePasswordParams {
  ChangePasswordRequestDto toDto() {
    return ChangePasswordRequestDto(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}

extension UpdateVehicleParamsMapper on UpdateVehicleParams {
  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};
    if (vehicleTypeId != null && vehicleTypeId!.isNotEmpty) {
      map['vehicleTypeId'] = vehicleTypeId;
    }
    if (plateNumber != null && plateNumber!.isNotEmpty) {
      map['plateNumber'] = plateNumber;
    }
    if (licenseDocument != null) {
      map['licenseDocument'] = await MultipartFile.fromFile(
        licenseDocument!.path,
        filename: licenseDocument!.path.split(RegExp(r'[/\\]')).last,
      );
    }
    return FormData.fromMap(map);
  }
}
