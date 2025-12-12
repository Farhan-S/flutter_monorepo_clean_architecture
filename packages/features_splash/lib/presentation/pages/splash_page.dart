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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                if (mounted && context.mounted) {
                  AppRoutes.navigateToOnboarding(context);
                }
              });
            } else {
              // Navigate to home
              debugPrint('➡️  Splash - Navigating to Home');
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted && context.mounted) {
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
                if (mounted && context.mounted) {
                  AppRoutes.navigateToOnboarding(context);
                }
              });
            } else {
              // Navigate to login
              debugPrint('➡️  Splash - Navigating to Login');
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted && context.mounted) {
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
              if (mounted && context.mounted) {
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
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.circle_outlined,
                        size: 50,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Name
                    Text(
                      'Clean Architecture',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      'Minimalistic Design',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading Indicator
                    if (state is SplashLoading)
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                          strokeWidth: 2,
                        ),
                      ),

                    // Error state
                    if (state is SplashError)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.error,
                              size: 40,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 48),

                    // Version
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                      ),
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
