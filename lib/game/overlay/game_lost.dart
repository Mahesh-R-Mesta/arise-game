import 'dart:ui';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/leaderboard_database.dart';
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

class GameLost extends StatelessWidget {
  final AriseGame game;
  final Function() restart;
  const GameLost({super.key, required this.game, required this.restart});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Material(
          color: Colors.black54,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: size.width * 0.85,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3), width: 2),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.red.withValues(alpha: 0.2),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "DEFEAT",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 42.sp,
                      color: Colors.redAccent,
                      letterSpacing: 6,
                      shadows: [
                        Shadow(color: Colors.red.withValues(alpha: 0.5), blurRadius: 15),
                      ],
                    ),
                  ).animate().fadeIn().scale(duration: 500.ms, curve: Curves.elasticOut),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "COINS COLLECTED",
                          style: TextStyle(color: Colors.white54, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(GameAssets.coin, width: 28.h, height: 28.h),
                            SizedBox(width: 10.w),
                            BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                              return Text(
                                amount.toString(),
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32.sp, color: Colors.amberAccent),
                              );
                            })
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WoodenSquareButton(
                          size: Size.square(70.h),
                          onTap: () {
                            context.read<GameBloc>().add(GameEnd());
                            Navigator.of(context).pop();
                          },
                          widget: Icon(Icons.home_rounded, color: Colors.white, size: 35.sp)),
                      SizedBox(width: 20.w),
                      WoodenSquareButton(
                          size: Size.square(70.h),
                          onTap: () async {
                            restart();
                            final gameBloc = context.read<GameBloc>();
                            gameBloc.add(GameRestart());
                            context.read<EarnedCoinCubit>().revertPoint();
                          },
                          widget: Icon(Icons.replay_rounded, color: Colors.white, size: 38.sp)),
                      SizedBox(width: 20.w),
                      WoodenButton(
                          size: Size(160.w, 60.h),
                          onTap: () {
                            final database = GetIt.I.get<LeaderboardDatabase>();
                            final earnedCoinCubit = context.read<EarnedCoinCubit>();
                            database.registerPlayerScore(LocalStorage.instance.playerName ?? "", earnedCoinCubit.state);
                            ToastMessage(message: "Score Submitted!").show();
                          },
                          text: "SUBMIT"),
                    ],
                  ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
