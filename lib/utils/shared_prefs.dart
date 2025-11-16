import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// SAVE SCORE
  static Future saveHighScore(int value) async {
    await _prefs?.setInt('highScore', value);
  }

  /// LOAD SCORE
  static int getHighScore() {
    return _prefs?.getInt('highScore') ?? 0;
  }

  /// CLEAR EVERYTHING
  static Future clearAll() async {
    await _prefs?.clear();
  }
}
