import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tokens/colors.dart';
import 'tokens/typography.dart';
import 'tokens/radius.dart';
import 'theme_extensions/app_colors.dart';
import 'theme_extensions/app_spacing.dart';
import 'theme_extensions/app_typography.dart';
import 'theme_extensions/app_radius.dart';

/// Light theme configuration
class AppLightTheme {
  static ThemeData get theme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.onPrimaryLight,
      primaryContainer: AppColors.primaryContainerLight,
      onPrimaryContainer: AppColors.onBackgroundLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.onSecondaryLight,
      secondaryContainer: AppColors.secondaryContainerLight,
      onSecondaryContainer: AppColors.onBackgroundLight,
      tertiary: AppColors.tertiaryLight,
      onTertiary: AppColors.onPrimaryLight,
      tertiaryContainer: AppColors.tertiaryContainerLight,
      onTertiaryContainer: AppColors.onBackgroundLight,
      error: AppColors.errorLight,
      onError: AppColors.onErrorLight,
      errorContainer: AppColors.errorContainerLight,
      onErrorContainer: AppColors.onBackgroundLight,
      background: AppColors.backgroundLight,
      onBackground: AppColors.onBackgroundLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      surfaceVariant: AppColors.surfaceVariantLight,
      onSurfaceVariant: AppColors.onSurfaceLight,
      outline: AppColors.outlineLight,
      outlineVariant: AppColors.outlineVariantLight,
      shadow: AppColors.shadowLight,
      scrim: AppColors.scrimLight,
      inverseSurface: AppColors.inverseSurfaceLight,
      onInverseSurface: AppColors.onBackgroundDark,
      inversePrimary: AppColors.inversePrimaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      textTheme: AppTypography.createTextTheme(),
      
      // Extensions
      extensions: [
        AppColorsExtension.light(),
        AppSpacingExtension.standard(),
        AppTypographyExtension.standard(),
        AppRadiusExtension.standard(),
      ],

      // AppBar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        color: AppColors.cardLight,
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppTypography.button,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        errorStyle: AppTypography.error.copyWith(
          color: colorScheme.error,
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: AppTypography.labelSmall,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
        elevation: 8,
        backgroundColor: colorScheme.surface,
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
        elevation: 8,
        backgroundColor: colorScheme.surface,
        clipBehavior: Clip.antiAlias,
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.snackbar),
        ),
        backgroundColor: AppColors.neutral20,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral100,
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: 40,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.container),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceVariant;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // Navigation bar theme
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: MaterialStateProperty.all(AppTypography.labelSmall),
      ),

      // Tab bar theme
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: AppTypography.titleSmall,
        unselectedLabelStyle: AppTypography.titleSmall,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      // Tooltip theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.neutral20,
          borderRadius: BorderRadius.circular(AppRadius.tooltip),
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.neutral100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        circularTrackColor: colorScheme.surfaceVariant,
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceVariant,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.12),
      ),
    );
  }
}
