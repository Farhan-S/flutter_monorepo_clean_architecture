import 'package:flutter/material.dart';

import '../tokens/colors.dart';

/// Theme extension for custom colors
/// Access via: Theme.of(context).extension`<AppColorsExtension>`()
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color onSuccessContainer;

  final Color warning;
  final Color warningContainer;
  final Color onWarning;
  final Color onWarningContainer;

  final Color info;
  final Color infoContainer;
  final Color onInfo;
  final Color onInfoContainer;

  final Color neutral;
  final Color neutralVariant;

  final Color cardBackground;
  final Color dialogBackground;
  final Color bottomSheetBackground;

  final Color divider;
  final Color border;

  const AppColorsExtension({
    required this.success,
    required this.successContainer,
    required this.onSuccess,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarning,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfo,
    required this.onInfoContainer,
    required this.neutral,
    required this.neutralVariant,
    required this.cardBackground,
    required this.dialogBackground,
    required this.bottomSheetBackground,
    required this.divider,
    required this.border,
  });

  /// Light theme colors
  static AppColorsExtension light() {
    return const AppColorsExtension(
      success: AppColors.successLight,
      successContainer: AppColors.successContainerLight,
      onSuccess: AppColors.onPrimaryLight,
      onSuccessContainer: AppColors.onBackgroundLight,
      warning: AppColors.warningLight,
      warningContainer: AppColors.warningContainerLight,
      onWarning: AppColors.onPrimaryLight,
      onWarningContainer: AppColors.onBackgroundLight,
      info: AppColors.infoLight,
      infoContainer: AppColors.infoContainerLight,
      onInfo: AppColors.onPrimaryLight,
      onInfoContainer: AppColors.onBackgroundLight,
      neutral: AppColors.neutral50,
      neutralVariant: AppColors.neutral90,
      cardBackground: AppColors.cardLight,
      dialogBackground: AppColors.surfaceLight,
      bottomSheetBackground: AppColors.surfaceLight,
      divider: AppColors.outlineVariantLight,
      border: AppColors.outlineLight,
    );
  }

  /// Dark theme colors
  static AppColorsExtension dark() {
    return const AppColorsExtension(
      success: AppColors.successDark,
      successContainer: AppColors.successContainerDark,
      onSuccess: AppColors.onPrimaryDark,
      onSuccessContainer: AppColors.onBackgroundDark,
      warning: AppColors.warningDark,
      warningContainer: AppColors.warningContainerDark,
      onWarning: AppColors.onPrimaryDark,
      onWarningContainer: AppColors.onBackgroundDark,
      info: AppColors.infoDark,
      infoContainer: AppColors.infoContainerDark,
      onInfo: AppColors.onPrimaryDark,
      onInfoContainer: AppColors.onBackgroundDark,
      neutral: AppColors.neutral50,
      neutralVariant: AppColors.neutral20,
      cardBackground: AppColors.cardDark,
      dialogBackground: AppColors.surfaceDark,
      bottomSheetBackground: AppColors.surfaceDark,
      divider: AppColors.outlineVariantDark,
      border: AppColors.outlineDark,
    );
  }

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccess,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarning,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfo,
    Color? onInfoContainer,
    Color? neutral,
    Color? neutralVariant,
    Color? cardBackground,
    Color? dialogBackground,
    Color? bottomSheetBackground,
    Color? divider,
    Color? border,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccess: onSuccess ?? this.onSuccess,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarning: onWarning ?? this.onWarning,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfo: onInfo ?? this.onInfo,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      neutral: neutral ?? this.neutral,
      neutralVariant: neutralVariant ?? this.neutralVariant,
      cardBackground: cardBackground ?? this.cardBackground,
      dialogBackground: dialogBackground ?? this.dialogBackground,
      bottomSheetBackground:
          bottomSheetBackground ?? this.bottomSheetBackground,
      divider: divider ?? this.divider,
      border: border ?? this.border,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;

    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      neutralVariant: Color.lerp(neutralVariant, other.neutralVariant, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      dialogBackground: Color.lerp(
        dialogBackground,
        other.dialogBackground,
        t,
      )!,
      bottomSheetBackground: Color.lerp(
        bottomSheetBackground,
        other.bottomSheetBackground,
        t,
      )!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}
