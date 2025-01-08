import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/util/audio.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/controller.dart';
import 'package:arise_game/util/storage.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GameControls extends StatelessWidget {
  final AriseGame game;
  const GameControls({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    final gameAudio = GetIt.I.get<AudioService>();
    final audioPlayNotifier = ValueNotifier<bool>(gameAudio.isBGPlaying());
    final buttonBridge = GetIt.I.get<GameButtonBridge>();

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
              top: 10,
              left: 10,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Image.asset(GameAssets.coin, width: 25, height: 25),
                    const SizedBox(width: 5),
                    BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                      return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.amber));
                    })
                  ]),
                ),
              )),
          Positioned(
              bottom: 20,
              left: 30,
              child: GestureDetector(
                  onTapDown: (_) => buttonBridge.onMoveLeftDown(),
                  onTapUp: (_) => buttonBridge.onMoveLeftUp(),
                  child: RotatedBox(quarterTurns: 2, child: Image.asset(GameAssets.arrowLeft)))),
          Positioned(
              bottom: 20,
              left: 150,
              child: GestureDetector(
                  onTapDown: (_) => buttonBridge.onMoveRightDown(),
                  onTapUp: (_) => buttonBridge.onMoveRightUp(),
                  child: Image.asset(GameAssets.arrowLeft))),
          Positioned(
              bottom: 20,
              right: 100,
              child: GestureDetector(
                  onTapDown: (_) => buttonBridge.onJumpDown(),
                  onTapUp: (details) => buttonBridge.onJumpUp(),
                  child: Image.asset(GameAssets.arrowUp))),
          Positioned(
              bottom: 100,
              right: 30,
              child: GestureDetector(
                  onDoubleTap: () => buttonBridge.attackDoubleTap(),
                  onTapDown: (_) => buttonBridge.attackDown(),
                  onTapUp: (details) => buttonBridge.attackUp(),
                  child: Image.asset(GameAssets.attack))),
          Positioned(
              right: 10,
              top: 10,
              child: WoodenSquareButton(
                  size: Size.square(60),
                  onTap: () {
                    if (!game.paused) {
                      game.pauseEngine();
                    }
                    // if (gameAudio.isBGPlaying()) {
                    //   gameAudio.pauseBackground();
                    // }
                    game.overlays.add("resumeGame");
                  },
                  widget: Icon(Icons.pause, color: Colors.white, size: 35))),
          if (LocalStorage.instance.bgSoundState)
            Positioned(
                right: 80,
                top: 10,
                child: WoodenSquareButton(
                  size: Size.square(60),
                  onTap: () {
                    if (gameAudio.isBGPlaying()) {
                      gameAudio.pauseBackground();
                      audioPlayNotifier.value = false;
                    } else if (gameAudio.isBGNotPlaying()) {
                      gameAudio.resumeBackground();
                      audioPlayNotifier.value = true;
                    }
                  },
                  widget: ValueListenableBuilder<bool>(
                      valueListenable: audioPlayNotifier,
                      builder: (context, running, _) {
                        return running ? Icon(Icons.volume_up, color: Colors.white, size: 35) : Icon(Icons.volume_off, color: Colors.white, size: 35);
                      }),
                ))
        ],
      ),
    );
  }
}
