import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/app_init_entity.dart';
import '../../domain/repositories/app_initialization_repository.dart';
import '../datasources/app_init_datasource.dart';

/// Implementation of app initialization repository
class AppInitializationRepositoryImpl implements AppInitializationRepository {
  final AppInitDataSource dataSource;

  AppInitializationRepositoryImpl(this.dataSource);

  @override
  Future<Either<ApiException, AppInitEntity>> initializeApp() async {
    try {
      final result = await dataSource.initializeApp();

      if (!result.isInitialized && result.errorMessage != null) {
        return Left(ApiException(result.errorMessage!));
      }

      return Right(result);
    } catch (e) {
      return Left(ApiException('Failed to initialize app: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ApiException, bool>> checkAuthStatus() async {
    try {
      final isAuthenticated = await dataSource.checkAuthStatus();
      return Right(isAuthenticated);
    } catch (e) {
      return Left(ApiException('Failed to check auth status: ${e.toString()}'));
    }
  }
}
