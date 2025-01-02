import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/utils/audio.dart';
import 'package:arise_game/game/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GameControls extends StatelessWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayNotifier = ValueNotifier<bool>(true);
    final buttonBridge = GetIt.I.get<GameButtonBridge>();
    final gameAudio = GetIt.I.get<AudioService>();
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
                    Image.asset("assets/images/coin.png", width: 25, height: 25),
                    const SizedBox(width: 5),
                    BlocBuilder<EarnedCoin, int>(builder: (ctx, amount) {
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
                  child: RotatedBox(quarterTurns: 2, child: Image.asset("assets/images/arrow_left.png")))),
          Positioned(
              bottom: 20,
              left: 150,
              child: GestureDetector(
                  onTapDown: (_) => buttonBridge.onMoveRightDown(),
                  onTapUp: (_) => buttonBridge.onMoveRightUp(),
                  child: Image.asset("assets/images/arrow_left.png"))),
          Positioned(
              bottom: 20,
              right: 100,
              child: GestureDetector(
                  onTapDown: (_) => buttonBridge.onJumpDown(),
                  onTapUp: (details) => buttonBridge.onJumpUp(),
                  child: Image.asset("assets/images/arrow_up.png"))),
          Positioned(
              bottom: 100,
              right: 30,
              child: GestureDetector(
                  onTapDown: (_) => buttonBridge.attackDown(),
                  onTapUp: (details) => buttonBridge.attackUp(),
                  child: Image.asset("assets/images/attack.png"))),
          Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                  onPressed: () {
                    if (audioPlayNotifier.value) {
                      gameAudio.pauseBackground();
                      audioPlayNotifier.value = false;
                    } else {
                      gameAudio.resumeBackground();
                      audioPlayNotifier.value = true;
                    }
                  },
                  icon: ValueListenableBuilder<bool>(
                      valueListenable: audioPlayNotifier,
                      builder: (context, running, _) {
                        return running ? Icon(Icons.volume_up, color: Colors.white, size: 35) : Icon(Icons.volume_off, color: Colors.white, size: 35);
                      })))
        ],
      ),
    );
  }
}
