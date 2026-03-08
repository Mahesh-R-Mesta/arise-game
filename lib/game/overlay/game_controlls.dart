import 'dart:ui';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/service/controller.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

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
          // HUD: Coin Panel
          Positioned(
            top: 16.h,
            left: 16.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(GameAssets.coin, width: 22.h, height: 22.h),
                      SizedBox(width: 8.w),
                      BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                        return Text(
                          amount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.sp,
                            color: Colors.amberAccent,
                            letterSpacing: 1,
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top Right Buttons (Pause & Sound)
          Positioned(
            right: 16.w,
            top: 16.h,
            child: Row(
              children: [
                if (LocalStorage.instance.bgSoundState)
                  ValueListenableBuilder<bool>(
                    valueListenable: audioPlayNotifier,
                    builder: (context, running, _) {
                      return _HUDButton(
                        icon: running ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        onTap: () {
                          if (gameAudio.isBGPlaying()) {
                            gameAudio.pauseBackground();
                            audioPlayNotifier.value = false;
                          } else {
                            gameAudio.resumeBackground();
                            audioPlayNotifier.value = true;
                          }
                        },
                      );
                    },
                  ),
                SizedBox(width: 12.w),
                _HUDButton(
                  icon: Icons.pause_rounded,
                  onTap: () {
                    if (!game.paused) game.pauseEngine();
                    context.read<GameBloc>().add(GamePause());
                    game.overlays.add("resumeGame");
                  },
                ),
              ],
            ),
          ),

          // Controls: Movement
          if (!isJoyStick)
            Positioned(
              bottom: 30.h,
              left: 30.w,
              child: Row(
                children: [
                  _ControlButton(
                    onTapDown: (_) => buttonBridge.onMoveLeftDown(),
                    onTapUp: (_) => buttonBridge.onMoveLeftUp(),
                    icon: Icons.arrow_back_ios_new_rounded,
                  ),
                  SizedBox(width: 20.w),
                  _ControlButton(
                    onTapDown: (_) => buttonBridge.onMoveRightDown(),
                    onTapUp: (_) => buttonBridge.onMoveRightUp(),
                    icon: Icons.arrow_forward_ios_rounded,
                  ),
                ],
              ),
            ),

          if (isJoyStick)
            Positioned(
              bottom: 30.h,
              left: 30.w,
              child: Joystick(
                base: JoystickBase(
                  size: 140.w,
                  decoration: JoystickBaseDecoration(color: Colors.white.withValues(alpha: 0.1)),
                  arrowsDecoration: JoystickArrowsDecoration(color: Colors.white24),
                ),
                listener: (stickDrag) {
                  if (stickDrag.x > 0.4) {
                    buttonBridge.onMoveRightDown();
                  } else if (stickDrag.x < -0.4) {
                    buttonBridge.onMoveLeftDown();
                  }
                  if (stickDrag.y < -0.4) {
                    buttonBridge.onJumpDown();
                  }
                },
                onStickDragEnd: () => buttonBridge.onStopMoveCall(),
                stick: JoystickStick(
                  size: 60.w,
                  decoration: JoystickStickDecoration(color: Colors.white70),
                ),
              ),
            ),

          // Controls: Actions
          Positioned(
            bottom: 30.h,
            right: 30.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isJoyStick)
                  _ControlButton(
                    onTapDown: (_) => buttonBridge.onJumpDown(),
                    onTapUp: (_) => buttonBridge.onJumpUp(),
                    icon: Icons.arrow_upward_rounded,
                    isAction: true,
                  ),
                if (!isJoyStick) SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () => buttonBridge.attackTap(),
                  child: Container(
                    width: 80.h,
                    height: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.redAccent.withValues(alpha: 0.2), blurRadius: 15, spreadRadius: 2),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(GameAssets.attack, width: 45.h, height: 45.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HUDButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HUDButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 50.h,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white10),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white70, size: 24.sp),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final Function(TapDownDetails) onTapDown;
  final Function(TapUpDetails) onTapUp;
  final IconData icon;
  final bool isAction;

  const _ControlButton({
    required this.onTapDown,
    required this.onTapUp,
    required this.icon,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 70.h,
            height: 70.h,
            decoration: BoxDecoration(
              color: isAction ? Colors.amberAccent.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isAction ? Colors.amberAccent.withValues(alpha: 0.4) : Colors.white24,
                width: 2,
              ),
            ),
            child: Icon(icon, color: isAction ? Colors.amberAccent : Colors.white70, size: 32.sp),
          ),
        ),
      ),
    );
  }
}
