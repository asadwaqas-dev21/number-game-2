import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'name_entry_screen.dart';

class PlayerCountScreen extends StatefulWidget {
  const PlayerCountScreen({super.key});

  @override
  State<PlayerCountScreen> createState() => _PlayerCountScreenState();
}

class _PlayerCountScreenState extends State<PlayerCountScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCount = 2;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackground,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text('🎮', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'How Many\nPlayers?',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(height: 1.1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose the number of brave players!',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Number selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final count = index + 2;
                      final isSelected = count == _selectedCount;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCount = count),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: isSelected ? 64 : 52,
                          height: isSelected ? 64 : 52,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppTheme.buttonGradient
                                : null,
                            color: isSelected ? null : AppTheme.surfaceCard,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryPink.withAlpha(
                                        120,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: isSelected ? 28 : 22,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 56),

                  // Next button
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.buttonGradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withAlpha(120),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final gameState = GameState(
                            playerCount: _selectedCount,
                          );
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      NameEntryScreen(gameState: gameState),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SlideTransition(
                                      position:
                                          Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOutCubic,
                                            ),
                                          ),
                                      child: child,
                                    );
                                  },
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 18,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "LET'S GO!",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
