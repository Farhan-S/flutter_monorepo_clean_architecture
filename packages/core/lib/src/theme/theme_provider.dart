import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Theme Cubit for managing app theme mode
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Current theme mode
  ThemeMode get themeMode => state;

  /// Is dark mode enabled
  bool get isDarkMode => state == ThemeMode.dark;

  /// Is light mode enabled
  bool get isLightMode => state == ThemeMode.light;

  /// Is system mode enabled
  bool get isSystemMode => state == ThemeMode.system;

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    emit(mode);
  }

  /// Toggle between light and dark
  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {
      // If system, switch to light
      emit(ThemeMode.light);
    }
  }

  /// Set to dark mode
  void setDarkMode() {
    emit(ThemeMode.dark);
  }

  /// Set to light mode
  void setLightMode() {
    emit(ThemeMode.light);
  }

  /// Set to system mode
  void setSystemMode() {
    emit(ThemeMode.system);
  }
}

