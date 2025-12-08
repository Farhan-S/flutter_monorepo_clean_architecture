import 'package:features_auth/features_auth.dart';
import 'package:flutter/material.dart';

class AuthStatusCard extends StatelessWidget {
  final AuthState state;

  const AuthStatusCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    String status;
    Color color;
    IconData icon;

    if (state is AuthAuthenticated) {
      final authState = state as AuthAuthenticated;
      status = '✅ Authenticated as ${authState.user.name}';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (state is AuthLoading) {
      status = '⏳ Loading...';
      color = Colors.orange;
      icon = Icons.hourglass_empty;
    } else if (state is AuthError) {
      final errorState = state as AuthError;
      status = '❌ Error: ${errorState.message}';
      color = Colors.red;
      icon = Icons.error;
    } else {
      status = '🔓 Not Authenticated';
      color = Colors.grey;
      icon = Icons.lock_open;
    }

    return Card(
      color: color.withAlpha(25),
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
}
