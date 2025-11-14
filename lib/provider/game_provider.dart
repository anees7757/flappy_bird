import 'package:flutter/material.dart';

import '../utils/shared_prefs.dart';

class GameState extends ChangeNotifier {
  int _score = 0;
  int _highScore = 0;
  bool _isGameOver = false;
  bool _hasStarted = false;
  bool _isGameLaunched = false;

  String selectedBird = 'yellow';

  int get score => _score;

  int get highScore => _highScore;

  bool get isGameOver => _isGameOver;

  bool get hasStarted => _hasStarted;

  bool get isGameLaunched => _isGameLaunched;

  void increaseScore() {
    _score++;
    notifyListeners();
  }

  void resetScore() {
    _score = 0;
    notifyListeners();
  }

  void setHighScore(int value) {
    _highScore = value;
    notifyListeners();
  }

  void setGameOver(bool value) {
    _isGameOver = value;

    if (_score > _highScore) {
      _highScore = _score;
      SharedPrefsManager.saveHighScore(_score);
    }

    notifyListeners();
  }

  void setGameLaunched() {
    _isGameLaunched = true;
    notifyListeners();
  }

  void startGame() {
    _hasStarted = true;
    notifyListeners();
  }

  void resetStart() {
    _hasStarted = false;
    notifyListeners();
  }
}
