import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/utils/audio.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GameResumeOverlay extends StatelessWidget {
  final AriseGame game;
  const GameResumeOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final gameAudio = GetIt.I.get<AudioService>();
    return Material(
      color: Colors.black54,
      child: SizedBox.expand(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/app/logo.png", width: 150, height: 150),
            SizedBox(
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset("assets/images/coin.png", width: 25, height: 25),
                const SizedBox(width: 5),
                BlocBuilder<EarnedCoin, int>(builder: (ctx, amount) {
                  return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.amber));
                })
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WoodenSquareButton(
                    size: Size.square(70),
                    onTap: () {
                      game.resumeEngine();
                      // }
                      if (gameAudio.isBGPaused()) {
                        gameAudio.resumeBackground();
                      }
                      game.overlays.remove("resumeGame");
                    },
                    widget: Icon(Icons.play_arrow, color: Colors.white, size: 40)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
