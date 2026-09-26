import 'package:json_annotation/json_annotation.dart';

part 'update_order_status_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class UpdateOrderStatusRequestDto {
  final String status;

  const UpdateOrderStatusRequestDto({required this.status});

  Map<String, dynamic> toJson() => _$UpdateOrderStatusRequestDtoToJson(this);
}
