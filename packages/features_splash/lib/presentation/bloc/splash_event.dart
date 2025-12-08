import 'package:equatable/equatable.dart';

/// Base class for splash events
abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start app initialization
class InitializeAppEvent extends SplashEvent {
  const InitializeAppEvent();
}

/// Event to check authentication status
class CheckAuthStatusEvent extends SplashEvent {
  const CheckAuthStatusEvent();
}
