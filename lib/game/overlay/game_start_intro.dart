import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:flutter/material.dart';

class GameStartIntro extends StatelessWidget {
  final int gameLevel;
  final AriseGame game;
  const GameStartIntro({required this.game, super.key, required this.gameLevel});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black54,
        child: SizedBox.expand(
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/app/logo.png", width: 150, height: 150),
              Text("Level - $gameLevel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
              Text("Collect coins", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white)),
              Text("Kill wild animals", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white)),
              const SizedBox(height: 15),
              WoodenButton(
                  size: Size(170, 55),
                  onTap: () {
                    game.overlays
                      ..remove("startGame")
                      ..add("controller");
                    // context.read<EarnedCoinCubit>().reset();
                    // game.gameWorld.addPlayer();
                  },
                  text: "Start game"),
              const SizedBox(height: 5),
              WoodenButton(size: Size(120, 55), onTap: () => Navigator.of(context).pop(), text: "Back"),
            ],
          ),
        ));
  }
}
