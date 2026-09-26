import 'package:json_annotation/json_annotation.dart';

part 'update_order_status_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class UpdateOrderStatusResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final UpdateOrderStatusDataDto? data;

  const UpdateOrderStatusResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory UpdateOrderStatusResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStatusResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class UpdateOrderStatusDataDto {
  final String? orderId;
  final String? status;
  final String? occurredAt;

  const UpdateOrderStatusDataDto({
    this.orderId,
    this.status,
    this.occurredAt,
  });

  factory UpdateOrderStatusDataDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStatusDataDtoFromJson(json);
}
