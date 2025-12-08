import 'package:equatable/equatable.dart';

/// Entity representing an onboarding page
class OnboardingPageEntity extends Equatable {
  final String title;
  final String description;
  final String image;
  final int index;

  const OnboardingPageEntity({
    required this.title,
    required this.description,
    required this.image,
    required this.index,
  });

  @override
  List<Object?> get props => [title, description, image, index];

  @override
  String toString() {
    return 'OnboardingPageEntity(title: $title, index: $index)';
  }
}
