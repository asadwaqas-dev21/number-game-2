import '../models/game_state.dart';

class GameLogic {
  static void calculateResults(GameState state) {
    final numbers = state.playerNumbers;
    List<double> scores = [];

    switch (state.selectedMode!) {
      case GameMode.giantsStep:
        scores = numbers.map((n) => n * 3.0).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMax(scores);
        break;

      case GameMode.tinyAnt:
        scores = numbers.map((n) => n / 2.0).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMin(scores);
        break;

      case GameMode.magic10:
        scores = numbers.map((n) => (n - 10).abs().toDouble()).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMin(scores);
        break;

      case GameMode.doubleTrouble:
        scores = numbers.map((n) => (n * 2 - 5).toDouble()).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMax(scores);
        break;

      case GameMode.reverse:
        scores = numbers.map((n) {
          final reversed = int.parse(n.toString().split('').reversed.join());
          return reversed.toDouble();
        }).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMax(scores);
        break;

      case GameMode.luckyOdd:
        scores = numbers.map((n) {
          return n.isOdd ? (n + 10).toDouble() : n.toDouble();
        }).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMax(scores);
        break;

      case GameMode.squareUp:
        scores = numbers.map((n) => (n * n).toDouble()).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMax(scores);
        break;

      case GameMode.halfAndHalf:
        scores = numbers.map((n) {
          if (n > 50) return n / 2.0;
          if (n < 50) return n * 2.0;
          return 50.0;
        }).toList();
        final distances = scores.map((s) => (s - 50).abs()).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMin(distances);
        break;

      case GameMode.mysteryBonus:
        scores = numbers.map((n) {
          final digitSum = n
              .abs()
              .toString()
              .split('')
              .map(int.parse)
              .reduce((a, b) => a + b);
          return (n + digitSum).toDouble();
        }).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMax(scores);
        break;

      case GameMode.countdown:
        scores = numbers.map((n) => (100 - n).toDouble()).toList();
        state.results = scores;
        state.winnerIndex = _indexOfMax(scores);
        break;
    }
  }

  static int _indexOfMax(List<double> list) {
    int idx = 0;
    for (int i = 1; i < list.length; i++) {
      if (list[i] > list[idx]) idx = i;
    }
    return idx;
  }

  static int _indexOfMin(List<double> list) {
    int idx = 0;
    for (int i = 1; i < list.length; i++) {
      if (list[i] < list[idx]) idx = i;
    }
    return idx;
  }
}
