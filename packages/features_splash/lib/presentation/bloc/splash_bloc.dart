import 'package:features_splash/domain/entities/app_init_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/initialize_app_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// BLoC for splash screen logic
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final InitializeAppUseCase initializeAppUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  SplashBloc({
    required this.initializeAppUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const SplashInitial()) {
    on<InitializeAppEvent>(_onInitializeApp);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  /// Handle app initialization
  Future<void> _onInitializeApp(
    InitializeAppEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());

    final result = await initializeAppUseCase();

    result.fold(
      (failure) {
        emit(SplashError(failure.message));
      },
      (appInit) {
        if (appInit.isAuthenticated) {
          emit(SplashAuthenticated(appInit));
        } else {
          emit(SplashUnauthenticated(appInit));
        }
      },
    );
  }

  /// Handle auth status check
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());

    final result = await checkAuthStatusUseCase();

    result.fold(
      (failure) {
        emit(SplashError(failure.message));
      },
      (isAuthenticated) {
        if (isAuthenticated) {
          emit(
            const SplashAuthenticated(
              AppInitEntity(
                isInitialized: true,
                isAuthenticated: true,
                hasCompletedOnboarding: false,
              ),
            ),
          );
        } else {
          emit(
            const SplashUnauthenticated(
              AppInitEntity(
                isInitialized: true,
                isAuthenticated: false,
                hasCompletedOnboarding: false,
              ),
            ),
          );
        }
      },
    );
  }
}
