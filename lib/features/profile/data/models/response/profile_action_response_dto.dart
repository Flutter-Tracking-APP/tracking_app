import 'package:json_annotation/json_annotation.dart';

part 'profile_action_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProfileActionResponseDto {
  final bool? status;
  final int? code;
  final String? message;

  const ProfileActionResponseDto({this.status, this.code, this.message});

  factory ProfileActionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileActionResponseDtoFromJson(json);
}
