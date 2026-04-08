import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'name_entry_screen.dart';

class PlayerCountScreen extends StatefulWidget {
  const PlayerCountScreen({super.key});

  @override
  State<PlayerCountScreen> createState() => _PlayerCountScreenState();
}

class _PlayerCountScreenState extends State<PlayerCountScreen> {
  int _selectedCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo area
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text('🎯', style: TextStyle(fontSize: 40)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Number Game',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '5 rounds • Hidden rules • Who will win?',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 40),

                // Section label
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SELECT PLAYERS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Player count selector
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: List.generate(5, (index) {
                      final count = index + 2;
                      final isSelected = count == _selectedCount;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCount = count),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final gameState = GameState(playerCount: _selectedCount);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NameEntryScreen(gameState: gameState),
                        ),
                      );
                    },
                    child: const Text("LET'S GO"),
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
