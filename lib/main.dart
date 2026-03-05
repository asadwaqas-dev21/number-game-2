import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/player_count_screen.dart';

void main() {
  runApp(const HiddenRulesApp());
}

class HiddenRulesApp extends StatelessWidget {
  const HiddenRulesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Rules Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const PlayerCountScreen(),
    );
  }
}
