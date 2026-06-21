import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StrengthsStep extends StatefulWidget {
  final void Function(List<String> strengths, String weakness) onComplete;

  const StrengthsStep({super.key, required this.onComplete});

  @override
  State<StrengthsStep> createState() => _StrengthsStepState();
}

class _StrengthsStepState extends State<StrengthsStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  final Set<String> _strengths = {};
  String? _weakness;

  static const _maxStrengths = 3;

  static const _options = [
    'Batting strategy',
    'Bowling rotations',
    'Field placements',
    'Team motivation',
    'Pressure situations',
    'Reading the pitch',
    'Death bowling',
    'Powerplay tactics',
    'Match-up analysis',
    'Player rotation',
  ];

  bool get _canProceed =>
      _strengths.length == _maxStrengths && _weakness != null;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _toggleStrength(String s) {
    if (_weakness == s) return;
    setState(() {
      if (_strengths.contains(s)) {
        _strengths.remove(s);
      } else if (_strengths.length < _maxStrengths) {
        _strengths.add(s);
      }
    });
  }

  void _setWeakness(String s) {
    setState(() {
      _strengths.remove(s);
      _weakness = _weakness == s ? null : s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Know your\ncoaching DNA.',
              style: TextStyle(
                color: kTextPrimary, fontSize: 26,
                fontWeight: FontWeight.w800, height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Every great coach knows what they\'re best at — and where they lean on their staff.',
              style: TextStyle(color: kTextSecondary, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Strengths
            Row(
              children: [
                const Text(
                  'STRENGTHS',
                  style: TextStyle(
                    color: kTeal, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_strengths.length}/$_maxStrengths selected',
                  style: const TextStyle(color: kTextMuted, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _options
                  .where((o) => o != _weakness)
                  .map((o) => _Chip(
                        label: o,
                        type: _strengths.contains(o)
                            ? _ChipType.strength
                            : _ChipType.neutral,
                        onTap: () => _toggleStrength(o),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Weakness
            const Row(
              children: [
                Text(
                  'YOUR BLIND SPOT',
                  style: TextStyle(
                    color: kPressureHigh, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 0.8,
                  ),
                ),
                SizedBox(width: 8),
                Tooltip(
                  message: 'AI will nudge you when you overlook this area',
                  child: Icon(Icons.info_outline,
                      color: kTextMuted, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Pick one — honesty here makes you a better coach.',
              style: TextStyle(color: kTextMuted, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _options
                  .where((o) => !_strengths.contains(o))
                  .map((o) => _Chip(
                        label: o,
                        type: _weakness == o
                            ? _ChipType.weakness
                            : _ChipType.neutral,
                        onTap: () => _setWeakness(o),
                      ))
                  .toList(),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canProceed
                    ? () => widget.onComplete(
                          _strengths.toList(),
                          _weakness!,
                        )
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: kTeal,
                  disabledBackgroundColor: kSurface,
                  foregroundColor: kBackground,
                  disabledForegroundColor: kTextMuted,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _canProceed
                      ? 'Lock in my coaching profile →'
                      : 'Pick $_maxStrengths strengths + 1 blind spot',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14,
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

enum _ChipType { neutral, strength, weakness }

class _Chip extends StatelessWidget {
  final String label;
  final _ChipType type;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, borderColor, textColor) = switch (type) {
      _ChipType.strength => (kTealDim, kTeal, kTeal),
      _ChipType.weakness => (kLiveDim, kLive, kLive),
      _ChipType.neutral => (kSurface, kBorder, kTextSecondary),
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: type != _ChipType.neutral
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
