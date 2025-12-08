import 'package:equatable/equatable.dart';

/// Domain layer user entity
/// Pure business logic, no dependencies on external frameworks
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, avatar, createdAt];

  @override
  String toString() =>
      'UserEntity(id: $id, name: $name, email: $email, avatar: $avatar)';
}
