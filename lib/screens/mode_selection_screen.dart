import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'number_entry_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  final GameState gameState;

  const ModeSelectionScreen({super.key, required this.gameState});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen>
    with SingleTickerProviderStateMixin {
  GameMode? _selectedMode;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _play() {
    if (_selectedMode == null) return;
    widget.gameState.selectedMode = _selectedMode;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NumberEntryScreen(gameState: widget.gameState),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  '🎯 Pick a Mode',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Each mode has a SECRET rule! 🤫',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // Mode cards
                Expanded(
                  child: ListView.builder(
                    itemCount: GameMode.values.length,
                    itemBuilder: (context, index) {
                      final mode = GameMode.values[index];
                      final isSelected = mode == _selectedMode;

                      final total = GameMode.values.length;
                      final start = (index / total).clamp(0.0, 0.9);
                      final end = ((index + 1) / total).clamp(
                        start + 0.05,
                        1.0,
                      );
                      return SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(1.0, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animController,
                                curve: Interval(
                                  start,
                                  end,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                            ),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedMode = mode),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isSelected
                                    ? AppTheme.modeCardColors[index]
                                    : [
                                        AppTheme.surfaceCard,
                                        AppTheme.surfaceCard.withAlpha(200),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: isSelected
                                  ? Border.all(
                                      color: Colors.white.withAlpha(180),
                                      width: 2,
                                    )
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.modeCardColors[index][0]
                                            .withAlpha(100),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  mode.emoji,
                                  style: const TextStyle(fontSize: 36),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mode.displayName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(fontSize: 20),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        mode.teaser,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.white.withAlpha(220)
                                              : AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Play button
                Padding(
                  padding: const EdgeInsets.only(bottom: 28, top: 8),
                  child: AnimatedOpacity(
                    opacity: _selectedMode != null ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: _selectedMode != null
                              ? AppTheme.buttonGradient
                              : null,
                          color: _selectedMode == null
                              ? AppTheme.surfaceCard
                              : null,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: _selectedMode != null
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryPink.withAlpha(100),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton(
                          onPressed: _selectedMode != null ? _play : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '🚀 PLAY!',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: _selectedMode != null
                                          ? Colors.white
                                          : AppTheme.textMuted,
                                    ),
                              ),
                            ],
                          ),
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
