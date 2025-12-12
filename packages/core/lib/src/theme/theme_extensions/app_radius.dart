import 'package:flutter/material.dart';

import '../tokens/radius.dart';

/// Theme extension for border radius
/// Access via: Theme.of(context).extension`<AppRadiusExtension>`()
@immutable
class AppRadiusExtension extends ThemeExtension<AppRadiusExtension> {
  final double button;
  final double card;
  final double input;
  final double dialog;
  final double bottomSheet;
  final double chip;
  final double container;

  const AppRadiusExtension({
    required this.button,
    required this.card,
    required this.input,
    required this.dialog,
    required this.bottomSheet,
    required this.chip,
    required this.container,
  });

  /// Default radius values
  static AppRadiusExtension standard() {
    return const AppRadiusExtension(
      button: AppRadius.button,
      card: AppRadius.card,
      input: AppRadius.input,
      dialog: AppRadius.dialog,
      bottomSheet: AppRadius.bottomSheet,
      chip: AppRadius.chip,
      container: AppRadius.container,
    );
  }

  @override
  AppRadiusExtension copyWith({
    double? button,
    double? card,
    double? input,
    double? dialog,
    double? bottomSheet,
    double? chip,
    double? container,
  }) {
    return AppRadiusExtension(
      button: button ?? this.button,
      card: card ?? this.card,
      input: input ?? this.input,
      dialog: dialog ?? this.dialog,
      bottomSheet: bottomSheet ?? this.bottomSheet,
      chip: chip ?? this.chip,
      container: container ?? this.container,
    );
  }

  @override
  AppRadiusExtension lerp(AppRadiusExtension? other, double t) {
    if (other is! AppRadiusExtension) return this;

    return AppRadiusExtension(
      button: lerpDouble(button, other.button, t) ?? button,
      card: lerpDouble(card, other.card, t) ?? card,
      input: lerpDouble(input, other.input, t) ?? input,
      dialog: lerpDouble(dialog, other.dialog, t) ?? dialog,
      bottomSheet: lerpDouble(bottomSheet, other.bottomSheet, t) ?? bottomSheet,
      chip: lerpDouble(chip, other.chip, t) ?? chip,
      container: lerpDouble(container, other.container, t) ?? container,
    );
  }

  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
