import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_dto.g.dart';

@JsonSerializable()
class RefreshTokenResponseDto {
  final bool status;
  final int code;
  final String message;
  final RefreshTokenDataDto? data;

  const RefreshTokenResponseDto({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseDtoToJson(this);
}

@JsonSerializable()
class RefreshTokenDataDto {
  final String token;
  final String refreshToken;

  const RefreshTokenDataDto({required this.token, required this.refreshToken});

  factory RefreshTokenDataDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenDataDtoToJson(this);
}
