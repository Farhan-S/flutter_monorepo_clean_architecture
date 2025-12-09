import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_init_model.dart';

/// Data source for app initialization
class AppInitDataSource {
  final TokenStorage _tokenStorage;
  final SharedPreferences _sharedPreferences;

  AppInitDataSource(this._tokenStorage, this._sharedPreferences);

  /// Initialize app and check token validity
  Future<AppInitModel> initializeApp() async {
    try {
      // Simulate initialization delay (remove in production or make it shorter)
      await Future.delayed(const Duration(seconds: 2));

      // Check if user has tokens
      final accessToken = await _tokenStorage.getAccessToken();

      final bool isAuthenticated =
          accessToken != null && accessToken.isNotEmpty;

      // Check if onboarding has been completed
      final bool hasCompletedOnboarding =
          _sharedPreferences.getBool('onboarding_completed') ?? false;

      // You can add additional checks here:
      // - Validate token expiry
      // - Check token format
      // - Verify with backend (optional)

      return AppInitModel(
        isInitialized: true,
        isAuthenticated: isAuthenticated,
        hasCompletedOnboarding: hasCompletedOnboarding,
        userId: isAuthenticated ? 'user_id_from_token' : null,
        errorMessage: null,
      );
    } catch (e) {
      return const AppInitModel(
        isInitialized: false,
        isAuthenticated: false,
        hasCompletedOnboarding: false,
        userId: null,
        errorMessage: 'Failed to initialize app',
      );
    }
  }

  /// Check authentication status
  Future<bool> checkAuthStatus() async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Optional: Verify token with backend
  Future<bool> verifyTokenWithBackend(String token) async {
    // Implement backend token verification if needed
    // This would make an API call to validate the token
    return true;
  }

  /// Reset onboarding status (for testing/debugging)
  Future<bool> resetOnboardingStatus() async {
    return await _sharedPreferences.remove('onboarding_completed');
  }
}
