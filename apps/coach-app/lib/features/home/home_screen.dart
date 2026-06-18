import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_cricket, size: 64),
            SizedBox(height: 16),
            Text(
              'Play Match, Challenges, and Scenarios',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Coming in subsequent plans.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
