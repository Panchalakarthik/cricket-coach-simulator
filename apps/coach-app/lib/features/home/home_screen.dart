import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_notifier.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/live_match_hero.dart';
import 'widgets/season_journey_card.dart';
import 'widgets/leaderboard_card.dart';

// TODO: Replace with real providers loading from API
final _mockHasActiveMatch = true;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _CoachHeader(
              onNotification: () {},
              onLogout: () => ref.read(authProvider.notifier).logout(),
            ),
            Expanded(
              child: _mockHasActiveMatch
                  ? const _ActiveMatchView()
                  : const _NoMatchView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _CoachNav(),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────

class _CoachHeader extends StatelessWidget {
  final VoidCallback onNotification, onLogout;

  const _CoachHeader({
    required this.onNotification,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: kSurfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kTeal.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Text(
                  'KP',
                  style: TextStyle(
                    color: kTeal, fontWeight: FontWeight.w800, fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coach Karthik',
                  style: TextStyle(
                    color: kTextPrimary, fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: kTealDim,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        'Balanced Leader',
                        style: TextStyle(
                          color: kTeal, fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '· CPL 2025',
                      style: TextStyle(color: kTextSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: onNotification,
                  icon: const Icon(Icons.notifications_outlined,
                      color: kTextSecondary, size: 22),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: kLive, shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: kTextMuted, size: 18),
              tooltip: 'Logout',
            ),
          ],
        ),
      );
}

// ── Active match view ───────────────────────────────────────────────────────

class _ActiveMatchView extends StatelessWidget {
  const _ActiveMatchView();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // Live match hero — takes over the top of the screen
          LiveMatchHero(
            matchId: 'match-20260621T053803246748749',
            homeTeam: 'Antigua Falcons',
            awayTeam: 'Barbados Royals',
            venue: 'Brian Lara Stadium, Tarouba',
            league: 'Caribbean Premier League',
            score: 0,
            wickets: 0,
            overs: 0.0,
            winPct: 50.0,
            pressure: 'Manageable',
            momentum: 50,
            rivalName: 'Mira Holdfast',
            rivalPersona: 'Defensive Controller',
            rivalInsight:
                'Holdfast expects you to rush — hold your plan through the powerplay.',
            onContinue: () {
              // TODO: Navigate to match route
            },
          ),
          const SizedBox(height: 12),

          // XP progress + daily missions
          SeasonJourneyCard(
            level: 3,
            tierLabel: 'Silver',
            xp: 240,
            xpForNext: 350,
            missions: const [
              DailyMissionData(
                title: 'Coach one match',
                current: 1,
                target: 1,
                xpReward: 50,
                completed: true,
              ),
              DailyMissionData(
                title: 'Make 3 coach calls',
                current: 3,
                target: 3,
                xpReward: 30,
                completed: true,
              ),
              DailyMissionData(
                title: 'Win a match',
                current: 0,
                target: 1,
                xpReward: 100,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Leaderboard snapshot with rival context
          LeaderboardCard(
            eloRating: 1194,
            eloMove: -6,
            streak: -1,
            form: 0,
            rankPosition: 2,
            nearestRival: 'Ahmed Hassan',
            rivalDelta: 12,
            pulseHistory: const [
              1200, 1198, 1205, 1196, 1202, 1194,
            ],
          ),
        ],
      );
}

// ── No active match view ────────────────────────────────────────────────────

class _NoMatchView extends StatelessWidget {
  const _NoMatchView();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _NextFixtureCard(),
          const SizedBox(height: 12),
          SeasonJourneyCard(
            level: 3,
            tierLabel: 'Silver',
            xp: 240,
            xpForNext: 350,
            missions: const [
              DailyMissionData(
                title: 'Coach one match',
                current: 0,
                target: 1,
                xpReward: 50,
              ),
              DailyMissionData(
                title: 'Make 3 coach calls',
                current: 0,
                target: 3,
                xpReward: 30,
              ),
              DailyMissionData(
                title: 'Win a match',
                current: 0,
                target: 1,
                xpReward: 100,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LeaderboardCard(
            eloRating: 1194,
            eloMove: -6,
            streak: -1,
            form: 0,
            rankPosition: 2,
            nearestRival: 'Ahmed Hassan',
            rivalDelta: 12,
            pulseHistory: const [1200, 1198, 1205, 1196, 1202, 1194],
          ),
        ],
      );
}

class _NextFixtureCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  const Text(
                    'NEXT FIXTURE',
                    style: TextStyle(
                      color: kTextMuted, fontSize: 10,
                      fontWeight: FontWeight.w700, letterSpacing: 0.8,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: kSurfaceElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'IN 2 DAYS',
                      style: TextStyle(
                        color: kTextSecondary, fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Antigua Falcons vs TKR',
                    style: TextStyle(
                      color: kTextPrimary, fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Queen\'s Park Oval · CPL 2025',
                    style: TextStyle(color: kTextSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kTeal,
                        side: const BorderSide(color: kTeal),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.access_time_rounded, size: 16),
                      label: const Text('Prepare Pre-Match Strategy'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

// ── Bottom nav ──────────────────────────────────────────────────────────────

class _CoachNav extends StatelessWidget {
  const _CoachNav();

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: kSurface,
          border: Border(top: BorderSide(color: kBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _NavItem(icon: Icons.home_rounded, label: 'Hub', active: true),
                _NavItem(icon: Icons.sports_cricket, label: 'Play'),
                _NavItem(icon: Icons.emoji_events_outlined, label: 'League'),
                _NavItem(icon: Icons.person_outline_rounded, label: 'Coach'),
              ],
            ),
          ),
        ),
      );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? kTeal : kTextMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: active ? kTeal : kTextMuted,
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      );
}
