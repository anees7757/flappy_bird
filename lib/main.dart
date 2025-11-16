import 'package:flame/game.dart';
import 'package:flappy_bird/screens/game_screen.dart';
import 'package:flappy_bird/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'provider/game_provider.dart';
import 'screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SharedPrefsManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Center(child: GameScreen()),
      ),
    );
  }
}
