import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import '../logic/game_logic.dart';
import 'number_entry_screen.dart';
import 'final_result_screen.dart';

class RoundResultScreen extends StatelessWidget {
  final GameState gameState;

  const RoundResultScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final roundResult = gameState.roundResults.last;
    final mode = roundResult.mode;
    final totalPoints = gameState.getTotalPoints();

    // Sort by total points descending
    final sortedIndices = List.generate(gameState.playerCount, (i) => i);
    sortedIndices.sort((a, b) => totalPoints[b].compareTo(totalPoints[a]));

    final roundCount = gameState.roundResults.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Round ${roundResult.roundNumber} / ${GameState.totalRounds}',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Winner banner
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.gold.withAlpha(40)),
                ),
                child: Row(
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gameState.playerNames[roundResult.winnerIndex],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.gold,
                            ),
                          ),
                          Text(
                            '+${roundResult.points[roundResult.winnerIndex]} pts',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'WINNER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.gold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Rule reveal
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${mode.emoji} ${mode.displayName} — ${mode.ruleReveal}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),

              // Points Table heading
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'POINTS TABLE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // Scoreboard table
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildTable(
                        sortedIndices,
                        totalPoints,
                        roundCount,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (gameState.currentRound >= GameState.totalRounds) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FinalResultScreen(gameState: gameState),
                          ),
                        );
                      } else {
                        gameState.prepareNextRound();
                        gameState.selectedMode = GameLogic.getRandomMode(
                          gameState.usedModes,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NumberEntryScreen(gameState: gameState),
                          ),
                        );
                      }
                    },
                    child: Text(
                      gameState.currentRound >= GameState.totalRounds
                          ? '🏆 FINAL RESULTS'
                          : 'NEXT ROUND →',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(
    List<int> sortedIndices,
    List<int> totalPoints,
    int roundCount,
  ) {
    // Build header row
    final headerCells = <Widget>[
      _headerCell(''),
      _headerCell('Player'),
      for (int r = 0; r < roundCount; r++) _headerCell('R${r + 1}'),
      _headerCell('Total', isTotal: true),
    ];

    // Build data rows
    final dataRows = <Widget>[];
    for (int rank = 0; rank < sortedIndices.length; rank++) {
      final pIdx = sortedIndices[rank];
      final isLeader = rank == 0;

      final cells = <Widget>[
        _dataCell('${rank + 1}', isLeader: isLeader, isGold: isLeader),
        _dataCell(
          gameState.playerNames[pIdx],
          isLeader: isLeader,
          isGold: isLeader,
          isName: true,
        ),
        for (int r = 0; r < roundCount; r++)
          _dataCell(
            '${gameState.getPlayerRoundPoints(pIdx, r)}',
            isLeader: isLeader,
            isGold: gameState.roundResults[r].winnerIndex == pIdx,
          ),
        _dataCell(
          '${totalPoints[pIdx]}',
          isLeader: isLeader,
          isGold: isLeader,
          isTotal: true,
        ),
      ];

      dataRows.add(
        Container(
          color: isLeader ? AppTheme.gold.withAlpha(10) : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: cells),
        ),
      );

      if (rank < sortedIndices.length - 1) {
        dataRows.add(Divider(height: 1, color: AppTheme.card.withAlpha(100)));
      }
    }

    return Column(
      children: [
        Container(
          color: AppTheme.card,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: headerCells),
        ),
        ...dataRows,
      ],
    );
  }

  Widget _headerCell(String text, {bool isTotal = false}) {
    return Expanded(
      flex: text == 'Player' ? 3 : (text == '' ? 1 : 2),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isTotal ? AppTheme.gold : AppTheme.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _dataCell(
    String text, {
    bool isLeader = false,
    bool isGold = false,
    bool isTotal = false,
    bool isName = false,
  }) {
    return Expanded(
      flex: isName ? 3 : (text.length <= 2 && !isName ? 1 : 2),
      child: Text(
        text,
        textAlign: isName ? TextAlign.left : TextAlign.center,
        style: TextStyle(
          fontSize: isTotal ? 14 : 13,
          fontWeight: (isLeader || isGold || isTotal)
              ? FontWeight.w700
              : FontWeight.w400,
          color: isGold
              ? AppTheme.gold
              : (isTotal ? AppTheme.textPrimary : AppTheme.textSecondary),
        ),
      ),
    );
  }
}
