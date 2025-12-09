import 'package:core/core.dart';
import 'package:features_auth/features_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart';
import 'routes/app_route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencyInjection();

  // Register all feature routes
  AppRouteGenerator.registerAllRoutes();

  // Initialize network layer
  _initializeNetworkLayer();

  runApp(const MyApp());
}

/// Initialize network layer with token refresh interceptor
void _initializeNetworkLayer() {
  final dioClient = getIt<DioClient>();

  // Configure token refresh interceptor
  dioClient.addRefreshTokenInterceptor(
    onRefresh: (refreshToken) async {
      debugPrint('🔄 Refreshing token...');

      // Get token storage
      final tokenStorage = getIt<TokenStorage>();

      // Create a temporary Dio instance to avoid interceptor recursion
      final refreshDio = DioClient().dio;

      try {
        final response = await refreshDio.post(
          ApiRoutes.refreshToken,
          data: {'refresh_token': refreshToken},
        );

        final newAccessToken = response.data['access_token'] as String;
        final newRefreshToken = response.data['refresh_token'] as String?;

        // Save new tokens
        await tokenStorage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await tokenStorage.saveRefreshToken(newRefreshToken);
        }

        debugPrint('✅ Token refreshed successfully');

        return {
          'accessToken': newAccessToken,
          'refreshToken': newRefreshToken ?? refreshToken,
        };
      } catch (e) {
        debugPrint('❌ Token refresh failed: $e');
        rethrow;
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Clean Architecture App',
            debugShowCheckedModeBanner: false,
            theme: AppLightTheme.theme,
            darkTheme: AppDarkTheme.theme,
            themeMode: themeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouteGenerator.onGenerateRoute,
          );
        },
      ),
    );
  }
}
