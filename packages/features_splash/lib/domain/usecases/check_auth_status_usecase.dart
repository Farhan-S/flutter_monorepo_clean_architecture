import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../repositories/app_initialization_repository.dart';

/// Use case for checking authentication status
class CheckAuthStatusUseCase {
  final AppInitializationRepository repository;

  CheckAuthStatusUseCase(this.repository);

  /// Execute auth status check
  ///
  /// Returns [Right] with bool (true if authenticated) on success
  /// Returns [Left] with [ApiException] on failure
  Future<Either<ApiException, bool>> call() async {
    return await repository.checkAuthStatus();
  }
}
