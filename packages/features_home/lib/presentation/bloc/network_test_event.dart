import 'package:equatable/equatable.dart';

/// Events for NetworkTestBloc
abstract class NetworkTestEvent extends Equatable {
  const NetworkTestEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start running all network tests
class RunAllNetworkTestsEvent extends NetworkTestEvent {
  const RunAllNetworkTestsEvent();
}

/// Event to clear test results
class ClearNetworkTestsEvent extends NetworkTestEvent {
  const ClearNetworkTestsEvent();
}

/// Event to run a specific test
class RunSpecificNetworkTestEvent extends NetworkTestEvent {
  final String testName;

  const RunSpecificNetworkTestEvent(this.testName);

  @override
  List<Object?> get props => [testName];
}
