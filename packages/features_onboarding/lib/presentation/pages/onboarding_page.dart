import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_content.dart';

/// Onboarding screen with multiple pages
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Load onboarding pages
    context.read<OnboardingBloc>().add(const LoadOnboardingPagesEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingCompleted || state is OnboardingSkipped) {
              // Navigate directly to login after onboarding is completed
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted && context.mounted) {
                  AppRoutes.navigateToLogin(context);
                }
              });
            } else if (state is OnboardingLoaded) {
              // Animate to current page
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  state.currentPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
          },
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is OnboardingError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 56,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(
                            const LoadOnboardingPagesEvent(),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is OnboardingLoaded) {
                return Column(
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(
                            const SkipOnboardingEvent(),
                          );
                        },
                        child: const Text('Skip'),
                      ),
                    ),

                    // PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: state.pages.length,
                        onPageChanged: (index) {
                          context.read<OnboardingBloc>().add(
                            PageChangedEvent(index),
                          );
                        },
                        itemBuilder: (context, index) {
                          return OnboardingContent(page: state.pages[index]);
                        },
                      ),
                    ),

                    // Page Indicators
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          state.pages.length,
                          (index) => _buildPageIndicator(
                            isActive: index == state.currentPage,
                            context: context,
                          ),
                        ),
                      ),
                    ),

                    // Navigation buttons
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous/Back button
                          if (!state.isFirstPage)
                            TextButton.icon(
                              onPressed: () {
                                context.read<OnboardingBloc>().add(
                                  const PreviousPageEvent(),
                                );
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Back'),
                            )
                          else
                            const SizedBox(width: 80),

                          // Next/Get Started button
                          ElevatedButton(
                            onPressed: () {
                              context.read<OnboardingBloc>().add(
                                const NextPageEvent(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(state.isLastPage ? 'Get Started' : 'Next'),
                                const SizedBox(width: 8),
                                Icon(
                                  state.isLastPage
                                      ? Icons.check
                                      : Icons.arrow_forward,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator({
    required bool isActive,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 20.0 : 6.0,
      height: 6.0,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
