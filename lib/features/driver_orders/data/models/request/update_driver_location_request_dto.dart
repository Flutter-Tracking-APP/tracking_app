import 'package:json_annotation/json_annotation.dart';

part 'update_driver_location_request_dto.g.dart';

@JsonSerializable()
class UpdateDriverLocationRequestDto {
  final num lat;
  final num lng;
  final String recordedAt;

  const UpdateDriverLocationRequestDto({
    required this.lat,
    required this.lng,
    required this.recordedAt,
  });

  factory UpdateDriverLocationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateDriverLocationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDriverLocationRequestDtoToJson(this);
}
