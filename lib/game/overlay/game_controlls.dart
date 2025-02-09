import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/service/controller.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/widget/coin_pannel.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'dart:math' as math;

class GameControls extends StatelessWidget {
  final AriseGame game;
  const GameControls({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    final isJoyStick = LocalStorage.instance.joystickState;
    final gameAudio = GetIt.I.get<AudioService>();
    final audioPlayNotifier = ValueNotifier<bool>(gameAudio.isBGPlaying());
    final buttonBridge = GetIt.I.get<GameButtonBridge>();

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
              top: 10,
              left: 10,
              child: CustomPaint(
                painter: PanelPainter(),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 20),
                    child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Image.asset(GameAssets.coin, width: 25, height: 25),
                      const SizedBox(width: 5),
                      BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                        return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.amber));
                      })
                    ]),
                  ),
                ),
              )),
          if (!isJoyStick)
            Positioned(
                bottom: 20,
                left: 30,
                child: GestureDetector(
                    onTapDown: (_) => buttonBridge.onMoveLeftDown(),
                    onTapUp: (_) => buttonBridge.onMoveLeftUp(),
                    child: RotatedBox(quarterTurns: 2, child: Image.asset(GameAssets.arrowLeft, width: 70, height: 70, fit: BoxFit.fill)))),
          if (isJoyStick)
            Positioned(
                bottom: 30,
                left: 30,
                child: Joystick(
                    base: JoystickBase(
                      size: 170.w,
                      decoration: JoystickBaseDecoration(color: Colors.white.withAlpha(50)),
                      arrowsDecoration: JoystickArrowsDecoration(color: Colors.white54),
                    ),
                    includeInitialAnimation: false,
                    listener: (stickDrag) {
                      // print("${stickDrag.x}  ${stickDrag.y}");
                      if (stickDrag.x > 0.5) {
                        buttonBridge.onMoveRightDown();
                      } else if (stickDrag.x < -0.5) {
                        buttonBridge.onMoveLeftDown();
                      }
                      if (stickDrag.y < -0.5) {
                        buttonBridge.onJumpDown();
                      }
                    },
                    onStickDragEnd: () {
                      buttonBridge.onStopMoveCall();
                    },
                    stick: JoystickStick(
                      size: 70.w,
                      decoration: JoystickStickDecoration(color: Colors.white),
                    ))),
          if (!isJoyStick)
            Positioned(
                bottom: 20,
                left: 150,
                child: GestureDetector(
                    onTapDown: (_) => buttonBridge.onMoveRightDown(),
                    onTapUp: (_) => buttonBridge.onMoveRightUp(),
                    child: Image.asset(GameAssets.arrowLeft, width: 70, height: 70, fit: BoxFit.fill))),
          if (!isJoyStick)
            Positioned(
                bottom: 20,
                right: 180,
                child: GestureDetector(
                    onTapDown: (_) => buttonBridge.onJumpDown(),
                    onTapUp: (details) => buttonBridge.onJumpUp(),
                    child: Image.asset(GameAssets.arrowUp, width: 70, height: 70, fit: BoxFit.fill))),
          Positioned(
              bottom: 100,
              right: 80,
              child: GestureDetector(
                  onTap: () => buttonBridge.attackTap(),
                  child: Image.asset(
                    GameAssets.attack,
                    width: 75,
                    height: 75,
                    fit: BoxFit.fill,
                  ))),
          Positioned(
              right: 10,
              top: 10,
              child: WoodenSquareButton(
                  size: Size.square(60),
                  onTap: () {
                    if (!game.paused) {
                      game.pauseEngine();
                    }
                    context.read<GameBloc>().add(GamePause());
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
