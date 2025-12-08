import 'package:flutter/material.dart';
import '../tokens/spacing.dart';

/// Theme extension for spacing
/// Access via: Theme.of(context).extension<AppSpacingExtension>()
@immutable
class AppSpacingExtension extends ThemeExtension<AppSpacingExtension> {
  final double pageHorizontal;
  final double pageVertical;
  final double sectionSpacing;
  final double cardPadding;
  final double listItemPadding;
  final double buttonPadding;
  final double inputPadding;
  final double dialogPadding;

  const AppSpacingExtension({
    required this.pageHorizontal,
    required this.pageVertical,
    required this.sectionSpacing,
    required this.cardPadding,
    required this.listItemPadding,
    required this.buttonPadding,
    required this.inputPadding,
    required this.dialogPadding,
  });

  /// Default spacing values
  static AppSpacingExtension standard() {
    return const AppSpacingExtension(
      pageHorizontal: AppSpacing.pageHorizontal,
      pageVertical: AppSpacing.pageVertical,
      sectionSpacing: AppSpacing.sectionSpacing,
      cardPadding: AppSpacing.cardPadding,
      listItemPadding: AppSpacing.listItemPadding,
      buttonPadding: AppSpacing.buttonPadding,
      inputPadding: AppSpacing.inputPadding,
      dialogPadding: AppSpacing.dialogPadding,
    );
  }

  @override
  AppSpacingExtension copyWith({
    double? pageHorizontal,
    double? pageVertical,
    double? sectionSpacing,
    double? cardPadding,
    double? listItemPadding,
    double? buttonPadding,
    double? inputPadding,
    double? dialogPadding,
  }) {
    return AppSpacingExtension(
      pageHorizontal: pageHorizontal ?? this.pageHorizontal,
      pageVertical: pageVertical ?? this.pageVertical,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      cardPadding: cardPadding ?? this.cardPadding,
      listItemPadding: listItemPadding ?? this.listItemPadding,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      inputPadding: inputPadding ?? this.inputPadding,
      dialogPadding: dialogPadding ?? this.dialogPadding,
    );
  }

  @override
  AppSpacingExtension lerp(AppSpacingExtension? other, double t) {
    if (other is! AppSpacingExtension) return this;

    return AppSpacingExtension(
      pageHorizontal: lerpDouble(pageHorizontal, other.pageHorizontal, t) ?? pageHorizontal,
      pageVertical: lerpDouble(pageVertical, other.pageVertical, t) ?? pageVertical,
      sectionSpacing: lerpDouble(sectionSpacing, other.sectionSpacing, t) ?? sectionSpacing,
      cardPadding: lerpDouble(cardPadding, other.cardPadding, t) ?? cardPadding,
      listItemPadding: lerpDouble(listItemPadding, other.listItemPadding, t) ?? listItemPadding,
      buttonPadding: lerpDouble(buttonPadding, other.buttonPadding, t) ?? buttonPadding,
      inputPadding: lerpDouble(inputPadding, other.inputPadding, t) ?? inputPadding,
      dialogPadding: lerpDouble(dialogPadding, other.dialogPadding, t) ?? dialogPadding,
    );
  }

  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
