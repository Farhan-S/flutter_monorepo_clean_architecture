import 'package:flutter/material.dart';

/// Centralized app routes for the entire application
/// All feature modules should register their routes here
class AppRoutes {
  // ==================== Route Names ====================

  // Splash & Onboarding Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Home Routes
  static const String home = '/';
  static const String networkTest = '/network-test';

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // User Routes
  static const String profile = '/profile';
  static const String settings = '/settings';

  // ==================== Route Parameters ====================

  /// Keys for route arguments
  static const String userIdParam = 'userId';
  static const String emailParam = 'email';

  // ==================== Navigation Helpers ====================

  /// Navigate to splash page
  static Future<void> navigateToSplash(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(context, splash, (route) => false);
  }

  /// Navigate to onboarding page
  static Future<void> navigateToOnboarding(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(context, onboarding, (route) => false);
  }

  /// Navigate to home page
  static Future<void> navigateToHome(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
  }

  /// Navigate to login page
  static Future<void> navigateToLogin(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
  }

  /// Navigate to network test page
  static Future<void> navigateToNetworkTest(BuildContext context) {
    return Navigator.pushNamed(context, networkTest);
  }

  /// Navigate to profile page
  static Future<void> navigateToProfile(
    BuildContext context, {
    String? userId,
  }) {
    return Navigator.pushNamed(
      context,
      profile,
      arguments: {userIdParam: userId},
    );
  }

  /// Navigate back
  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}

/// Route generator function signature
/// Each feature module should provide this
typedef RouteFactory = Route<dynamic>? Function(RouteSettings settings);

/// Registry for feature route handlers
class AppRouteRegistry {
  static final Map<String, RouteFactory> _routeFactories = {};

  /// Register a route handler for a specific route pattern
  static void registerRoute(String routeName, RouteFactory factory) {
    _routeFactories[routeName] = factory;
  }

  /// Register multiple routes at once
  static void registerRoutes(Map<String, RouteFactory> factories) {
    _routeFactories.addAll(factories);
  }

  /// Get route factory for a route name
  static RouteFactory? getRouteFactory(String routeName) {
    return _routeFactories[routeName];
  }

  /// Clear all registered routes (useful for testing)
  static void clear() {
    _routeFactories.clear();
  }

  /// Get all registered route names
  static List<String> getAllRouteNames() {
    return _routeFactories.keys.toList();
  }
}
