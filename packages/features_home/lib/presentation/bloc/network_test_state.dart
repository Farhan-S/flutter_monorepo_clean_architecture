import 'package:equatable/equatable.dart';

import '../../domain/entities/network_test_entity.dart';

/// States for NetworkTestBloc
abstract class NetworkTestState extends Equatable {
  const NetworkTestState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no tests run yet
class NetworkTestInitial extends NetworkTestState {
  const NetworkTestInitial();
}

/// Tests are currently running
class NetworkTestRunning extends NetworkTestState {
  final List<NetworkTestEntity> currentResults;
  final int completedCount;
  final int totalCount;

  const NetworkTestRunning({
    required this.currentResults,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [currentResults, completedCount, totalCount];
}

/// Tests completed successfully
class NetworkTestComplete extends NetworkTestState {
  final NetworkTestSuiteEntity testSuite;

  const NetworkTestComplete(this.testSuite);

  @override
  List<Object?> get props => [testSuite];
}

/// Test execution failed with error
class NetworkTestError extends NetworkTestState {
  final String message;

  const NetworkTestError(this.message);

  @override
  List<Object?> get props => [message];
}
