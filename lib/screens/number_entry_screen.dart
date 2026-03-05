import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'reveal_screen.dart';
import '../logic/game_logic.dart';

class NumberEntryScreen extends StatefulWidget {
  final GameState gameState;

  const NumberEntryScreen({super.key, required this.gameState});

  @override
  State<NumberEntryScreen> createState() => _NumberEntryScreenState();
}

class _NumberEntryScreenState extends State<NumberEntryScreen>
    with SingleTickerProviderStateMixin {
  int _currentPlayerIndex = 0;
  bool _numberLocked = false;
  final TextEditingController _numberController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const List<Color> _turnColors = [
    AppTheme.primaryPurple,
    AppTheme.primaryPink,
    AppTheme.accentTeal,
    AppTheme.accentOrange,
    AppTheme.accentYellow,
    Color(0xFF3B82F6),
  ];

  @override
  void initState() {
    super.initState();
    widget.gameState.playerNumbers = [];
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _lockNumber() {
    final text = _numberController.text.trim();
    if (text.isEmpty) return;
    final number = int.tryParse(text);
    if (number == null) return;

    setState(() {
      _numberLocked = true;
    });

    widget.gameState.playerNumbers.add(number);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_currentPlayerIndex < widget.gameState.playerCount - 1) {
        // Next player
        _fadeController.reverse().then((_) {
          setState(() {
            _currentPlayerIndex++;
            _numberLocked = false;
            _numberController.clear();
          });
          _fadeController.forward();
        });
      } else {
        // All done — calculate and reveal!
        GameLogic.calculateResults(widget.gameState);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                RevealScreen(gameState: widget.gameState),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerName = widget.gameState.playerNames[_currentPlayerIndex];
    final turnColor = _turnColors[_currentPlayerIndex % _turnColors.length];

    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackground,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Turn indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: turnColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: turnColor.withAlpha(100)),
                      ),
                      child: Text(
                        'Player ${_currentPlayerIndex + 1} of ${widget.gameState.playerCount}',
                        style: TextStyle(
                          color: turnColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Player name
                    Text('🤫', style: const TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text(
                      "It's $playerName's\nTurn!",
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(color: turnColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your secret number below',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 40),

                    // Number input
                    if (!_numberLocked) ...[
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _numberController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textWhite,
                            letterSpacing: 4,
                          ),
                          decoration: InputDecoration(
                            hintText: '?',
                            hintStyle: TextStyle(
                              fontSize: 40,
                              color: AppTheme.textMuted.withAlpha(100),
                            ),
                            filled: true,
                            fillColor: AppTheme.surfaceCard,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: turnColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [turnColor, turnColor.withAlpha(180)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: turnColor.withAlpha(100),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _lockNumber,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'LOCK IN!',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // Locked state
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(40),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.green.withAlpha(100),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '🔒 Number Locked!',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: Colors.green),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pass the device to the next player',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.green.withAlpha(180),
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
        ),
      ),
    );
  }
}
