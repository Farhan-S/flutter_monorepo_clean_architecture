import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:features_user/features_user.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<ApiException, UserEntity>> getUserById(String id) async {
    try {
      final userModel = await _remoteDataSource.getUserById(id);

      return Right(userModel.toEntity());
    } on ApiException catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      return Left(UnknownException('Failed to get user', e, stackTrace));
    }
  }

  @override
  Future<Either<ApiException, UserEntity>> updateUser({
    required String id,
    String? name,
    String? email,
    String? avatar,
  }) async {
    try {
      final userModel = await _remoteDataSource.updateUser(
        id: id,
        name: name,
        email: email,
        avatar: avatar,
      );

      return Right(userModel.toEntity());
    } on ApiException catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      return Left(UnknownException('Failed to update user', e, stackTrace));
    }
  }

  @override
  Future<Either<ApiException, void>> deleteUser(String id) async {
    try {
      await _remoteDataSource.deleteUser(id);

      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      return Left(UnknownException('Failed to delete user', e, stackTrace));
    }
  }

  @override
  Future<Either<ApiException, List<UserEntity>>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final userModels = await _remoteDataSource.getUsers(
        page: page,
        limit: limit,
      );

      final entities = userModels.map((model) => model.toEntity()).toList();

      return Right(entities);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      return Left(UnknownException('Failed to get users', e, stackTrace));
    }
  }
}
