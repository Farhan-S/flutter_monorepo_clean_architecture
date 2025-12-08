import 'package:equatable/equatable.dart';

/// Base class for onboarding events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load onboarding pages
class LoadOnboardingPagesEvent extends OnboardingEvent {
  const LoadOnboardingPagesEvent();
}

/// Event to go to next page
class NextPageEvent extends OnboardingEvent {
  const NextPageEvent();
}

/// Event to go to previous page
class PreviousPageEvent extends OnboardingEvent {
  const PreviousPageEvent();
}

/// Event to skip onboarding
class SkipOnboardingEvent extends OnboardingEvent {
  const SkipOnboardingEvent();
}

/// Event to complete onboarding
class CompleteOnboardingEvent extends OnboardingEvent {
  const CompleteOnboardingEvent();
}

/// Event to change page by index
class PageChangedEvent extends OnboardingEvent {
  final int pageIndex;

  const PageChangedEvent(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
