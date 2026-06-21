import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../onboarding_screen.dart';

class RevealStep extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onEnterSeason;

  const RevealStep({
    super.key,
    required this.data,
    required this.onEnterSeason,
  });

  @override
  State<RevealStep> createState() => _RevealStepState();
}

class _RevealStepState extends State<RevealStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = CurvedAnimation(parent: _anim, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  String get _teamName {
    final t = widget.data.team ?? '';
    final parts = t.split('_');
    return parts.length > 1 ? parts[1] : t;
  }

  String get _leagueName => widget.data.league ?? 'League';

  String get _seasonGoal {
    final team = _teamName;
    return 'Lead $team to the $_leagueName playoffs.';
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: Column(
          children: [
            const Spacer(),

            // Badge reveal
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kTeal, Color(0xFF818CF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: kTeal.withValues(alpha: 0.3),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_cricket_rounded,
                  color: kBackground,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Philosophy label
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: kTealDim,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kTeal.withValues(alpha: 0.4)),
              ),
              child: Text(
                widget.data.philosophyLabel ?? 'The Balanced Leader',
                style: const TextStyle(
                  color: kTeal, fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Coach identity headline
            Text(
              'Your coaching identity\nis set.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kTextPrimary, fontSize: 28,
                fontWeight: FontWeight.w800, height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _seasonGoal,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kTextSecondary, fontSize: 15, height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // DNA summary chips
            if (widget.data.strengths.isNotEmpty) ...[
              Wrap(
                spacing: 6, runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  ...widget.data.strengths.map(
                    (s) => _DnaChip(label: s, color: kTeal),
                  ),
                  if (widget.data.weakness != null)
                    _DnaChip(
                      label: '⚠ ${widget.data.weakness}',
                      color: kPressureMid,
                    ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            const Spacer(),

            // Enter season CTA
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onEnterSeason,
                style: FilledButton.styleFrom(
                  backgroundColor: kTeal,
                  foregroundColor: kBackground,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enter the Season →',
                  style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DnaChip extends StatelessWidget {
  final String label;
  final Color color;

  const _DnaChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w500,
          ),
        ),
      );
}
