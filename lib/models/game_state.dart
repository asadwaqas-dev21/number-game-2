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
        return "Giant's Step";
      case GameMode.tinyAnt:
        return 'Tiny Ant';
      case GameMode.magic10:
        return 'Magic 10';
      case GameMode.doubleTrouble:
        return 'Double Trouble';
      case GameMode.reverse:
        return 'Reverse!';
      case GameMode.luckyOdd:
        return 'Lucky Odd';
      case GameMode.squareUp:
        return 'Square Up';
      case GameMode.halfAndHalf:
        return 'Half & Half';
      case GameMode.mysteryBonus:
        return 'Mystery Bonus';
      case GameMode.countdown:
        return 'Countdown';
    }
  }

  String get teaser {
    switch (this) {
      case GameMode.giantsStep:
        return 'Something big awaits!';
      case GameMode.tinyAnt:
        return 'The smallest can be mightiest!';
      case GameMode.magic10:
        return 'A mysterious number holds the key…';
      case GameMode.doubleTrouble:
        return 'Trouble comes in pairs!';
      case GameMode.reverse:
        return 'Nothing is what it seems!';
      case GameMode.luckyOdd:
        return 'Fortune favors the unusual!';
      case GameMode.squareUp:
        return 'Power comes in shapes!';
      case GameMode.halfAndHalf:
        return 'What goes up must come halfway?';
      case GameMode.mysteryBonus:
        return 'A secret gift hides in every number!';
      case GameMode.countdown:
        return 'The clock is ticking from above!';
    }
  }

  String get ruleReveal {
    switch (this) {
      case GameMode.giantsStep:
        return 'Every number was multiplied by 3! Highest score wins!';
      case GameMode.tinyAnt:
        return 'Every number was divided by 2! Lowest score wins!';
      case GameMode.magic10:
        return 'The closest number to 10 wins!';
      case GameMode.doubleTrouble:
        return 'Every number was doubled, then 5 subtracted! Highest wins!';
      case GameMode.reverse:
        return 'All digits were reversed! Highest reversed number wins!';
      case GameMode.luckyOdd:
        return 'Odd numbers got +10 bonus! Highest score wins!';
      case GameMode.squareUp:
        return 'Every number was squared (N×N)! Highest score wins!';
      case GameMode.halfAndHalf:
        return 'Above 50 halved, below 50 doubled! Closest to 50 wins!';
      case GameMode.mysteryBonus:
        return 'Sum of digits added as bonus! Highest score wins!';
      case GameMode.countdown:
        return 'Score = 100 minus your number! Highest score wins!';
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

/// Stores the result of a single round.
class RoundResult {
  final int roundNumber;
  final GameMode mode;
  final List<int> playerNumbers;
  final List<double> scores;
  final int winnerIndex;
  final List<int> points; // points awarded to each player this round

  RoundResult({
    required this.roundNumber,
    required this.mode,
    required this.playerNumbers,
    required this.scores,
    required this.winnerIndex,
    required this.points,
  });
}

/// Holds all the game state across screens.
class GameState {
  static const int totalRounds = 5;

  int playerCount;
  List<String> playerNames;
  int currentRound;
  GameMode? selectedMode;
  List<int> playerNumbers;
  List<double> results;
  int? winnerIndex;
  List<RoundResult> roundResults;
  List<GameMode> usedModes;

  GameState({
    this.playerCount = 2,
    List<String>? playerNames,
    this.currentRound = 1,
    this.selectedMode,
    List<int>? playerNumbers,
    List<double>? results,
    this.winnerIndex,
    List<RoundResult>? roundResults,
    List<GameMode>? usedModes,
  }) : playerNames = playerNames ?? [],
       playerNumbers = playerNumbers ?? [],
       results = results ?? [],
       roundResults = roundResults ?? [],
       usedModes = usedModes ?? [];

  /// Calculate points based on ranking and save the round result.
  /// Winner gets playerCount points, 2nd gets playerCount-1, etc.
  void saveRoundResult() {
    // Build a ranking: sort player indices by score
    // The winner is already determined; we rank all players by how close
    // they are to "winning" for that mode.
    final points = _calculateRoundPoints();

    roundResults.add(
      RoundResult(
        roundNumber: currentRound,
        mode: selectedMode!,
        playerNumbers: List.from(playerNumbers),
        scores: List.from(results),
        winnerIndex: winnerIndex!,
        points: points,
      ),
    );
    usedModes.add(selectedMode!);
  }

  /// Calculate points for each player based on their rank.
  /// 1st place = playerCount * 2 points
  /// 2nd place = (playerCount - 1) * 2 points
  /// ... last place = 2 points
  List<int> _calculateRoundPoints() {
    // Create index-score pairs and sort by rank
    final indexed = List.generate(playerCount, (i) => i);

    // Determine sort order based on mode
    // For modes where higher is better (most modes): sort descending
    // For modes where lower is better (tinyAnt, magic10, halfAndHalf): sort ascending
    final bool lowerIsBetter =
        selectedMode == GameMode.tinyAnt ||
        selectedMode == GameMode.magic10 ||
        selectedMode == GameMode.halfAndHalf;

    if (lowerIsBetter) {
      indexed.sort((a, b) => results[a].compareTo(results[b]));
    } else {
      indexed.sort((a, b) => results[b].compareTo(results[a]));
    }

    // Assign points: rank 1 gets playerCount*100, rank 2 gets (playerCount-1)*100, etc.
    final pts = List<int>.filled(playerCount, 0);
    for (int rank = 0; rank < indexed.length; rank++) {
      pts[indexed[rank]] = (playerCount - rank) * 100;
    }
    return pts;
  }

  /// Get cumulative total points for each player across all completed rounds.
  List<int> getTotalPoints() {
    final totals = List<int>.filled(playerCount, 0);
    for (final round in roundResults) {
      for (int i = 0; i < playerCount; i++) {
        totals[i] += round.points[i];
      }
    }
    return totals;
  }

  /// Get points a player earned in a specific round (0-indexed roundIndex).
  int getPlayerRoundPoints(int playerIndex, int roundIndex) {
    if (roundIndex < roundResults.length) {
      return roundResults[roundIndex].points[playerIndex];
    }
    return 0;
  }

  /// Get the overall winner index (most total points).
  int getOverallWinnerIndex() {
    final totals = getTotalPoints();
    int bestIndex = 0;
    for (int i = 1; i < totals.length; i++) {
      if (totals[i] > totals[bestIndex]) {
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  /// Get the runner-up index (second most total points).
  int getRunnerUpIndex() {
    final totals = getTotalPoints();
    final winnerIdx = getOverallWinnerIndex();
    int bestIndex = -1;
    int bestScore = -1;
    for (int i = 0; i < totals.length; i++) {
      if (i != winnerIdx && totals[i] > bestScore) {
        bestScore = totals[i];
        bestIndex = i;
      }
    }
    return bestIndex == -1 ? (winnerIdx == 0 ? 1 : 0) : bestIndex;
  }

  /// Prepare for the next round.
  void prepareNextRound() {
    currentRound++;
    selectedMode = null;
    playerNumbers = [];
    results = [];
    winnerIndex = null;
  }

  /// Check if all rounds are complete.
  bool get isGameComplete => currentRound > totalRounds;

  void reset() {
    playerCount = 2;
    playerNames = [];
    currentRound = 1;
    selectedMode = null;
    playerNumbers = [];
    results = [];
    winnerIndex = null;
    roundResults = [];
    usedModes = [];
  }
}
