import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TeamStep extends StatefulWidget {
  final void Function(String team, String league) onSelect;

  const TeamStep({super.key, required this.onSelect});

  @override
  State<TeamStep> createState() => _TeamStepState();
}

class _TeamStepState extends State<TeamStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  String _selectedLeague = 'CPL';
  String? _selectedTeam;

  static const _leagues = ['CPL', 'IPL', 'BBL', 'PSL'];

  static const _teams = <String, List<_Team>>{
    'CPL': [
      _Team('AA', 'Antigua & Barbuda Falcons', 'Brian Lara Stadium, Tarouba',
          'A squad built to win from the front. Aggressive top order, pace artillery.',
          Color(0xFF1E40AF), Color(0xFF1D4ED8)),
      _Team('BR', 'Barbados Royals', 'Kensington Oval, Bridgetown',
          'Home fortress advantage. Spin-friendly pitch, tactical depth.',
          Color(0xFF7C2D12), Color(0xFF9A3412)),
      _Team('GW', 'Guyana Amazon Warriors', 'Providence Stadium',
          'Consistent contenders. Data-driven setup, balanced lineup.',
          Color(0xFF14532D), Color(0xFF166534)),
      _Team('JT', 'Jamaica Tallawahs', 'Sabina Park, Kingston',
          'Explosive hitters. Unpredictable — and that\'s the strategy.',
          Color(0xFF713F12), Color(0xFF854D0E)),
      _Team('SLK', 'Saint Lucia Kings', 'Daren Sammy Stadium',
          'Rising franchise. Talented youth core hungry to prove themselves.',
          Color(0xFF1E3A5F), Color(0xFF1E40AF)),
      _Team('TKR', 'Trinbago Knight Riders', 'Queen\'s Park Oval',
          'The dynasty. Most titles, most pressure, highest expectations.',
          Color(0xFF3B0764), Color(0xFF4C1D95)),
    ],
    'IPL': [
      _Team('MI', 'Mumbai Indians', 'Wankhede Stadium',
          'Five titles. The gold standard of IPL franchises.',
          Color(0xFF1E3A8A), Color(0xFF1D4ED8)),
      _Team('CSK', 'Chennai Super Kings', 'MA Chidambaram Stadium',
          'Thala\'s army. Experience, loyalty, and slow-pitch mastery.',
          Color(0xFF713F12), Color(0xFFD97706)),
      _Team('RCB', 'Royal Challengers Bangalore', 'M Chinnaswamy',
          'Batters\' paradise, title chaser. Win it for the 12th man.',
          Color(0xFF7F1D1D), Color(0xFFEF4444)),
      _Team('KKR', 'Kolkata Knight Riders', 'Eden Gardens',
          'Eden roars for you. Spin-heavy squad, tactical flexibility.',
          Color(0xFF3B0764), Color(0xFF7C3AED)),
    ],
    'BBL': [
      _Team('SIX', 'Sydney Sixers', 'SCG',
          'Dominant dynasty. Depth squad, pace attack, title pedigree.',
          Color(0xFF14532D), Color(0xFF16A34A)),
      _Team('SCO', 'Perth Scorchers', 'Optus Stadium',
          'Fortress Perth. Swing and bounce — your bowlers will love this.',
          Color(0xFF431407), Color(0xFFEA580C)),
      _Team('STR', 'Adelaide Strikers', 'Adelaide Oval',
          'Day-night masters. Spin-friendly conditions, unique challenge.',
          Color(0xFF0C4A6E), Color(0xFF0284C7)),
      _Team('HUR', 'Hobart Hurricanes', 'Bellerive Oval',
          'Underdog story waiting to happen. Small ground, big boundaries.',
          Color(0xFF4A044E), Color(0xFFC026D3)),
    ],
    'PSL': [
      _Team('KAR', 'Karachi Kings', 'National Stadium Karachi',
          'City of lights, city of cricket. Volatile but brilliant.',
          Color(0xFF0C4A6E), Color(0xFF0369A1)),
      _Team('LAH', 'Lahore Qalandars', 'Gaddafi Stadium',
          'Champions. Pace factory, home crowd of 27,000.',
          Color(0xFF14532D), Color(0xFF15803D)),
    ],
  };

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

  @override
  Widget build(BuildContext context) {
    final teams = _teams[_selectedLeague] ?? [];
    return FadeTransition(
      opacity: _anim,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where does your\njourney begin?',
              style: TextStyle(
                color: kTextPrimary, fontSize: 26,
                fontWeight: FontWeight.w800, height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose your league and franchise.',
              style: TextStyle(color: kTextSecondary, fontSize: 15),
            ),
            const SizedBox(height: 16),
            // League tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _leagues
                    .map((l) => _LeagueTab(
                          label: l,
                          active: _selectedLeague == l,
                          onTap: () => setState(() {
                            _selectedLeague = l;
                            _selectedTeam = null;
                          }),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: teams.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _TeamCard(
                  team: teams[i],
                  selected: _selectedTeam == teams[i].abbrev,
                  onTap: () {
                    setState(() => _selectedTeam = teams[i].abbrev);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () => widget.onSelect(
                        '${_selectedLeague}_${teams[i].abbrev}',
                        _selectedLeague,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeagueTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _LeagueTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: active ? kTeal : kSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? kTeal : kBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? kBackground : kTextSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      );
}

class _TeamCard extends StatelessWidget {
  final _Team team;
  final bool selected;
  final VoidCallback onTap;

  const _TeamCard({
    required this.team,
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
            color: selected ? team.colorDim : kSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? team.color : kBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: team.colorDim,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: team.color.withValues(alpha: 0.5),
                  ),
                ),
                child: Center(
                  child: Text(
                    team.abbrev,
                    style: TextStyle(
                      color: team.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: TextStyle(
                        color: selected ? kTextPrimary : kTextPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      team.venue,
                      style: const TextStyle(
                        color: kTextSecondary, fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      team.description,
                      style: const TextStyle(
                        color: kTextSecondary, fontSize: 11, height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded,
                    color: team.color, size: 20),
            ],
          ),
        ),
      );
}

class _Team {
  final String abbrev, name, venue, description;
  final Color color, colorDim;

  const _Team(
    this.abbrev,
    this.name,
    this.venue,
    this.description,
    this.colorDim,
    this.color,
  );
}
