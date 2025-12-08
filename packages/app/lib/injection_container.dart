import 'package:core/core.dart';
import 'package:features_auth/features_auth.dart';
import 'package:features_home/features_home.dart';
import 'package:features_user/features_user.dart';
import 'package:get_it/get_it.dart';

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

  // ==================== Features Home ====================

  // Network Test Data Source
  getIt.registerLazySingleton<NetworkTestDataSource>(
    () => NetworkTestDataSource(getIt<DioClient>()),
  );

  // Network Test Repository
  getIt.registerLazySingleton<NetworkTestRepository>(
    () => NetworkTestRepositoryImpl(getIt<NetworkTestDataSource>()),
  );

  // Network Test Use Case
  getIt.registerLazySingleton<RunNetworkTestsUseCase>(
    () => RunNetworkTestsUseCase(getIt<NetworkTestRepository>()),
  );

  // ==================== Presentation Layer ====================

  // Auth BLoC - Factory (new instance each time)
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );

  // Network Test BLoC - Factory
  getIt.registerFactory<NetworkTestBloc>(
    () => NetworkTestBloc(
      runNetworkTestsUseCase: getIt<RunNetworkTestsUseCase>(),
    ),
  );
}
