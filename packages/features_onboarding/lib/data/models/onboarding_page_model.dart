import '../../domain/entities/onboarding_page_entity.dart';

/// Model for onboarding page (extends entity)
class OnboardingPageModel extends OnboardingPageEntity {
  const OnboardingPageModel({
    required super.title,
    required super.description,
    required super.image,
    required super.index,
  });

  /// Create model from entity
  factory OnboardingPageModel.fromEntity(OnboardingPageEntity entity) {
    return OnboardingPageModel(
      title: entity.title,
      description: entity.description,
      image: entity.image,
      index: entity.index,
    );
  }

  /// Create model from JSON
  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      index: json['index'] as int,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'index': index,
    };
  }

  /// Create a copy with updated values
  OnboardingPageModel copyWith({
    String? title,
    String? description,
    String? image,
    int? index,
  }) {
    return OnboardingPageModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      index: index ?? this.index,
    );
  }
}
