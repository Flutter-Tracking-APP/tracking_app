import 'package:json_annotation/json_annotation.dart';

part 'user_profile_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class UserProfileResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final UserProfileDataDto? data;

  const UserProfileResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory UserProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class UserProfileDataDto {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final int? gender;
  final String? profilePictureUrl;

  const UserProfileDataDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
  });

  factory UserProfileDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDataDtoFromJson(json);
}
