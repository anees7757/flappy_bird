import 'package:flutter/material.dart';

import '../utils/shared_prefs.dart';

class GameState extends ChangeNotifier {
  int _score = 0;
  int _highScore = 0;
  bool _isGameOver = false;
  bool _hasStarted = false;
  bool _isGameLaunched = false;
  bool _isGameLoading = false;
  bool _isPaused = false;
  bool _isCountingDown = false;
  int _countdownValue = 3;


  String selectedBird = 'yellow';

  int get score => _score;

  int get highScore => _highScore;

  bool get isGameOver => _isGameOver;

  bool get hasStarted => _hasStarted;

  bool get isGameLaunched => _isGameLaunched;

  bool get isGameLoading => _isGameLoading;

  bool get isPaused => _isPaused;

  bool get isCountingDown => _isCountingDown;
  int get countdownValue => _countdownValue;

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

  void pauseGame() {
    if (_hasStarted && !_isGameOver) {
      _isPaused = true;
      notifyListeners();
    }
  }

  void resumeGame() {
    _isPaused = false;
    notifyListeners();
  }

  void startCountdown() {
    _isCountingDown = true;
    _countdownValue = 3;
    notifyListeners();
  }

  void updateCountdown(int value) {
    _countdownValue = value;
    notifyListeners();
  }

  void endCountdown() {
    _isCountingDown = false;
    notifyListeners();
  }

  void setGameOver(bool value) {
    _isGameOver = value;

    if (score > highScore) {
      _highScore = _score;
      Future.wait([SharedPrefsManager.saveHighScore(_score)]);
    }

    notifyListeners();
  }

  void setGameLaunched() {
    _isGameLaunched = true;
    _isGameLoading = true;
    notifyListeners();
  }

  void setGameLoading(bool value) {
    _isGameLoading = value;
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
