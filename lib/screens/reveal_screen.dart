import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'player_count_screen.dart';

class RevealScreen extends StatefulWidget {
  final GameState gameState;

  const RevealScreen({super.key, required this.gameState});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen>
    with TickerProviderStateMixin {
  late AnimationController _trophyController;
  late Animation<double> _trophyScale;
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();

    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _trophyScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.elasticOut),
    );

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Stagger: trophy first, then list
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _trophyController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _listController.dispose();
    super.dispose();
  }

  String _formatScore(double score) {
    if (score == score.roundToDouble()) {
      return score.toInt().toString();
    }
    return score.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    final winnerName = state.playerNames[state.winnerIndex!];
    final mode = state.selectedMode!;

    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Trophy + Winner
                ScaleTransition(
                  scale: _trophyScale,
                  child: Column(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 72)),
                      const SizedBox(height: 8),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.goldGradient.createShader(bounds),
                        child: Text(
                          '$winnerName Wins!',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(color: Colors.white, fontSize: 36),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rule reveal card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppTheme.cardGradient,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha(40)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${mode.emoji} The Secret Rule',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mode.ruleReveal,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Scoreboard header
                FadeTransition(
                  opacity: _listController,
                  child: Text(
                    '📊 Scoreboard',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 12),

                // Scoreboard list
                Expanded(
                  child: FadeTransition(
                    opacity: _listController,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _listController,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: ListView.builder(
                        itemCount: state.playerCount,
                        itemBuilder: (context, index) {
                          final isWinner = index == state.winnerIndex;
                          final name = state.playerNames[index];
                          final original = state.playerNumbers[index];
                          final score = state.results[index];

                          // For Magic 10, show distance
                          String scoreLabel;
                          if (mode == GameMode.magic10) {
                            scoreLabel =
                                'Entered: $original  •  Distance from 10: ${_formatScore(score)}';
                          } else {
                            scoreLabel =
                                'Entered: $original  →  Score: ${_formatScore(score)}';
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: isWinner
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFBBF24),
                                        Color(0xFFF59E0B),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        AppTheme.surfaceCard,
                                        AppTheme.surfaceCard.withAlpha(200),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(18),
                              border: isWinner
                                  ? Border.all(
                                      color: Colors.white.withAlpha(150),
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                // Rank
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isWinner
                                        ? Colors.white.withAlpha(60)
                                        : AppTheme.backgroundDark.withAlpha(
                                            120,
                                          ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isWinner ? '👑' : '#${index + 1}',
                                      style: TextStyle(
                                        fontSize: isWinner ? 18 : 14,
                                        fontWeight: FontWeight.w700,
                                        color: isWinner
                                            ? null
                                            : AppTheme.textMuted,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: isWinner
                                              ? AppTheme.backgroundDark
                                              : AppTheme.textWhite,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        scoreLabel,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isWinner
                                              ? AppTheme.backgroundDark
                                                    .withAlpha(180)
                                              : AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isWinner)
                                  const Text(
                                    '🏆',
                                    style: TextStyle(fontSize: 28),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Play Again button
                Padding(
                  padding: const EdgeInsets.only(bottom: 28, top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.buttonGradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withAlpha(100),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.replay_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PLAY AGAIN!',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
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
}
