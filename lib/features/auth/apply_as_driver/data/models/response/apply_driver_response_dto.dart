import 'package:json_annotation/json_annotation.dart';

part 'apply_driver_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ApplyDriverResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final DriverDataDto? data;

  const ApplyDriverResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory ApplyDriverResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApplyDriverResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class DriverDataDto {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? createdAt;
  final String? updatedAt;
  final String? gender;
  final String? notifcationStatus;

  const DriverDataDto({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.gender,
    this.notifcationStatus,
  });

  factory DriverDataDto.fromJson(Map<String, dynamic> json) =>
      _$DriverDataDtoFromJson(json);
}
