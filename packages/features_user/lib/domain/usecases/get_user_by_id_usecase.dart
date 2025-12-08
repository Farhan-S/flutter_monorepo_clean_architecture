import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:features_user/features_user.dart';

/// Use case to get user by ID
class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<Either<ApiException, UserEntity>> call(String userId) {
    return repository.getUserById(userId);
  }
}
