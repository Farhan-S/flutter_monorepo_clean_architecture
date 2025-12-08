import 'package:get_it/get_it.dart';

import 'package:core/core.dart';
import 'package:features_auth/features_auth.dart';
import 'package:features_user/features_user.dart';

final getIt = GetIt.instance;

/// Setup dependency injection for the entire app
/// Call this once before runApp()
Future<void> setupDependencyInjection() async {
  // ==================== Core Layer ====================

  // Token Storage - Singleton
  getIt.registerLazySingleton<TokenStorage>(() => SecureTokenStorage());

  // DioClient - Singleton
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // ==================== Data Layer ====================

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(getIt<DioClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<TokenStorage>(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserRemoteDataSource>()),
  );

  // ==================== Domain Layer ====================

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetUserByIdUseCase>(
    () => GetUserByIdUseCase(getIt<UserRepository>()),
  );

  // ==================== Presentation Layer ====================

  // BLoC - Factory (new instance each time)
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );
}
