/// Design token: Spacing values for the application
/// Following 8px grid system
class AppSpacing {
  AppSpacing._();

  // Base unit (8px)
  static const double base = 8.0;

  // Common spacing values
  static const double xxxs = base * 0.5; // 4px
  static const double xxs = base * 1; // 8px
  static const double xs = base * 1.5; // 12px
  static const double sm = base * 2; // 16px
  static const double md = base * 3; // 24px
  static const double lg = base * 4; // 32px
  static const double xl = base * 5; // 40px
  static const double xxl = base * 6; // 48px
  static const double xxxl = base * 8; // 64px

  // Named spacing for specific use cases
  static const double none = 0;
  static const double tiny = xxxs; // 4px
  static const double small = xxs; // 8px
  static const double medium = sm; // 16px
  static const double large = md; // 24px
  static const double extraLarge = lg; // 32px
  static const double huge = xl; // 40px
  static const double massive = xxl; // 48px
  static const double gigantic = xxxl; // 64px

  // Padding values
  static const double paddingXS = xs; // 12px
  static const double paddingSM = sm; // 16px
  static const double paddingMD = md; // 24px
  static const double paddingLG = lg; // 32px
  static const double paddingXL = xl; // 40px

  // Margin values
  static const double marginXS = xs; // 12px
  static const double marginSM = sm; // 16px
  static const double marginMD = md; // 24px
  static const double marginLG = lg; // 32px
  static const double marginXL = xl; // 40px

  // Page padding
  static const double pageHorizontal = sm; // 16px
  static const double pageVertical = md; // 24px

  // Card spacing
  static const double cardPadding = sm; // 16px
  static const double cardMargin = sm; // 16px
  static const double cardContentSpacing = xs; // 12px

  // List item spacing
  static const double listItemPadding = sm; // 16px
  static const double listItemSpacing = xxs; // 8px
  static const double listItemContentSpacing = xs; // 12px

  // Button spacing
  static const double buttonPadding = sm; // 16px
  static const double buttonPaddingVertical = xs; // 12px
  static const double buttonPaddingHorizontal = md; // 24px
  static const double buttonSpacing = xxs; // 8px

  // Input field spacing
  static const double inputPadding = sm; // 16px
  static const double inputPaddingVertical = xs; // 12px
  static const double inputPaddingHorizontal = sm; // 16px
  static const double inputSpacing = xs; // 12px

  // Icon spacing
  static const double iconSpacing = xxs; // 8px
  static const double iconPadding = xxs; // 8px

  // Divider spacing
  static const double dividerSpacing = sm; // 16px

  // Section spacing
  static const double sectionSpacing = md; // 24px
  static const double sectionPadding = sm; // 16px

  // Grid spacing
  static const double gridSpacing = sm; // 16px
  static const double gridItemSpacing = xxs; // 8px

  // Dialog spacing
  static const double dialogPadding = md; // 24px
  static const double dialogContentSpacing = sm; // 16px
  static const double dialogActionSpacing = xxs; // 8px

  // Bottom sheet spacing
  static const double bottomSheetPadding = sm; // 16px
  static const double bottomSheetHeaderSpacing = xs; // 12px

  // AppBar spacing
  static const double appBarHorizontal = sm; // 16px
  static const double appBarActionSpacing = xxs; // 8px

  // Tab spacing
  static const double tabPadding = sm; // 16px
  static const double tabSpacing = md; // 24px

  // Chip spacing
  static const double chipPadding = xs; // 12px
  static const double chipSpacing = xxs; // 8px

  // Avatar spacing
  static const double avatarSpacing = xxs; // 8px

  // Badge spacing
  static const double badgePadding = xxxs; // 4px

  // Snackbar spacing
  static const double snackbarPadding = sm; // 16px

  // Tooltip spacing
  static const double tooltipPadding = xxs; // 8px
}
