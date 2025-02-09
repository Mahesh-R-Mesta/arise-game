import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
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
    return Material(
      color: Colors.black54,
      child: SizedBox.expand(
        child: Column(
          spacing: 20.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/app/logo.png", width: 0.3 * size.width, height: 0.3 * size.height),
            SizedBox(
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset("assets/images/coin.png", width: 25.h, height: 25.h),
                const SizedBox(width: 5),
                BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                  return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.amber));
                })
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WoodenSquareButton(
                    size: Size.square(70),
                    onTap: () {
                      game.resumeEngine();
                      context.read<GameBloc>().add(GameResume());
                      // }
                      if (gameAudio.isBGNotPlaying()) {
                        gameAudio.resumeBackground();
                      }
                      game.overlays.remove("resumeGame");
                    },
                    widget: Icon(Icons.play_arrow, color: Colors.white, size: 40)),
                const SizedBox(width: 50),
                WoodenSquareButton(
                    size: Size.square(70),
                    onTap: () {
                      context.read<GameBloc>().add(GameEnd());
                      Navigator.of(context).pop();
                    },
                    widget: Icon(Icons.arrow_back, color: Colors.white, size: 40))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
