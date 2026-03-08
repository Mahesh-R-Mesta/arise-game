import 'dart:ui';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/service/levels.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/toast.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class GameWon extends StatelessWidget {
  final AriseGame game;
  final Level level;
  final Function() nexLevel;
  const GameWon({super.key, required this.game, required this.nexLevel, required this.level});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (LocalStorage.instance.maxLevelCompleted < level.levelValue + 1) {
      LocalStorage.instance.setMaxLevelCompleted = level.levelValue + 1;
    }
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Material(
          color: Colors.black54,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: size.width * 0.9,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3), width: 2),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.amber.withValues(alpha: 0.2),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(level.isFinal ? AppAsset.cup : AppAsset.logo, width: 0.25 * size.width, height: 0.25 * size.height)
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .rotate(begin: -0.05, end: 0.05, duration: 2.seconds, curve: Curves.easeInOut)
                      .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
                  SizedBox(height: 16.h),
                  Text(
                    level.levelValue == 0
                        ? "GO!"
                        : level.isFinal
                            ? "GRAND VICTORY"
                            : "VICTORY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36.sp,
                      color: Colors.amberAccent,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(color: Colors.amber.withValues(alpha: 0.5), blurRadius: 20),
                      ],
                    ),
                  ).animate().fadeIn().scale(duration: 600.ms, curve: Curves.elasticOut),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(GameAssets.coin, width: 26.h, height: 26.h),
                        SizedBox(width: 10.w),
                        BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                          return Text(
                            amount.toString(),
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28.sp, color: Colors.amberAccent),
                          );
                        })
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  SizedBox(height: 32.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (level.levelValue != 0)
                          WoodenSquareButton(
                              size: Size.square(65.h),
                              onTap: () {
                                game.overlays.remove("gameWon");
                                context.read<GameBloc>().add(GameEnd());
                                Navigator.of(context).pop();
                              },
                              widget: Icon(Icons.home_rounded, color: Colors.white, size: 32.sp)),
                        if (level.levelValue != 0) SizedBox(width: 16.w),
                        if (level.levelValue != 0)
                          WoodenButton(
                              size: Size(150.w, 65.h),
                              onTap: () {
                                final database = GetIt.I.get<LeaderboardDatabase>();
                                final earnedCoinCubit = context.read<EarnedCoinCubit>();
                                database.registerPlayerScore(LocalStorage.instance.playerName ?? "", earnedCoinCubit.state);
                                ToastMessage(message: "Score Submitted!").show();
                              },
                              text: "SUBMIT"),
                        if (!level.isFinal) SizedBox(width: 16.w),
                        if (!level.isFinal)
                          WoodenButton(
                              size: Size(150.w, 65.h),
                              onTap: () {
                                nexLevel.call();
                                final gameBloc = context.read<GameBloc>();
                                context.read<EarnedCoinCubit>().checkLastPoint();
                                gameBloc.add(GameNextLevel(level: gameBloc.state.level + 1));
                              },
                              text: "NEXT"),
                      ],
                    ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
