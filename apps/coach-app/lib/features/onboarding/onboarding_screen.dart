import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'steps/step_philosophy.dart';
import 'steps/step_team.dart';
import 'steps/step_strengths.dart';
import 'steps/step_reveal.dart';

/// Data collected across the onboarding steps.
class OnboardingData {
  String? philosophy;
  String? philosophyLabel;
  String? team;
  String? league;
  List<String> strengths = [];
  String? weakness;
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  final _data = OnboardingData();
  int _currentStep = 0;

  static const int _totalSteps = 4;

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _StepProgress(current: _currentStep, total: _totalSteps),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PhilosophyStep(
                    onSelect: (key, label) {
                      _data.philosophy = key;
                      _data.philosophyLabel = label;
                      _next();
                    },
                  ),
                  TeamStep(
                    onSelect: (team, league) {
                      _data.team = team;
                      _data.league = league;
                      _next();
                    },
                  ),
                  StrengthsStep(
                    onComplete: (strengths, weakness) {
                      _data.strengths = strengths;
                      _data.weakness = weakness;
                      _next();
                    },
                  ),
                  RevealStep(
                    data: _data,
                    onEnterSeason: widget.onComplete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _StepProgress extends StatelessWidget {
  final int current, total;

  const _StepProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          children: List.generate(total, (i) {
            final done = i <= current;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
                height: 3,
                decoration: BoxDecoration(
                  color: done ? kTeal : kBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      );
}
