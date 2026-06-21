import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LiveMatchHero extends StatelessWidget {
  final String matchId;
  final String homeTeam, awayTeam, venue, league;
  final int score, wickets;
  final double overs;
  final double winPct;
  final String pressure;
  final int momentum;
  final String rivalName, rivalPersona, rivalInsight;
  final VoidCallback onContinue;

  const LiveMatchHero({
    super.key,
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    required this.venue,
    required this.league,
    required this.score,
    required this.wickets,
    required this.overs,
    required this.winPct,
    required this.pressure,
    required this.momentum,
    required this.rivalName,
    required this.rivalPersona,
    required this.rivalInsight,
    required this.onContinue,
  });

  Color get _pressureColor => switch (pressure) {
        'Critical' => kPressureHigh,
        'High' => kPressureMid,
        _ => kPressureLow,
      };

  String get _pressureEmoji => switch (pressure) {
        'Critical' => '🔴',
        'High' => '🟡',
        _ => '🟢',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLive.withOpacity(0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(color: kBorder, height: 1),
          _buildScoreRow(),
          const Divider(color: kBorder, height: 1),
          _buildMetricsRow(),
          const Divider(color: kBorder, height: 1),
          _buildRivalInsight(),
          _buildContinueCTA(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: kLiveDim,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      color: kLive, shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'LIVE DECISION WAITING',
                    style: TextStyle(
                      color: kLive, fontSize: 10,
                      fontWeight: FontWeight.w700, letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              league,
              style: const TextStyle(color: kTextSecondary, fontSize: 11),
            ),
          ],
        ),
      );

  Widget _buildScoreRow() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$homeTeam vs $awayTeam',
                    style: const TextStyle(
                      color: kTextPrimary, fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    venue,
                    style: const TextStyle(color: kTextSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$score/$wickets',
                  style: const TextStyle(
                    color: kTeal, fontSize: 22,
                    fontWeight: FontWeight.w800, letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '${overs.toStringAsFixed(1)} ov',
                  style: const TextStyle(color: kTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildMetricsRow() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _MetricChip(
              label: 'WIN',
              value: '${winPct.round()}%',
              color: winPct > 50 ? kTeal : kTextSecondary,
            ),
            const SizedBox(width: 8),
            _MetricChip(
              label: 'PRESSURE',
              value: '$_pressureEmoji $pressure',
              color: _pressureColor,
            ),
            const SizedBox(width: 8),
            _MetricChip(
              label: 'MOMENTUM',
              value: momentum.toString(),
              color: kMomentumColor,
            ),
          ],
        ),
      );

  Widget _buildRivalInsight() => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: kGoldDim,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kGold.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rival: $rivalName ($rivalPersona)',
                    style: const TextStyle(
                      color: kGold, fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rivalInsight,
                    style: const TextStyle(
                      color: kTextPrimary, fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildContinueCTA() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              backgroundColor: kTeal,
              foregroundColor: const Color(0xFF0A0E17),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text(
              'CONTINUE MATCH — Your next call can swing it',
              style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      );
}

class _MetricChip extends StatelessWidget {
  final String label, value;
  final Color color;

  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: kTextMuted, fontSize: 9,
                  fontWeight: FontWeight.w600, letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: color, fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}
