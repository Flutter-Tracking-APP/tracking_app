import 'package:json_annotation/json_annotation.dart';

part 'vehicle_types_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class VehicleTypesResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<VehicleTypeDto>? data;

  const VehicleTypesResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory VehicleTypesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypesResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class VehicleTypeDto {
  final String? id;
  final String? name;

  const VehicleTypeDto({this.id, this.name});

  factory VehicleTypeDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeDtoFromJson(json);
}
