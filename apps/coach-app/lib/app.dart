import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/auth/auth_notifier.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';

// TODO: Wire to real API — true when coach profile is incomplete after sign-up
final _needsOnboardingProvider = StateProvider<bool>((ref) => false);

class CoachApp extends ConsumerWidget {
  const CoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final needsOnboarding = ref.watch(_needsOnboardingProvider);

    Widget home = switch (auth.status) {
      AuthStatus.unauthenticated => const LoginScreen(),
      AuthStatus.authenticated when needsOnboarding => OnboardingScreen(
          onComplete: () =>
              ref.read(_needsOnboardingProvider.notifier).state = false,
        ),
      AuthStatus.authenticated => const HomeScreen(),
      AuthStatus.unknown => const Scaffold(
          backgroundColor: kBackground,
          body: Center(
            child: CircularProgressIndicator(color: kTeal),
          ),
        ),
    };

    return MaterialApp(
      title: 'CricCoach',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: home,
    );
  }
}
