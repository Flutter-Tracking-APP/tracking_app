import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class RefreshTokenRequestDto {
  final String refreshToken;

  const RefreshTokenRequestDto({required this.refreshToken});

  Map<String, dynamic> toJson() => _$RefreshTokenRequestDtoToJson(this);
}
