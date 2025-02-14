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
    return Material(
      color: Colors.black54,
      child: SizedBox.expand(
        child: Column(
          spacing: 15.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/app/logo.png", width: 0.3 * size.width, height: 0.3 * size.height),
            Text("You Lost", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38.sp, color: Colors.white)),
            SizedBox(
                child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Image.asset(GameAssets.coin, width: 25, height: 25),
              SizedBox(width: 5.w),
              BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp, color: Colors.amber));
              })
            ])),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WoodenSquareButton(
                    size: Size.square(68.h),
                    onTap: () {
                      context.read<GameBloc>().add(GameEnd());
                      Navigator.of(context).pop();
                    },
                    widget: Icon(Icons.arrow_back, color: Colors.white, size: 40.sp)),
                SizedBox(width: 30.w),
                WoodenSquareButton(
                    size: Size.square(68.h),
                    onTap: () async {
                      restart();
                      final gameBloc = context.read<GameBloc>();
                      gameBloc.add(GameRestart());
                      context.read<EarnedCoinCubit>().revertPoint();
                    },
                    widget: Icon(Icons.replay_outlined, color: Colors.white, size: 40.sp)),
                const SizedBox(width: 30),
                WoodenButton(
                    size: Size(170.w, 56.h),
                    onTap: () {
                      final database = GetIt.I.get<LeaderboardDatabase>();
                      final earnedCoinCubit = context.read<EarnedCoinCubit>();
                      database.registerPlayerScore(LocalStorage.instance.playerName ?? "", earnedCoinCubit.state);
                      ToastMessage(message: "${LocalStorage.instance.playerName}: Submitted your score ${earnedCoinCubit.state}").show();
                    },
                    text: "SUBMIT SCORE"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
