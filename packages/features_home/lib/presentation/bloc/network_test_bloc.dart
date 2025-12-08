import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/run_network_tests_usecase.dart';
import 'network_test_event.dart';
import 'network_test_state.dart';

/// BLoC for managing network test execution
class NetworkTestBloc extends Bloc<NetworkTestEvent, NetworkTestState> {
  final RunNetworkTestsUseCase runNetworkTestsUseCase;

  NetworkTestBloc({required this.runNetworkTestsUseCase})
    : super(const NetworkTestInitial()) {
    on<RunAllNetworkTestsEvent>(_onRunAllNetworkTests);
    on<ClearNetworkTestsEvent>(_onClearNetworkTests);
  }

  Future<void> _onRunAllNetworkTests(
    RunAllNetworkTestsEvent event,
    Emitter<NetworkTestState> emit,
  ) async {
    // Emit running state
    emit(
      const NetworkTestRunning(
        currentResults: [],
        completedCount: 0,
        totalCount: 8,
      ),
    );

    // Execute use case
    final result = await runNetworkTestsUseCase();

    // Handle result
    result.fold(
      (failure) {
        emit(NetworkTestError(failure.message));
      },
      (testSuite) {
        emit(NetworkTestComplete(testSuite));
      },
    );
  }

  void _onClearNetworkTests(
    ClearNetworkTestsEvent event,
    Emitter<NetworkTestState> emit,
  ) {
    emit(const NetworkTestInitial());
  }
}
