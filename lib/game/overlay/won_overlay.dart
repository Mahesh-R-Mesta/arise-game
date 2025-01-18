import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameWon extends StatelessWidget {
  final AriseGame game;
  final bool isLastGame;
  final Function() nexLevel;
  const GameWon({super.key, required this.game, required this.nexLevel, required this.isLastGame});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: SizedBox.expand(
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/app/logo.png", width: 150, height: 150),
            Text(isLastGame ? "🎉 Congratulations, You Won 🎉" : "You Won 🎊",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white)),
            SizedBox(
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset("assets/images/coin.png", width: 25, height: 25),
                const SizedBox(width: 5),
                BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                  return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.amber));
                })
              ]),
            ),
            if (!isLastGame)
              WoodenButton(
                  size: Size(170, 55),
                  onTap: () {
                    nexLevel.call();
                    final gameBloc = context.read<GameBloc>();
                    gameBloc.add(GameNextLevel(level: gameBloc.state.level + 1));
                  },
                  text: "NEXT"),

            WoodenButton(
                size: Size(170, 55),
                onTap: () {
                  game.overlays.remove("gameWon");
                  context.read<GameBloc>().add(GameEnd());
                  Navigator.of(context).pop();
                },
                text: "BACK"),
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
