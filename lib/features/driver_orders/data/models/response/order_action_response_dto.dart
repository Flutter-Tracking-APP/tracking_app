import 'package:json_annotation/json_annotation.dart';

part 'order_action_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderActionResponseDto {
  final bool? status;
  final String? message;

  const OrderActionResponseDto({this.status, this.message});

  factory OrderActionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrderActionResponseDtoFromJson(json);
}
