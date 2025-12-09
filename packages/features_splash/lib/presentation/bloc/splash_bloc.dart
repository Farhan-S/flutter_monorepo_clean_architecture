import 'package:flutter/material.dart';
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
        debugPrint('❌ Splash - Initialization failed: ${failure.message}');
        emit(SplashError(failure.message));
      },
      (appInit) {
        debugPrint('✅ Splash - Initialized: ${appInit.toString()}');
        debugPrint('   isAuthenticated: ${appInit.isAuthenticated}');
        debugPrint(
          '   hasCompletedOnboarding: ${appInit.hasCompletedOnboarding}',
        );

        if (appInit.isAuthenticated) {
          debugPrint('➡️  Splash - Emitting SplashAuthenticated');
          emit(SplashAuthenticated(appInit));
        } else {
          debugPrint('➡️  Splash - Emitting SplashUnauthenticated');
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

    // Get app initialization data which includes onboarding status
    final initResult = await initializeAppUseCase();

    initResult.fold(
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
}
