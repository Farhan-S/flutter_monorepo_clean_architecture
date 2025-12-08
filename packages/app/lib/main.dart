import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core.dart';
import 'package:features_auth/features_auth.dart';

import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencyInjection();

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
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp(
        title: 'Clean Architecture App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Info
                  const Icon(Icons.architecture, size: 100, color: Colors.blue),
                  const SizedBox(height: 24),

                  const Text(
                    'Clean Architecture',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'with Melos Monorepo',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 48),

                  // Auth Status
                  _buildStatusCard(state),

                  const SizedBox(height: 24),

                  // Login Button
                  if (state is! AuthAuthenticated)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AuthBloc>(),
                              child: const LoginPage(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Login with BLoC'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),

                  // Logout Button
                  if (state is AuthAuthenticated)
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          const AuthLogoutRequested(),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),

                  const SizedBox(height: 48),

                  // Info Card
                  _buildInfoCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(AuthState state) {
    String status;
    Color color;
    IconData icon;

    if (state is AuthAuthenticated) {
      status = '✅ Authenticated as ${state.user.name}';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (state is AuthLoading) {
      status = '⏳ Loading...';
      color = Colors.orange;
      icon = Icons.hourglass_empty;
    } else if (state is AuthError) {
      status = '❌ Error: ${state.message}';
      color = Colors.red;
      icon = Icons.error;
    } else {
      status = '🔓 Not Authenticated';
      color = Colors.grey;
      icon = Icons.lock_open;
    }

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Melos Monorepo Structure',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '📦 Packages:\n'
              '• core - Network layer & infrastructure\n'
              '• domain - Business logic (entities, repos, usecases)\n'
              '• data - Implementation (models, datasources)\n'
              '• features_auth - Auth feature with BLoC\n'
              '• app - Main application\n\n'
              '✨ Features:\n'
              '• Clean Architecture\n'
              '• BLoC Pattern\n'
              '• Dependency Injection\n'
              '• Modular & Scalable',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
