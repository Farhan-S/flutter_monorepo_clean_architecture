import 'package:core/core.dart';
import 'package:features_auth/features_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login page with BLoC pattern
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          debugPrint('🔐 LoginPage - State changed: ${state.runtimeType}');

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            debugPrint('🔐 LoginPage - User authenticated: ${state.user.name}');

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful!'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to home after successful login
            debugPrint('🔐 LoginPage - Navigating to home...');
            AppRoutes.navigateToHome(context);
          }
        },
        builder: (context, state) {
          debugPrint(
            '🔐 LoginPage - Building with state: ${state.runtimeType}',
          );

          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: LoginForm(),
          );
        },
      ),
    );
  }
}
