import 'package:dio/dio.dart';
import 'package:core/core.dart';
import 'package:features_user/features_user.dart';

/// Remote data source for user operations
class UserRemoteDataSource {
  final DioClient _dioClient;

  UserRemoteDataSource(this._dioClient);

  /// Get user by ID
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _dioClient.get(ApiRoutes.userById(id));

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw UnknownException('Failed to get user', e, e.stackTrace);
    } catch (e, stackTrace) {
      throw UnknownException('Failed to get user', e, stackTrace);
    }
  }

  /// Update user
  Future<UserModel> updateUser({
    required String id,
    String? name,
    String? email,
    String? avatar,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (avatar != null) data['avatar'] = avatar;

      final response = await _dioClient.put(ApiRoutes.userById(id), data: data);

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw UnknownException('Failed to update user', e, e.stackTrace);
    } catch (e, stackTrace) {
      throw UnknownException('Failed to update user', e, stackTrace);
    }
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    try {
      await _dioClient.delete(ApiRoutes.userById(id));
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw UnknownException('Failed to delete user', e, e.stackTrace);
    } catch (e, stackTrace) {
      throw UnknownException('Failed to delete user', e, stackTrace);
    }
  }

  /// Get list of users
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20}) async {
    try {
      final response = await _dioClient.get(
        ApiRoutes.getUsers,
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw UnknownException('Failed to get users', e, e.stackTrace);
    } catch (e, stackTrace) {
      throw UnknownException('Failed to get users', e, stackTrace);
    }
  }
}
