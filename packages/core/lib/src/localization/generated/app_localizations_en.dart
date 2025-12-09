// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Clean Architecture App';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get authenticated => 'Authenticated';

  @override
  String get notAuthenticated => 'Not Authenticated';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Welcome to Clean Architecture';

  @override
  String get onboardingDesc1 =>
      'Build scalable and maintainable Flutter apps with proper architecture patterns and separation of concerns.';

  @override
  String get onboardingTitle2 => 'Modular Package Structure';

  @override
  String get onboardingDesc2 =>
      'Each feature is isolated in its own package with domain, data, and presentation layers using Melos.';

  @override
  String get onboardingTitle3 => 'BLoC State Management';

  @override
  String get onboardingDesc3 =>
      'Manage your app state reactively with BLoC pattern, ensuring predictable and testable code.';

  @override
  String get onboardingTitle4 => 'Robust Network Layer';

  @override
  String get onboardingDesc4 =>
      'Built-in error handling, retry logic, token refresh, and interceptors for seamless API communication.';
}
