import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SeasonJourneyCard extends StatelessWidget {
  final int level;
  final String tierLabel;
  final int xp, xpForNext;
  final List<DailyMissionData> missions;

  const SeasonJourneyCard({
    super.key,
    required this.level,
    required this.tierLabel,
    required this.xp,
    required this.xpForNext,
    required this.missions,
  });

  double get _xpFraction => (xp / xpForNext).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildXPBar(),
          const Divider(color: kBorder, height: 1),
          _buildMissionsHeader(),
          _buildMissions(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kTeal, Color(0xFF818CF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'L$level',
                  style: const TextStyle(
                    color: kBackground, fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tierLabel,
                  style: const TextStyle(
                    color: kTextPrimary, fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Level $level Coach',
                  style: const TextStyle(color: kTextSecondary, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '$xp / $xpForNext XP',
              style: const TextStyle(
                color: kTeal, fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _buildXPBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _xpFraction,
                backgroundColor: kBorder,
                valueColor: const AlwaysStoppedAnimation<Color>(kTeal),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${xpForNext - xp} XP to Level ${level + 1}',
              style: const TextStyle(color: kTextMuted, fontSize: 10),
            ),
          ],
        ),
      );

  Widget _buildMissionsHeader() => const Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            Text(
              'TODAY\'S MISSIONS',
              style: TextStyle(
                color: kTextMuted, fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 0.8,
              ),
            ),
            Spacer(),
            Text(
              'RESETS IN 8H',
              style: TextStyle(
                color: kTextMuted, fontSize: 10, letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );

  Widget _buildMissions() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Column(
          children: missions
              .map((m) => _MissionRow(mission: m))
              .toList(),
        ),
      );
}

class _MissionRow extends StatelessWidget {
  final DailyMissionData mission;

  const _MissionRow({required this.mission});

  @override
  Widget build(BuildContext context) {
    final fraction = (mission.current / mission.target).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mission.completed ? kTeal : kBorder,
              border: mission.completed
                  ? null
                  : Border.all(color: kTextMuted, width: 1.5),
            ),
            child: mission.completed
                ? const Icon(Icons.check_rounded, color: kBackground, size: 13)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: TextStyle(
                    color: mission.completed
                        ? kTextSecondary
                        : kTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    decoration: mission.completed
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: kTextMuted,
                  ),
                ),
                if (!mission.completed) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: fraction,
                            backgroundColor: kBorder,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(kTeal),
                            minHeight: 3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${mission.current}/${mission.target}',
                        style: const TextStyle(
                          color: kTextMuted, fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!mission.completed)
            Text(
              '+${mission.xpReward} XP',
              style: const TextStyle(
                color: kTeal, fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class DailyMissionData {
  final String title;
  final int current, target, xpReward;
  final bool completed;

  const DailyMissionData({
    required this.title,
    required this.current,
    required this.target,
    required this.xpReward,
    this.completed = false,
  });
}
