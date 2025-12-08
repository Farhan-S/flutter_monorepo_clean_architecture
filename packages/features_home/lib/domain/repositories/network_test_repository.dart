import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/network_test_entity.dart';

/// Repository interface for network testing operations
abstract class NetworkTestRepository {
  /// Run all network tests and return results
  Future<Either<ApiException, NetworkTestSuiteEntity>> runAllTests();

  /// Run a specific test by name
  Future<Either<ApiException, NetworkTestEntity>> runTest(String testName);
}
