import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:features_auth/features_auth.dart';

/// Use case for logout operation
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<ApiException, void>> call() {
    return repository.logout();
  }
}
