import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/app_init_entity.dart';
import '../repositories/app_initialization_repository.dart';

/// Use case for initializing the app
class InitializeAppUseCase {
  final AppInitializationRepository repository;

  InitializeAppUseCase(this.repository);

  /// Execute app initialization
  ///
  /// Returns [Right] with [AppInitEntity] on success
  /// Returns [Left] with [ApiException] on failure
  Future<Either<ApiException, AppInitEntity>> call() async {
    return await repository.initializeApp();
  }
}
