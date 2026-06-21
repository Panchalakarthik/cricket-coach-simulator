import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PhilosophyStep extends StatefulWidget {
  final void Function(String key, String label) onSelect;

  const PhilosophyStep({super.key, required this.onSelect});

  @override
  State<PhilosophyStep> createState() => _PhilosophyStepState();
}

class _PhilosophyStepState extends State<PhilosophyStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  String? _selected;

  static const _philosophies = [
    _Philosophy(
      key: 'tactician',
      label: 'The Tactician',
      emoji: '🧠',
      tagline: 'Winning is pure science.',
      description:
          'You dissect every over, build the perfect plan, and execute relentlessly. Every run is calculated, every wicket expected.',
      accent: Color(0xFF818CF8),
      accentDim: Color(0xFF1E1B4B),
    ),
    _Philosophy(
      key: 'motivator',
      label: 'The Motivator',
      emoji: '🔥',
      tagline: 'Raw belief is your weapon.',
      description:
          'You turn nervous debutants into match-winners. The dressing room ignites when you walk in — and the opposition knows it.',
      accent: Color(0xFFF97316),
      accentDim: Color(0xFF3A1500),
    ),
    _Philosophy(
      key: 'analyst',
      label: 'The Analyst',
      emoji: '🎯',
      tagline: 'Data tells the truth.',
      description:
          'Your edge is seeing patterns others miss. Pitch maps, wagon wheels, matchup percentages — your playbook is built on evidence.',
      accent: Color(0xFF4AEAC4),
      accentDim: Color(0xFF0D2E28),
    ),
    _Philosophy(
      key: 'fighter',
      label: 'The Fighter',
      emoji: '🦁',
      tagline: 'Never say die.',
      description:
          'You\'ve pulled off the impossible and you\'ll do it again. Your teams fight to the last ball — because that\'s who you are.',
      accent: Color(0xFFEF4444),
      accentDim: Color(0xFF3D0A0A),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
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
              'Your coaching\njourney begins now.',
              style: TextStyle(
                color: kTextPrimary, fontSize: 26,
                fontWeight: FontWeight.w800, height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'What kind of coach are you?',
              style: TextStyle(color: kTextSecondary, fontSize: 15),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: _philosophies
                    .map((p) => _PhilosophyCard(
                          philosophy: p,
                          selected: _selected == p.key,
                          onTap: () {
                            setState(() => _selected = p.key);
                            Future.delayed(
                              const Duration(milliseconds: 180),
                              () => widget.onSelect(p.key, p.label),
                            );
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhilosophyCard extends StatelessWidget {
  final _Philosophy philosophy;
  final bool selected;
  final VoidCallback onTap;

  const _PhilosophyCard({
    required this.philosophy,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? philosophy.accentDim : kSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? philosophy.accent : kBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(philosophy.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                philosophy.label,
                style: TextStyle(
                  color: selected ? philosophy.accent : kTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                philosophy.tagline,
                style: TextStyle(
                  color: selected
                      ? philosophy.accent.withValues(alpha: 0.8)
                      : kTextSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  philosophy.description,
                  style: const TextStyle(
                    color: kTextSecondary, fontSize: 11, height: 1.4,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      );
}

class _Philosophy {
  final String key, label, emoji, tagline, description;
  final Color accent, accentDim;

  const _Philosophy({
    required this.key,
    required this.label,
    required this.emoji,
    required this.tagline,
    required this.description,
    required this.accent,
    required this.accentDim,
  });
}
