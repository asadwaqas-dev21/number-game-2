import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'mode_selection_screen.dart';

class NameEntryScreen extends StatefulWidget {
  final GameState gameState;

  const NameEntryScreen({super.key, required this.gameState});

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  late List<TextEditingController> _controllers;
  final _formKey = GlobalKey<FormState>();

  static const List<String> _playerEmojis = [
    '🦁',
    '🐯',
    '🐻',
    '🐼',
    '🦊',
    '🐸',
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.gameState.playerCount,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      widget.gameState.playerNames = _controllers
          .map((c) => c.text.trim())
          .toList();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ModeSelectionScreen(gameState: widget.gameState),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(
                    '📝 Enter Names',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Who is playing today?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),

                  // Name fields
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.gameState.playerCount,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: AnimatedContainer(
                            duration: Duration(
                              milliseconds: 300 + (index * 100),
                            ),
                            curve: Curves.easeOut,
                            child: TextFormField(
                              controller: _controllers[index],
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(
                                color: AppTheme.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    _playerEmojis[index % _playerEmojis.length],
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 48,
                                  minHeight: 0,
                                ),
                                hintText: 'Player ${index + 1}\'s Name',
                                filled: true,
                                fillColor: AppTheme.surfaceCard.withAlpha(180),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a name!';
                                }
                                return null;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Next button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
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
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CHOOSE A MODE',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
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
      ),
    );
  }
}
