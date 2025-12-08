/// Design token: Border radius values for the application
/// Following Material 3 shape system
class AppRadius {
  AppRadius._();

  // None
  static const double none = 0;

  // Small radius values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 28.0;

  // Named radius for specific components
  static const double button = md; // 12px
  static const double buttonSmall = sm; // 8px
  static const double buttonLarge = lg; // 16px

  static const double card = md; // 12px
  static const double cardSmall = sm; // 8px
  static const double cardLarge = lg; // 16px

  static const double input = sm; // 8px
  static const double inputLarge = md; // 12px

  static const double dialog = xl; // 20px
  static const double dialogLarge = xxl; // 24px

  static const double bottomSheet = xl; // 20px
  static const double bottomSheetLarge = xxl; // 24px

  static const double chip = lg; // 16px
  static const double chipSmall = md; // 12px

  static const double badge = sm; // 8px
  static const double badgeLarge = md; // 12px

  static const double avatar = lg; // 16px - for square avatars
  static const double avatarCircle = 999.0; // Circular

  static const double image = md; // 12px
  static const double imageLarge = lg; // 16px

  static const double container = md; // 12px
  static const double containerSmall = sm; // 8px
  static const double containerLarge = lg; // 16px

  static const double snackbar = sm; // 8px
  static const double tooltip = xs; // 4px

  static const double divider = none; // 0px - straight line

  // Material 3 specific shapes
  static const double extraSmall = xs; // 4px
  static const double small = sm; // 8px
  static const double medium = md; // 12px
  static const double large = lg; // 16px
  static const double extraLarge = xl; // 20px
  static const double extraExtraLarge = xxl; // 24px
  static const double full = 999.0; // Fully rounded

  // Custom shapes
  static const double pillShape = 999.0; // Pill/Stadium shape
  static const double squircle = lg; // 16px - iOS-like rounded square
}
