import '../../domain/entities/network_test_entity.dart';

/// Model for network test result - maps to/from entity
class NetworkTestModel extends NetworkTestEntity {
  const NetworkTestModel({
    required super.name,
    required super.method,
    required super.success,
    required super.duration,
    required super.message,
    super.data,
  });

  /// Convert entity to model
  factory NetworkTestModel.fromEntity(NetworkTestEntity entity) {
    return NetworkTestModel(
      name: entity.name,
      method: entity.method,
      success: entity.success,
      duration: entity.duration,
      message: entity.message,
      data: entity.data,
    );
  }

  /// Convert model to entity
  NetworkTestEntity toEntity() {
    return NetworkTestEntity(
      name: name,
      method: method,
      success: success,
      duration: duration,
      message: message,
      data: data,
    );
  }
}
