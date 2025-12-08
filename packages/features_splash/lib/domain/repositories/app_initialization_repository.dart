import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/app_init_entity.dart';

/// Repository interface for app initialization
abstract class AppInitializationRepository {
  /// Initialize the app and check authentication status
  Future<Either<ApiException, AppInitEntity>> initializeApp();

  /// Check if user is authenticated
  Future<Either<ApiException, bool>> checkAuthStatus();
}
