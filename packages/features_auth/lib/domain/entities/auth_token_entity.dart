import 'package:equatable/equatable.dart';

/// Domain layer authentication token entity
class AuthTokenEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  const AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType = 'Bearer',
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn, tokenType];

  @override
  String toString() =>
      'AuthTokenEntity(accessToken: ${accessToken.substring(0, 10)}..., tokenType: $tokenType)';
}
