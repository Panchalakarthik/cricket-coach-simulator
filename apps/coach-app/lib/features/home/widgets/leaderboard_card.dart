import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

class LeaderboardCard extends StatelessWidget {
  final int eloRating, eloMove, streak, form;
  final int rankPosition;
  final String nearestRival;
  final int rivalDelta;
  final List<int> pulseHistory;

  const LeaderboardCard({
    super.key,
    required this.eloRating,
    required this.eloMove,
    required this.streak,
    required this.form,
    required this.rankPosition,
    required this.nearestRival,
    required this.rivalDelta,
    required this.pulseHistory,
  });

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
          _buildStatsRow(),
          _buildRivalContext(),
          if (pulseHistory.isNotEmpty) _buildPulseChart(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Row(
          children: [
            const Text(
              'YOUR STANDING',
              style: TextStyle(
                color: kTextMuted, fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: kTealDim,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'RANK #$rankPosition',
                style: const TextStyle(
                  color: kTeal, fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildStatsRow() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          children: [
            _StatBadge(
              label: 'ELO',
              value: eloRating.toString(),
              color: kTextPrimary,
            ),
            const SizedBox(width: 8),
            _StatBadge(
              label: 'MOVE',
              value: eloMove >= 0 ? '+$eloMove' : '$eloMove',
              color: eloMove >= 0 ? kTeal : kPressureHigh,
            ),
            const SizedBox(width: 8),
            _StatBadge(
              label: 'STREAK',
              value: streak >= 0 ? '+$streak' : '$streak',
              color: streak >= 0 ? kSuccessGreen : kWarningAmber,
            ),
            const SizedBox(width: 8),
            _StatBadge(
              label: 'FORM',
              value: form.toString(),
              color: kTextSecondary,
            ),
          ],
        ),
      );

  Widget _buildRivalContext() {
    final isAhead = rivalDelta > 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            Icon(
              isAhead ? Icons.trending_down : Icons.trending_up,
              color: isAhead ? kPressureHigh : kTeal,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isAhead
                    ? '$nearestRival is $rivalDelta pts ahead. Win this match to close the gap.'
                    : 'You\'re $rivalDelta pts clear of $nearestRival. Defend your rank.',
                style: const TextStyle(
                  color: kTextPrimary, fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseChart() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: kBorder, height: 1),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(
              'SEASON PULSE',
              style: TextStyle(
                color: kTextMuted, fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 0.8,
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: CustomPaint(
                painter: _PulsePainter(values: pulseHistory),
                size: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      );
}

class _StatBadge extends StatelessWidget {
  final String label, value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: kTextMuted, fontSize: 9,
                  fontWeight: FontWeight.w600, letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: color, fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}

class _PulsePainter extends CustomPainter {
  final List<int> values;

  const _PulsePainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final min = values.reduce(math.min).toDouble();
    final max = values.reduce(math.max).toDouble();
    final range = max - min == 0 ? 1.0 : max - min;

    double x(int i) => i * size.width / (values.length - 1);
    double y(int v) => size.height - ((v - min) / range) * size.height;

    // Fill path
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (var i = 0; i < values.length; i++) {
      fillPath.lineTo(x(i), y(values[i]));
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kTeal.withValues(alpha: 0.25), kTeal.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line path
    final linePath = Path();
    linePath.moveTo(x(0), y(values[0]));
    for (var i = 1; i < values.length; i++) {
      linePath.lineTo(x(i), y(values[i]));
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = kTeal
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    // Last dot
    canvas.drawCircle(
      Offset(x(values.length - 1), y(values.last)),
      4,
      Paint()..color = kGold,
    );
  }

  @override
  bool shouldRepaint(_PulsePainter old) => old.values != values;
}
