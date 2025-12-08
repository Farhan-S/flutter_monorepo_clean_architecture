import 'package:equatable/equatable.dart';

/// Entity representing a single network test result
class NetworkTestEntity extends Equatable {
  final String name;
  final String method;
  final bool success;
  final int duration;
  final String message;
  final dynamic data;

  const NetworkTestEntity({
    required this.name,
    required this.method,
    required this.success,
    required this.duration,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [name, method, success, duration, message, data];
}

/// Entity representing the overall test suite results
class NetworkTestSuiteEntity extends Equatable {
  final List<NetworkTestEntity> results;
  final int totalTests;
  final int passedTests;
  final int failedTests;
  final bool isComplete;

  const NetworkTestSuiteEntity({
    required this.results,
    required this.totalTests,
    required this.passedTests,
    required this.failedTests,
    required this.isComplete,
  });

  const NetworkTestSuiteEntity.empty()
    : results = const [],
      totalTests = 0,
      passedTests = 0,
      failedTests = 0,
      isComplete = false;

  NetworkTestSuiteEntity copyWith({
    List<NetworkTestEntity>? results,
    int? totalTests,
    int? passedTests,
    int? failedTests,
    bool? isComplete,
  }) {
    return NetworkTestSuiteEntity(
      results: results ?? this.results,
      totalTests: totalTests ?? this.totalTests,
      passedTests: passedTests ?? this.passedTests,
      failedTests: failedTests ?? this.failedTests,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [
    results,
    totalTests,
    passedTests,
    failedTests,
    isComplete,
  ];
}
