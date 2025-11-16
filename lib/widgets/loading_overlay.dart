import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

import '../utils/asset_links.dart';

Widget loadingOverlay() {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.backgroundDay),
            fit: BoxFit.fill,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.ground),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      Text(
        "loading...",
        style: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontFamily: "Botsmatic",
        ),
      ),
    ],
  );
}
