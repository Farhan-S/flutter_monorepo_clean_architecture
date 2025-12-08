import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              '• features_auth - Auth feature with BLoC\n'
              '• features_user - User feature (data layer)\n'
              '• features_home - Home & network testing UI\n'
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
