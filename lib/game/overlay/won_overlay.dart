import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/screen/leader_board/add_player.dart';
import 'package:arise_game/service/levels.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Material(
      color: Colors.black54,
      child: SizedBox.expand(
        child: Column(
          spacing: 15.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(level.isFinal ? AppAsset.cup : AppAsset.logo, width: 0.3 * size.width, height: 0.3 * size.height),
            Text(
                level.levelValue == 0
                    ? "Start The Game"
                    : level.isFinal
                        ? "🎉 Congratulations, You Won 🎉"
                        : "You Won",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.sp, color: Colors.white)),
            SizedBox(
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset(GameAssets.coin, width: 25.h, height: 25.h),
                SizedBox(width: 5.w),
                BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                  return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp, color: Colors.amber));
                })
              ]),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (level.levelValue != 0)
                  WoodenButton(
                      size: Size(170.w, 55.h),
                      onTap: () {
                        game.overlays.remove("gameWon");
                        context.read<GameBloc>().add(GameEnd());
                        Navigator.of(context).pop();
                      },
                      text: "BACK"),
                if (level.levelValue != 0)
                  WoodenButton(
                      size: Size(170.w, 55.h),
                      onTap: () {
                        showDialog(context: context, builder: (ctx) => AddPlayerToLeaderBoard());
                      },
                      text: "SUBMIT SCORE"),
                if (!level.isFinal)
                  WoodenButton(
                      size: Size(170.w, 55.h),
                      onTap: () {
                        nexLevel.call();
                        final gameBloc = context.read<GameBloc>();
                        context.read<EarnedCoinCubit>().checkLastPoint();
                        gameBloc.add(GameNextLevel(level: gameBloc.state.level + 1));
                      },
                      text: "NEXT"),
              ],
            )
            // ElevatedButton(
            //     onPressed: () {
            //       game.overlays.remove("gameWon");
            //       Navigator.of(context).pop();
            //     },
            //     child: Text("", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
          ],
        ),
      ),
    );
  }
}
