import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:features_auth/features_auth.dart';

/// Use case for login operation
/// Each use case has a single responsibility
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<ApiException, AuthTokenEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
