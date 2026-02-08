# Enterprise Flutter Template

**Stack**: Flutter + Dio network layer + Clean Architecture + BLoC + Melos monorepo

This document contains a full, production-ready template to build an enterprise-level Flutter app focusing on a robust network layer (Dio) and BLoC state management, organized with Clean Architecture. It includes folder layouts, `melos` workspace config, `pubspec` skeletons, and complete core network code (Dio client, interceptors, token refresh queue, retry/backoff, error mapping), DTOs, example data/repository/usecase, presentation layer with BLoC examples, and CLI/automation notes for future generator work.

---

## Goals

- Reusable single Dio client across packages
- Centralized API routes
- Token auth + refresh with request queueing
- Error mapping to domain exceptions
- Retry with exponential backoff
- Multipart uploads with progress
- File download with pause/resume (concept)
- Offline/Connectivity awareness (hook points)
- Clean Architecture boundaries (core, data, domain, presentation)
- BLoC example wired to repository/usecase
- Monorepo structure with `melos` for multiple packages

---

## Monorepo Layout (Melos)

```
my_enterprise_app/
├── melos.yaml
├── README.md
├── packages/
│   ├── app (flutter app)
│   ├── core (shared utilities: network, models, exceptions)
│   ├── data (implementation of datasources & repositories)
│   ├── domain (entities, repositories, usecases)
│   └── features_auth (feature package containing auth BLoC, pages)
└── scripts/
    └── generate_service.dart (future CLI helper)
```

### melos.yaml (root)

```yaml
name: my_enterprise_app
packages:
  - packages/*

environment:
  sdk: '>=2.19.0 <4.0.0'

# Example scripts
scripts:
  bootstrap:
    run: melos bootstrap
  analyze:
    run: melos analyze
  format:
    run: melos format
```

---

## Package responsibilities

- `core` — network layer, api routes, entities used across packages, common exceptions, storage interface
- `domain` — domain entities, repository interfaces, usecases
- `data` — datasource implementations using DioClient, model -> entity mappers, repository implementations
- `features_auth` — presentation (BLoC, pages), feature-specific models
- `app` — integration, main `MaterialApp`, dependency injection, router, root BLoC observers

---

# Core: Network Layer (packages/core/lib/core/network)

Files included:
- network_config.dart
- api_routes.dart
- api_response.dart
- network_exceptions.dart
- dio_client.dart
- interceptors/
  - auth_interceptor.dart
  - refresh_token_interceptor.dart
  - retry_interceptor.dart
  - error_interceptor.dart
  - logging_interceptor.dart
- utils/multipart_helper.dart
- storage/token_storage.dart (interface)


---

## `network_config.dart`

```dart
// packages/core/lib/core/network/network_config.dart
class NetworkConfig {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.example.com');
  static const int connectTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 20;
  static const bool enableLogging = bool.fromEnvironment('ENABLE_HTTP_LOG', defaultValue: true);
}
```

## `api_routes.dart`

```dart
// packages/core/lib/core/network/api_routes.dart
class ApiRoutes {
  static const String v1 = '/api/v1';
  static const String login = '$v1/auth/login';
  static const String refreshToken = '$v1/auth/refresh';
  static const String getUser = '$v1/user';
  static String userById(String id) => '$v1/user/$id';
  static const String uploadFile = '$v1/files/upload';
}
```

## `api_response.dart`

```dart
// packages/core/lib/core/network/api_response.dart
class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({this.data, this.message, this.statusCode});
}

abstract class Result<T> {}

class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

class Failure<T> extends Result<T> {
  final ApiException error;
  Failure(this.error);
}
```

## `network_exceptions.dart`

```dart
// packages/core/lib/core/network/network_exceptions.dart
class ApiException implements Exception {
  final String message;
  final int? code;
  ApiException(this.message, [this.code]);
  @override
  String toString() => 'ApiException($code): $message';
}

class NetworkException extends ApiException { NetworkException(String m): super(m); }
class ServerException extends ApiException { ServerException(String m, [int? code]): super(m, code); }
class UnauthorizedException extends ApiException { UnauthorizedException(String m): super(m); }
class NotFoundException extends ApiException { NotFoundException(String m): super(m); }
class ValidationException extends ApiException { ValidationException(String m, [Map<String,dynamic>? errors]): super(m); }
class RequestTimeoutException extends ApiException { RequestTimeoutException(String m): super(m); }
class UnknownException extends ApiException { UnknownException(String m): super(m); }
```

## `storage/token_storage.dart` (interface)

```dart
// packages/core/lib/core/network/storage/token_storage.dart
abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<void> clear();
}
```

> Implementations for this interface should live in `app` or `data` package (e.g., using `flutter_secure_storage`).


## `dio_client.dart`

Large file — single instance, helpers and typed methods.

```dart
// packages/core/lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'network_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    final options = BaseOptions(
      baseUrl: NetworkConfig.baseUrl,
      connectTimeout: Duration(seconds: NetworkConfig.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: NetworkConfig.receiveTimeoutSeconds),
      headers: {'Content-Type': 'application/json'},
    );

    dio = Dio(options);

    // Interceptors order
    if (NetworkConfig.enableLogging) dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.addAll([
      AuthInterceptor(),
      RefreshTokenInterceptor(dio),
      RetryInterceptor(dio),
      ErrorInterceptor(),
    ]);
  }

  // GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return dio.get(path, queryParameters: queryParameters, cancelToken: cancelToken, options: options);
  }

  // POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
  }) {
    return dio.post(path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return dio.put(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken, options: options);
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return dio.patch(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken, options: options);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return dio.delete(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken, options: options);
  }

  Future<Response> download(
    String urlPath,
    savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.download(urlPath, savePath,
        onReceiveProgress: onReceiveProgress, cancelToken: cancelToken, queryParameters: queryParameters, options: options);
  }
}
```


---

## Interceptors

### `logging_interceptor.dart`

```dart
// packages/core/lib/core/network/interceptors/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      // Use debugPrint or logger as you prefer
      debugPrint('--> ${options.method} ${options.uri}');
      debugPrint('Headers: ${options.headers}');
      debugPrint('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('Response: ${response.data}');
    }
    handler.next(response);
  }
}
```


### `auth_interceptor.dart`

```dart
// packages/core/lib/core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  // Note: do not instantiate storage here directly in core if you want DI.
  // Provide an implementation globally at app startup by assigning a global accessor.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _globalTokenStorage?.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}
    handler.next(options);
  }
}

// Global token storage accessor (set by app bootstrap)
TokenStorage? _globalTokenStorage;
void setGlobalTokenStorage(TokenStorage storage) => _globalTokenStorage = storage;
```

> The pattern above allows the `app` package to provide the secure storage implementation at runtime via `setGlobalTokenStorage()` called during bootstrap.


### `refresh_token_interceptor.dart`

```dart
// packages/core/lib/core/network/interceptors/refresh_token_interceptor.dart
import 'dart:async';
import 'package:dio/dio.dart';
import '../api_routes.dart';
import '../network_exceptions.dart';

class QueuedRequest {
  final RequestOptions request;
  final Completer<Response> completer;
  QueuedRequest(this.request, this.completer);
}

class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  final List<QueuedRequest> _queue = [];

  RefreshTokenInterceptor(this._dio);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    if (status == 401) {
      // if already refreshing queue this request
      if (_isRefreshing) {
        final completer = Completer<Response>();
        _queue.add(QueuedRequest(requestOptions, completer));
        try {
          final resp = await completer.future;
          return handler.resolve(resp);
        } catch (e) {
          return handler.next(err);
        }
      }

      _isRefreshing = true;
      try {
        final refreshToken = await _globalTokenStorage?.getRefreshToken();
        if (refreshToken == null) throw UnauthorizedException('No refresh token');

        // Create a new Dio instance without interceptors to call refresh
        final refreshDio = Dio(BaseOptions(baseUrl: NetworkConfig.baseUrl));
        final response = await refreshDio.post(ApiRoutes.refreshToken, data: {'refresh_token': refreshToken});

        final newAccess = response.data['access_token'] as String?;
        final newRefresh = response.data['refresh_token'] as String?;

        if (newAccess == null) throw UnauthorizedException('Refresh failed');

        await _globalTokenStorage?.saveAccessToken(newAccess);
        if (newRefresh != null) await _globalTokenStorage?.saveRefreshToken(newRefresh);

        _isRefreshing = false;

        // retry original request with new token
        final opts = Options(method: requestOptions.method, headers: requestOptions.headers);
        final r = await _dio.request(requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: opts);
        handler.resolve(r);

        // flush queue
        for (final item in _queue) {
          try {
            final resp = await _dio.request(item.request.path,
                data: item.request.data,
                queryParameters: item.request.queryParameters,
                options: Options(method: item.request.method));
            item.completer.complete(resp);
          } catch (e) {
            item.completer.completeError(e);
          }
        }
        _queue.clear();
      } catch (e) {
        _isRefreshing = false;
        for (final item in _queue) {
          item.completer.completeError(UnauthorizedException('Session expired'));
        }
        _queue.clear();
        // bubble up original error so app can handle logout
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
```

> **Note**: This uses `_globalTokenStorage` which app must set. The refresh call here uses a fresh Dio instance to avoid recursion with the interceptors.


### `retry_interceptor.dart` (exponential backoff)

```dart
// packages/core/lib/core/network/interceptors/retry_interceptor.dart
import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor(this.dio, {this.maxRetries = 3, this.baseDelay = const Duration(milliseconds: 500)});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final retries = request.extra['retries'] as int? ?? 0;

    if (_shouldRetry(err) && retries < maxRetries) {
      final nextRetries = retries + 1;
      final jitter = Random().nextInt(100);
      final waitMs = (baseDelay.inMilliseconds * pow(2, nextRetries)).toInt() + jitter;

      await Future.delayed(Duration(milliseconds: waitMs));

      final options = Options(method: request.method, headers: request.headers);
      request.extra['retries'] = nextRetries;

      try {
        final response = await dio.request(request.path,
            data: request.data,
            queryParameters: request.queryParameters,
            options: options,
            cancelToken: request.cancelToken);
        handler.resolve(response);
        return;
      } catch (e) {
        // fallthrough to original error if retry fails
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioError e) {
    return e.type == DioErrorType.connectionTimeout ||
        e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.sendTimeout ||
        e.type == DioErrorType.unknown;
  }
}
```


### `error_interceptor.dart` (map Dio errors to ApiException)

```dart
// packages/core/lib/core/network/interceptors/error_interceptor.dart
import 'package:dio/dio.dart';
import '../network_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    ApiException apiException;

    if (err.type == DioErrorType.connectionTimeout || err.type == DioErrorType.receiveTimeout) {
      apiException = RequestTimeoutException('Request timed out');
    } else if (err.type == DioErrorType.badResponse) {
      final status = err.response?.statusCode ?? 0;
      final msg = _parseMessage(err.response);
      switch (status) {
        case 400:
          apiException = ValidationException(msg);
          break;
        case 401:
          apiException = UnauthorizedException(msg);
          break;
        case 404:
          apiException = NotFoundException(msg);
          break;
        case 500:
        default:
          apiException = ServerException(msg, status);
      }
    } else if (err.type == DioErrorType.cancel) {
      apiException = NetworkException('Request canceled');
    } else {
      apiException = UnknownException(err.message ?? 'Unknown error');
    }

    // attach the ApiException to the DioError.error so higher layers can read it
    final dioErr = DioError(requestOptions: err.requestOptions, error: apiException, response: err.response, type: err.type);
    handler.next(dioErr);
  }

  String _parseMessage(Response? response) {
    try {
      final data = response?.data;
      if (data is Map && data['message'] != null) return data['message'].toString();
      if (data is String) return data;
    } catch (_) {}
    return 'Something went wrong';
  }
}
```


---

## Multipart helper

```dart
// packages/core/lib/core/network/utils/multipart_helper.dart
import 'dart:io';
import 'package:dio/dio.dart';

Future<FormData> buildMultipartFormData(Map<String, dynamic>? fields, List<File>? files, {String fileField = 'files'}) async {
  final fd = FormData();
  if (fields != null) {
    fields.forEach((k, v) => fd.fields.add(MapEntry(k, v.toString())));
  }
  if (files != null) {
    for (final f in files) {
      final fileName = f.path.split(Platform.pathSeparator).last;
      fd.files.add(MapEntry(fileField, await MultipartFile.fromFile(f.path, filename: fileName)));
    }
  }
  return fd;
}
```

---

# Data Layer (packages/data)

- `datasources/remote/auth_remote_datasource.dart`
- `models/auth_response_model.dart`
- `repositories/auth_repository_impl.dart`


## Example: `auth_remote_datasource.dart`

```dart
// packages/data/lib/data/datasources/remote/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:core/core/network/dio_client.dart';
import 'package:core/core/network/api_routes.dart';

import '../../models/auth_response_model.dart';

class AuthRemoteDataSource {
  final DioClient _client = DioClient();

  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final r = await _client.post(ApiRoutes.login, data: {'email': email, 'password': password});
      return AuthResponseModel.fromJson(r.data);
    } on DioError catch (e) {
      final err = e.error;
      if (err is ApiException) throw err;
      throw UnknownException('Login failed');
    }
  }

  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final r = await _client.post(ApiRoutes.refreshToken, data: {'refresh_token': refreshToken});
    return AuthResponseModel.fromJson(r.data);
  }
}
```


## `auth_response_model.dart`

```dart
// packages/data/lib/data/models/auth_response_model.dart
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;

  AuthResponseModel({required this.accessToken, required this.refreshToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}
```


## `auth_repository_impl.dart`

```dart
// packages/data/lib/data/repositories/auth_repository_impl.dart
import 'package:domain/domain/entities/user.dart';
import 'package:domain/domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../../models/auth_response_model.dart';
import 'package:core/core/network/network_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<Result<AuthResponseModel>> login(String email, String password) async {
    try {
      final res = await remote.login(email, password);
      return Success(res);
    } catch (e) {
      if (e is ApiException) return Failure(e);
      return Failure(UnknownException('Unknown error'));
    }
  }
}
```


---

# Domain Layer (packages/domain)

- Entities
- Repository interfaces
- Usecases

Example `auth_repository.dart` interface:

```dart
// packages/domain/lib/domain/repositories/auth_repository.dart
import 'package:core/core/network/api_response.dart';

abstract class AuthRepository {
  Future<Result<dynamic>> login(String email, String password);
}
```

Example usecase `login_usecase.dart`:

```dart
// packages/domain/lib/domain/usecases/login_usecase.dart
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Result<dynamic>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
```

---

# Presentation: BLoC Integration (packages/features_auth)

We will use `flutter_bloc` and `bloc` packages.

```
features_auth/
  lib/
    bloc/
      auth_bloc.dart
      auth_event.dart
      auth_state.dart
    pages/
      login_page.dart
    widgets/
      login_form.dart
```


## `auth_event.dart`

```dart
// packages/features_auth/lib/bloc/auth_event.dart
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}
```


## `auth_state.dart`

```dart
// packages/features_auth/lib/bloc/auth_state.dart
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String accessToken;
  AuthAuthenticated(this.accessToken);
}
class AuthUnauthenticated extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
```


## `auth_bloc.dart`

```dart
// packages/features_auth/lib/bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:domain/domain/usecases/login_usecase.dart';
import 'package:core/core/network/storage/token_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final TokenStorage tokenStorage; // DI provided

  AuthBloc({required this.loginUseCase, required this.tokenStorage}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await loginUseCase.call(event.email, event.password);
    if (res is Success) {
      // res.value is expected AuthResponseModel from data layer
      final tokens = res.value;
      await tokenStorage.saveAccessToken(tokens.accessToken);
      await tokenStorage.saveRefreshToken(tokens.refreshToken);
      emit(AuthAuthenticated(tokens.accessToken));
    } else if (res is Failure) {
      emit(AuthFailure(res.error.message));
    } else {
      emit(AuthFailure('Unknown error'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await tokenStorage.clear();
    emit(AuthUnauthenticated());
  }
}
```


---

# App wiring (packages/app)

- Provide DI (get_it) setup
- Provide `TokenStorage` implementation using `flutter_secure_storage`
- Set the global token storage in core: `setGlobalTokenStorage(myTokenStorage)`
- Initialize `DioClient()` and ensure environment variables set via `--dart-define` or build flavors
- Provide `BlocProvider` for `AuthBloc`


## Example `main.dart` (bootstrap)

```dart
// packages/app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:core/core/network/storage/token_storage.dart';
import 'package:core/core/network/dio_client.dart';
import 'package:core/core/network/interceptors/auth_interceptor.dart';

import 'package:features_auth/bloc/auth_bloc.dart';
import 'package:domain/domain/usecases/login_usecase.dart';
import 'package:data/data/datasources/remote/auth_remote_datasource.dart';
import 'package:data/data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup secure storage implementation
  final secureStorage = FlutterSecureStorage();
  final tokenStorageImpl = FlutterSecureTokenStorage(secureStorage);
  setGlobalTokenStorage(tokenStorageImpl); // from core.auth_interceptor

  // Setup DI
  final getIt = GetIt.instance;
  getIt.registerSingleton<TokenStorage>(tokenStorageImpl);

  // Data layer
  getIt.registerFactory(() => AuthRemoteDataSource());
  getIt.registerFactory(() => AuthRepositoryImpl(getIt()));

  // Domain
  getIt.registerFactory(() => LoginUseCase(getIt()));

  // Presentation
  runApp(MyApp(getIt: getIt));
}

class MyApp extends StatelessWidget {
  final GetIt getIt;
  const MyApp({required this.getIt});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enterprise App',
      home: /* Provide BlocProvider and start app */ Container(),
    );
  }
}

// Example implementation of TokenStorage using flutter_secure_storage
class FlutterSecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage storage;
  FlutterSecureTokenStorage(this.storage);
  @override
  Future<String?> getAccessToken() => storage.read(key: 'access_token');
  @override
  Future<String?> getRefreshToken() => storage.read(key: 'refresh_token');
  @override
  Future<void> saveAccessToken(String token) => storage.write(key: 'access_token', value: token);
  @override
  Future<void> saveRefreshToken(String refreshToken) => storage.write(key: 'refresh_token', value: refreshToken);
  @override
  Future<void> clear() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
  }
}
```


---

# Example CLI & Generator notes (future)

- Use `melos` scripts + a small dart script to scaffold feature modules, api service classes and DTOs.
- CLI features:
  - `create:feature auth` -> create feature package skeleton with bloc, pages, routes
  - `generate:service posts --endpoints endpoints.json` -> generate service class, models

Design the generator to read a YAML/JSON API contract (OpenAPI recommended) to generate accurate clients.

---

# Testing

- Use `dio_http_mock_adapter` to mock network responses in data layer tests.
- Test interceptors by injecting a `Dio` instance and asserting behavior.
- BLoC unit tests should mock usecases and token storage with `mockito` or `mocktail`.

---

# Tips & Best Practices

1. **Keep core independent**: `core` package should have no dependency on `app` or `features`. Provide runtime wiring like tokenStorage via setter.
2. **Avoid side-effects in constructors**: create factories for classes that depend on dio or storage.
3. **Idempotency**: Ensure server endpoints that may be retried are idempotent or guarded server-side.
4. **Logging**: keep sensitive data out of logs in production. Use `--dart-define` to toggle logging.
5. **CI/CD**: Use `melos` to run tests, analyze and format across packages.
6. **OpenAPI**: For large APIs, consider generating models/services from OpenAPI.

---

# What I can generate for you now (I will produce code files inside this repo structure):

- Full `packages/core/lib/core/network/*` (all files shown above)
- Example `packages/data` small implementation for auth (remote datasource, model, repo impl)
- `packages/domain` interfaces and login usecase
- `packages/features_auth` bloc + simple login page
- `packages/app` main bootstrap wiring and token storage implementation
- `melos.yaml` and top-level README

If you want me to generate these files now, say **"Generate core + data + domain + features_auth + app"** and I will create the full file contents ready to paste into your monorepo. Alternatively, tell me which package to start with (core by default).

---

*End of document.*

