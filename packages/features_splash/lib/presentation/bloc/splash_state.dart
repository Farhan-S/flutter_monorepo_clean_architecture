import 'package:equatable/equatable.dart';

import '../../domain/entities/app_init_entity.dart';

/// Base class for splash states
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Loading state during initialization
class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Initialization completed successfully
class SplashInitialized extends SplashState {
  final AppInitEntity appInit;

  const SplashInitialized(this.appInit);

  @override
  List<Object?> get props => [appInit];
}

/// User is authenticated - navigate to home
class SplashAuthenticated extends SplashState {
  final AppInitEntity appInit;

  const SplashAuthenticated(this.appInit);

  @override
  List<Object?> get props => [appInit];
}

/// User is not authenticated - navigate to login
class SplashUnauthenticated extends SplashState {
  final AppInitEntity appInit;

  const SplashUnauthenticated(this.appInit);

  @override
  List<Object?> get props => [appInit];
}

/// Error during initialization
class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
