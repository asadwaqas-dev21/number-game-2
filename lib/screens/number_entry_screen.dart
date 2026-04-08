import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import '../logic/game_logic.dart';
import 'round_result_screen.dart';

class NumberEntryScreen extends StatefulWidget {
  final GameState gameState;

  const NumberEntryScreen({super.key, required this.gameState});

  @override
  State<NumberEntryScreen> createState() => _NumberEntryScreenState();
}

class _NumberEntryScreenState extends State<NumberEntryScreen> {
  int _currentPlayerIndex = 0;
  bool _numberLocked = false;
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.gameState.playerNumbers = [];
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _lockNumber() {
    final text = _numberController.text.trim();
    if (text.isEmpty) return;
    final number = int.tryParse(text);
    if (number == null) return;

    setState(() => _numberLocked = true);
    widget.gameState.playerNumbers.add(number);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_currentPlayerIndex < widget.gameState.playerCount - 1) {
        setState(() {
          _currentPlayerIndex++;
          _numberLocked = false;
          _numberController.clear();
        });
      } else {
        GameLogic.calculateResults(widget.gameState);
        widget.gameState.saveRoundResult();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RoundResultScreen(gameState: widget.gameState),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerName = widget.gameState.playerNames[_currentPlayerIndex];
    final mode = widget.gameState.selectedMode!;
    final round = widget.gameState.currentRound;

    return Scaffold(
      appBar: AppBar(
        title: Text('Round $round of ${GameState.totalRounds}'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mode chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${mode.emoji} ${mode.displayName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  mode.teaser,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 28),

                // Player indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentPlayerIndex + 1} / ${widget.gameState.playerCount}',
                    style: const TextStyle(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Enter your secret number',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),

                const SizedBox(height: 28),

                if (!_numberLocked) ...[
                  SizedBox(
                    width: 140,
                    child: TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: 4,
                      ),
                      decoration: InputDecoration(
                        hintText: '?',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          color: AppTheme.textSecondary.withAlpha(60),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _lockNumber,
                    icon: const Icon(Icons.lock_rounded, size: 18),
                    label: const Text('LOCK IN'),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withAlpha(20),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.success.withAlpha(60)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.success,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Number Locked!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pass device to next player',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
