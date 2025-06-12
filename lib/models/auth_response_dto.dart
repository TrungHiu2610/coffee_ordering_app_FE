import 'package:json_annotation/json_annotation.dart';
import 'api_models.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class AuthResponseDto {
  final User user;
  final String token;

  AuthResponseDto({
    required this.user,
    required this.token,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) => _$AuthResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);
}
