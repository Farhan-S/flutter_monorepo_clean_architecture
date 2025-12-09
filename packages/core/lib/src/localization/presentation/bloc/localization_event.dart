import 'package:equatable/equatable.dart';

import '../../domain/entities/app_locale.dart';

/// Base class for localization events
abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load saved locale
class LoadSavedLocaleEvent extends LocalizationEvent {
  const LoadSavedLocaleEvent();
}

/// Event to change locale
class ChangeLocaleEvent extends LocalizationEvent {
  final AppLocale locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

/// Event to reset to system locale
class ResetToSystemLocaleEvent extends LocalizationEvent {
  const ResetToSystemLocaleEvent();
}
