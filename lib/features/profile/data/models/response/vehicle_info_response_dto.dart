import 'package:json_annotation/json_annotation.dart';

part 'vehicle_info_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class VehicleInfoResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final VehicleInfoDataDto? data;

  const VehicleInfoResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory VehicleInfoResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class VehicleInfoDataDto {
  final String? vehicleId;
  final String? vehicleTypeId;
  final String? vehicleTypeName;
  final String? plateNumber;
  final int? capacity;
  final String? licenseDocument;

  const VehicleInfoDataDto({
    this.vehicleId,
    this.vehicleTypeId,
    this.vehicleTypeName,
    this.plateNumber,
    this.capacity,
    this.licenseDocument,
  });

  factory VehicleInfoDataDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoDataDtoFromJson(json);
}
