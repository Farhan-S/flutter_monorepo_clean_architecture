import 'package:flutter/material.dart';
import '../tokens/typography.dart';

/// Theme extension for typography
/// Access via: Theme.of(context).extension<AppTypographyExtension>()
@immutable
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final TextStyle button;
  final TextStyle caption;
  final TextStyle overline;
  final TextStyle error;
  final TextStyle helper;
  final TextStyle input;

  const AppTypographyExtension({
    required this.button,
    required this.caption,
    required this.overline,
    required this.error,
    required this.helper,
    required this.input,
  });

  /// Default typography styles
  static AppTypographyExtension standard() {
    return const AppTypographyExtension(
      button: AppTypography.button,
      caption: AppTypography.caption,
      overline: AppTypography.overline,
      error: AppTypography.error,
      helper: AppTypography.helper,
      input: AppTypography.input,
    );
  }

  @override
  AppTypographyExtension copyWith({
    TextStyle? button,
    TextStyle? caption,
    TextStyle? overline,
    TextStyle? error,
    TextStyle? helper,
    TextStyle? input,
  }) {
    return AppTypographyExtension(
      button: button ?? this.button,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
      error: error ?? this.error,
      helper: helper ?? this.helper,
      input: input ?? this.input,
    );
  }

  @override
  AppTypographyExtension lerp(AppTypographyExtension? other, double t) {
    if (other is! AppTypographyExtension) return this;

    return AppTypographyExtension(
      button: TextStyle.lerp(button, other.button, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
      error: TextStyle.lerp(error, other.error, t)!,
      helper: TextStyle.lerp(helper, other.helper, t)!,
      input: TextStyle.lerp(input, other.input, t)!,
    );
  }
}
