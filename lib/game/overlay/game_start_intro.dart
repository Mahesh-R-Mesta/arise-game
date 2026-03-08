import 'dart:ui';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/levels.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameStartIntro extends StatelessWidget {
  final Level level;
  final AriseGame game;
  const GameStartIntro({required this.game, super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Material(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white10, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAsset.logo, width: 0.25 * size.width, height: 0.25 * size.height)
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds, curve: Curves.easeInOut),
                  SizedBox(height: 12.h),
                  Text(
                    level.level.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.sp,
                      color: Colors.amberAccent,
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        for (int i = 0; i < level.instructions.length; i++)
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Text(
                              level.instructions[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.white70,
                                letterSpacing: 0.5,
                              ),
                            ).animate().fadeIn(delay: (400 + i * 100).ms).slideX(begin: 0.1),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WoodenSquareButton(
                          size: Size.square(60.h),
                          onTap: () {
                            context.read<GameBloc>().add(GameEnd());
                            Navigator.of(context).pop();
                          },
                          widget: Icon(Icons.arrow_back, color: Colors.white, size: 32.sp)),
                      SizedBox(width: 20.w),
                      WoodenButton(
                          size: Size(180.w, 60.h),
                          onTap: () {
                            game.overlays.remove("startGame");
                            final restarted = context.read<GameBloc>().state.restart > 0;
                            if (level.conversation.any((talk) => talk.key == "playStart") && !restarted) {
                              level.startConversation("playStart", game, onCompete: () => game.overlays.add("controller"));
                            } else {
                              if (level.levelValue != 0) game.overlays.add("controller");
                            }
                          },
                          text: "PLAY NOW"),
                    ],
                  ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
