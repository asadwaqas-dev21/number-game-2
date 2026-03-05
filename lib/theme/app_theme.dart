import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color primaryPink = Color(0xFFEC4899);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentYellow = Color(0xFFFBBF24);
  static const Color backgroundDark = Color(0xFF1E1B4B);
  static const Color backgroundLight = Color(0xFF312E81);
  static const Color surfaceCard = Color(0xFF3730A3);
  static const Color textWhite = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFFA5B4FC);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, Color(0xFF312E81), Color(0xFF4C1D95)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryPurple, primaryPink],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4338CA), Color(0xFF6D28D9)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static const List<List<Color>> modeCardColors = [
    [Color(0xFF7C3AED), Color(0xFFA78BFA)],
    [Color(0xFF14B8A6), Color(0xFF5EEAD4)],
    [Color(0xFFF59E0B), Color(0xFFFCD34D)],
    [Color(0xFFEF4444), Color(0xFFFCA5A5)],
    [Color(0xFF3B82F6), Color(0xFF93C5FD)],
    [Color(0xFF10B981), Color(0xFF6EE7B7)],
    [Color(0xFF8B5CF6), Color(0xFFC4B5FD)],
    [Color(0xFFF472B6), Color(0xFFFBCFE8)],
    [Color(0xFFD946EF), Color(0xFFF0ABFC)],
    [Color(0xFF0EA5E9), Color(0xFF7DD3FC)],
  ];

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryPurple,
        secondary: primaryPink,
        surface: surfaceCard,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: textWhite,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textWhite,
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textWhite,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textWhite,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
        bodyMedium: TextStyle(fontSize: 16, color: textMuted),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textWhite,
          letterSpacing: 1,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard.withAlpha(180),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryPink, width: 2),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 16),
        labelStyle: const TextStyle(color: textMuted, fontSize: 16),
      ),
    );
  }

  static BoxDecoration get screenBackground =>
      const BoxDecoration(gradient: backgroundGradient);

  static BoxDecoration gameCardDecoration({int colorIndex = 0}) {
    final colors = modeCardColors[colorIndex % modeCardColors.length];
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: colors[0].withAlpha(100),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
