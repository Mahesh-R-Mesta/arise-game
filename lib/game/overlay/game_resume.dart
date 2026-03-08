import 'dart:ui';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class GameResumeOverlay extends StatelessWidget {
  final AriseGame game;
  const GameResumeOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final gameAudio = GetIt.I.get<AudioService>();
    final size = MediaQuery.of(context).size;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Material(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: size.width * 0.7,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: Colors.white10, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "PAUSED",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 4,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .shimmer(duration: 2.seconds, color: Colors.amberAccent.withValues(alpha: 0.3))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 1.5.seconds),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(GameAssets.coin, width: 24.h, height: 24.h),
                        SizedBox(width: 8.w),
                        BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                          return Text(
                            amount.toString(),
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22.sp, color: Colors.amberAccent),
                          );
                        })
                      ],
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WoodenSquareButton(
                          size: Size.square(75.h),
                          onTap: () {
                            game.resumeEngine();
                            context.read<GameBloc>().add(GameResume());
                            if (gameAudio.isBGNotPlaying()) {
                              gameAudio.resumeBackground();
                            }
                            game.overlays.remove("resumeGame");
                          },
                          widget: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 45.sp)),
                      SizedBox(width: 40.w),
                      WoodenSquareButton(
                          size: Size.square(75.h),
                          onTap: () {
                            context.read<GameBloc>().add(GameEnd());
                            Navigator.of(context).pop();
                          },
                          widget: Icon(Icons.home_rounded, color: Colors.white, size: 40.sp)),
                    ],
                  ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
