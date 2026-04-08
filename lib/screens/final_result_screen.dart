import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'player_count_screen.dart';

class FinalResultScreen extends StatefulWidget {
  final GameState gameState;

  const FinalResultScreen({super.key, required this.gameState});

  @override
  State<FinalResultScreen> createState() => _FinalResultScreenState();
}

class _FinalResultScreenState extends State<FinalResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    final totalPoints = state.getTotalPoints();
    final winnerIdx = state.getOverallWinnerIndex();
    final runnerUpIdx = state.getRunnerUpIndex();
    final roundCount = state.roundResults.length;

    final sortedIndices = List.generate(state.playerCount, (i) => i);
    sortedIndices.sort((a, b) => totalPoints[b].compareTo(totalPoints[a]));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Trophy cards
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Row(
                    children: [
                      // Winner
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withAlpha(15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.gold.withAlpha(60),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text('🏆', style: TextStyle(fontSize: 48)),
                              const SizedBox(height: 6),
                              Text(
                                state.playerNames[winnerIdx],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.gold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${totalPoints[winnerIdx]} pts',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.gold.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'CHAMPION',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.gold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Runner-up
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.silver.withAlpha(10),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.silver.withAlpha(40),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text('🥈', style: TextStyle(fontSize: 36)),
                              const SizedBox(height: 6),
                              Text(
                                state.playerNames[runnerUpIdx],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${totalPoints[runnerUpIdx]} pts',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.silver.withAlpha(15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'RUNNER UP',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.silver,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Full scoreboard heading
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'FINAL SCOREBOARD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Full scoreboard table
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildTable(
                      state,
                      sortedIndices,
                      totalPoints,
                      roundCount,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Round breakdown heading
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ROUND BREAKDOWN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.roundResults.length,
                  itemBuilder: (context, rIdx) {
                    final round = state.roundResults[rIdx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withAlpha(30),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'R${round.roundNumber}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryLight,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${round.mode.emoji} ${round.mode.displayName}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(state.playerCount, (pIdx) {
                            final isW = pIdx == round.winnerIndex;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    child: Text(
                                      isW ? '👑' : '',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      state.playerNames[pIdx],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isW
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: isW
                                            ? AppTheme.gold
                                            : AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '+${round.points[pIdx]}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isW
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isW
                                          ? AppTheme.gold
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),

                // Play Again
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PlayerCountScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('PLAY AGAIN'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(
    GameState state,
    List<int> sortedIndices,
    List<int> totalPoints,
    int roundCount,
  ) {
    final headerCells = <Widget>[
      _cell('', flex: 1, isHeader: true),
      _cell('Player', flex: 3, isHeader: true),
      for (int r = 0; r < roundCount; r++)
        _cell('R${r + 1}', flex: 2, isHeader: true),
      _cell('Total', flex: 2, isHeader: true, isGold: true),
    ];

    final rows = <Widget>[];
    for (int rank = 0; rank < sortedIndices.length; rank++) {
      final pIdx = sortedIndices[rank];
      final isW = rank == 0;
      final isR = rank == 1;

      final cells = <Widget>[
        _cell(
          isW
              ? '🏆'
              : isR
              ? '🥈'
              : '${rank + 1}',
          flex: 1,
          isGold: isW,
        ),
        _cell(
          state.playerNames[pIdx],
          flex: 3,
          isGold: isW,
          isBold: isW,
          isName: true,
        ),
        for (int r = 0; r < roundCount; r++)
          _cell(
            '${state.getPlayerRoundPoints(pIdx, r)}',
            flex: 2,
            isGold: state.roundResults[r].winnerIndex == pIdx,
          ),
        _cell('${totalPoints[pIdx]}', flex: 2, isGold: isW, isBold: true),
      ];

      rows.add(
        Container(
          color: isW ? AppTheme.gold.withAlpha(8) : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(children: cells),
        ),
      );
      if (rank < sortedIndices.length - 1) {
        rows.add(Divider(height: 1, color: AppTheme.card.withAlpha(80)));
      }
    }

    return Column(
      children: [
        Container(
          color: AppTheme.card,
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(children: headerCells),
        ),
        ...rows,
      ],
    );
  }

  Widget _cell(
    String text, {
    int flex = 1,
    bool isHeader = false,
    bool isGold = false,
    bool isBold = false,
    bool isName = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: isName ? TextAlign.left : TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 11 : 13,
          fontWeight: (isHeader || isBold || isGold)
              ? FontWeight.w700
              : FontWeight.w400,
          color: isGold
              ? AppTheme.gold
              : isHeader
              ? AppTheme.textSecondary
              : AppTheme.textPrimary,
          letterSpacing: isHeader ? 0.5 : 0,
        ),
      ),
    );
  }
}
