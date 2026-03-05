/// All available game modes with their hidden rules.
enum GameMode {
  giantsStep,
  tinyAnt,
  magic10,
  doubleTrouble,
  reverse,
  luckyOdd,
  squareUp,
  halfAndHalf,
  mysteryBonus,
  countdown,
}

/// Extension to provide display info for each game mode.
extension GameModeInfo on GameMode {
  String get displayName {
    switch (this) {
      case GameMode.giantsStep:
        return "🦶 Giant's Step";
      case GameMode.tinyAnt:
        return '🐜 Tiny Ant';
      case GameMode.magic10:
        return '✨ Magic 10';
      case GameMode.doubleTrouble:
        return '🔥 Double Trouble';
      case GameMode.reverse:
        return '🔄 Reverse!';
      case GameMode.luckyOdd:
        return '🍀 Lucky Odd';
      case GameMode.squareUp:
        return '⬛ Square Up';
      case GameMode.halfAndHalf:
        return '🪙 Half & Half';
      case GameMode.mysteryBonus:
        return '🎁 Mystery Bonus';
      case GameMode.countdown:
        return '⏳ Countdown';
    }
  }

  /// Cryptic teasers that do NOT reveal the hidden rule!
  String get teaser {
    switch (this) {
      case GameMode.giantsStep:
        return 'Fee-fi-fo-fum… something big awaits!';
      case GameMode.tinyAnt:
        return 'Even the smallest can be mightiest!';
      case GameMode.magic10:
        return 'A mysterious number holds the key…';
      case GameMode.doubleTrouble:
        return 'Beware — trouble comes in pairs!';
      case GameMode.reverse:
        return 'Nothing is what it seems!';
      case GameMode.luckyOdd:
        return 'Fortune favors the… unusual!';
      case GameMode.squareUp:
        return 'Power comes in shapes you know!';
      case GameMode.halfAndHalf:
        return 'What goes up must come… halfway?';
      case GameMode.mysteryBonus:
        return 'A secret gift hides in every number!';
      case GameMode.countdown:
        return 'The clock is ticking… from above!';
    }
  }

  String get ruleReveal {
    switch (this) {
      case GameMode.giantsStep:
        return 'Every number was multiplied by 3!\nHighest score wins!';
      case GameMode.tinyAnt:
        return 'Every number was divided by 2!\nLowest score wins!';
      case GameMode.magic10:
        return 'The closest number to 10 wins!';
      case GameMode.doubleTrouble:
        return 'Every number was doubled, then 5 was subtracted!\nHighest score wins!';
      case GameMode.reverse:
        return 'All digits were reversed!\nHighest reversed number wins!';
      case GameMode.luckyOdd:
        return 'Odd numbers got +10 bonus, even numbers stayed!\nHighest score wins!';
      case GameMode.squareUp:
        return 'Every number was squared (N × N)!\nHighest score wins!';
      case GameMode.halfAndHalf:
        return 'Numbers above 50 were halved, below 50 were doubled!\nClosest to 50 wins!';
      case GameMode.mysteryBonus:
        return 'Sum of all digits was added as a bonus!\nHighest score wins!';
      case GameMode.countdown:
        return 'Your score is 100 minus your number!\nHighest score wins!';
    }
  }

  String get emoji {
    switch (this) {
      case GameMode.giantsStep:
        return '🦶';
      case GameMode.tinyAnt:
        return '🐜';
      case GameMode.magic10:
        return '✨';
      case GameMode.doubleTrouble:
        return '🔥';
      case GameMode.reverse:
        return '🔄';
      case GameMode.luckyOdd:
        return '🍀';
      case GameMode.squareUp:
        return '⬛';
      case GameMode.halfAndHalf:
        return '🪙';
      case GameMode.mysteryBonus:
        return '🎁';
      case GameMode.countdown:
        return '⏳';
    }
  }
}

/// Holds all the game state across screens.
class GameState {
  int playerCount;
  List<String> playerNames;
  GameMode? selectedMode;
  List<int> playerNumbers;
  List<double> results;
  int? winnerIndex;

  GameState({
    this.playerCount = 2,
    List<String>? playerNames,
    this.selectedMode,
    List<int>? playerNumbers,
    List<double>? results,
    this.winnerIndex,
  }) : playerNames = playerNames ?? [],
       playerNumbers = playerNumbers ?? [],
       results = results ?? [];

  void reset() {
    playerCount = 2;
    playerNames = [];
    selectedMode = null;
    playerNumbers = [];
    results = [];
    winnerIndex = null;
  }
}
