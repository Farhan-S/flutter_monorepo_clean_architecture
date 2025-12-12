import 'package:flutter/material.dart';

/// Design token: Color palette for the application
/// Following Material 3 color system
class AppColors {
  AppColors._();

  // Primary colors - Minimalistic Black/Gray
  static const Color primaryLight = Color(0xFF000000); // Pure Black
  static const Color primaryDark = Color(0xFFFFFFFF); // Pure White
  static const Color primaryContainerLight = Color(0xFFF5F5F5); // Light Gray
  static const Color primaryContainerDark = Color(0xFF2A2A2A); // Dark Gray

  // Secondary colors - Subtle Gray
  static const Color secondaryLight = Color(0xFF424242); // Medium Gray
  static const Color secondaryDark = Color(0xFFE0E0E0); // Light Gray
  static const Color secondaryContainerLight = Color(
    0xFFFAFAFA,
  ); // Very Light Gray
  static const Color secondaryContainerDark = Color(
    0xFF1C1C1C,
  ); // Very Dark Gray

  // Tertiary colors - Accent Gray
  static const Color tertiaryLight = Color(0xFF616161); // Dark Gray
  static const Color tertiaryDark = Color(0xFFBDBDBD); // Light Gray
  static const Color tertiaryContainerLight = Color(
    0xFFEEEEEE,
  ); // Very Light Gray
  static const Color tertiaryContainerDark = Color(0xFF303030); // Dark Gray

  // Error colors - Minimalistic Red
  static const Color errorLight = Color(0xFFE53935); // Minimal Red
  static const Color errorDark = Color(0xFFEF5350); // Soft Red
  static const Color errorContainerLight = Color(0xFFFFEBEE); // Very Light Red
  static const Color errorContainerDark = Color(0xFF3A1818); // Very Dark Red

  // Success colors - Minimalistic Green
  static const Color successLight = Color(0xFF43A047); // Minimal Green
  static const Color successDark = Color(0xFF66BB6A); // Soft Green
  static const Color successContainerLight = Color(
    0xFFE8F5E9,
  ); // Very Light Green
  static const Color successContainerDark = Color(
    0xFF1B3A1F,
  ); // Very Dark Green

  // Warning colors - Minimalistic Amber
  static const Color warningLight = Color(0xFFFFA726); // Minimal Amber
  static const Color warningDark = Color(0xFFFFB74D); // Soft Amber
  static const Color warningContainerLight = Color(
    0xFFFFF8E1,
  ); // Very Light Amber
  static const Color warningContainerDark = Color(
    0xFF3A2F1B,
  ); // Very Dark Amber

  // Info colors - Minimalistic Gray Blue
  static const Color infoLight = Color(0xFF546E7A); // Minimal Gray Blue
  static const Color infoDark = Color(0xFF78909C); // Soft Gray Blue
  static const Color infoContainerLight = Color(
    0xFFECEFF1,
  ); // Very Light Gray Blue
  static const Color infoContainerDark = Color(
    0xFF1C2326,
  ); // Very Dark Gray Blue

  // Surface colors - Pure Minimalistic
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceDark = Color(0xFF0F0F0F); // Almost Black
  static const Color surfaceVariantLight = Color(0xFFFAFAFA); // Very Light Gray
  static const Color surfaceVariantDark = Color(0xFF1A1A1A); // Very Dark Gray

  // Background colors - Pure Minimalistic
  static const Color backgroundLight = Color(0xFFFAFAFA); // Very Light Gray
  static const Color backgroundDark = Color(0xFF000000); // Pure Black

  // On colors (text on colored backgrounds)
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF000000);
  static const Color onBackgroundLight = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF000000);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);

  // Outline colors - Subtle Minimalistic
  static const Color outlineLight = Color(0xFFE0E0E0); // Light Gray Border
  static const Color outlineDark = Color(0xFF404040); // Dark Gray Border
  static const Color outlineVariantLight = Color(
    0xFFF0F0F0,
  ); // Very Light Gray Border
  static const Color outlineVariantDark = Color(
    0xFF2A2A2A,
  ); // Very Dark Gray Border

  // Shadow colors
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowDark = Color(0x3F000000);

  // Scrim colors
  static const Color scrimLight = Color(0x99000000);
  static const Color scrimDark = Color(0xBB000000);

  // Inverse colors - Pure Minimalistic
  static const Color inverseSurfaceLight = Color(0xFF000000);
  static const Color inverseSurfaceDark = Color(0xFFFFFFFF);
  static const Color inversePrimaryLight = Color(0xFFFFFFFF);
  static const Color inversePrimaryDark = Color(0xFF000000);

  // Neutral colors
  static const Color neutral0 = Color(0xFF000000);
  static const Color neutral10 = Color(0xFF1A1A1A);
  static const Color neutral20 = Color(0xFF333333);
  static const Color neutral30 = Color(0xFF4D4D4D);
  static const Color neutral40 = Color(0xFF666666);
  static const Color neutral50 = Color(0xFF808080);
  static const Color neutral60 = Color(0xFF999999);
  static const Color neutral70 = Color(0xFFB3B3B3);
  static const Color neutral80 = Color(0xFFCCCCCC);
  static const Color neutral90 = Color(0xFFE6E6E6);
  static const Color neutral95 = Color(0xFFF2F2F2);
  static const Color neutral99 = Color(0xFFFCFCFC);
  static const Color neutral100 = Color(0xFFFFFFFF);

  // Authentication specific colors
  static const Color authButtonLight = primaryLight;
  static const Color authButtonDark = primaryDark;
  static const Color authBackgroundLight = backgroundLight;
  static const Color authBackgroundDark = backgroundDark;

  // Card colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
}
