import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

/// Splash screen page with app initialization logic
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup fade animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Trigger app initialization
    context.read<SplashBloc>().add(const InitializeAppEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          debugPrint('🚀 Splash - State changed: ${state.runtimeType}');

          if (state is SplashAuthenticated) {
            debugPrint('✅ Splash - User authenticated');
            debugPrint(
              '   hasCompletedOnboarding: ${state.appInit.hasCompletedOnboarding}',
            );

            // Check if onboarding is completed
            if (!state.appInit.hasCompletedOnboarding) {
              // Navigate to onboarding
              debugPrint('➡️  Splash - Navigating to Onboarding (first time)');
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  AppRoutes.navigateToOnboarding(context);
                }
              });
            } else {
              // Navigate to home
              debugPrint('➡️  Splash - Navigating to Home');
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  AppRoutes.navigateToHome(context);
                }
              });
            }
          } else if (state is SplashUnauthenticated) {
            debugPrint('❌ Splash - User not authenticated');
            debugPrint(
              '   hasCompletedOnboarding: ${state.appInit.hasCompletedOnboarding}',
            );

            // Check if onboarding is completed
            if (!state.appInit.hasCompletedOnboarding) {
              // Navigate to onboarding
              debugPrint('➡️  Splash - Navigating to Onboarding (first time)');
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  AppRoutes.navigateToOnboarding(context);
                }
              });
            } else {
              // Navigate to login
              debugPrint('➡️  Splash - Navigating to Login');
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  AppRoutes.navigateToLogin(context);
                }
              });
            }
          } else if (state is SplashError) {
            debugPrint('❌ Splash - Error: ${state.message}');
            // Show error and navigate to onboarding/login
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                AppRoutes.navigateToOnboarding(context);
              }
            });
          }
        },
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            return Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon/Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.network_check,
                        size: 60,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Name
                    const Text(
                      'Dio Network Config',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    const Text(
                      'Clean Architecture Demo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading Indicator
                    if (state is SplashLoading)
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 3,
                        ),
                      ),

                    // Error state
                    if (state is SplashError)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 48),

                    // Version
                    const Text(
                      'v1.0.0',
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
