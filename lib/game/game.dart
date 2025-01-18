import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_state.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/game/maps/game_world.dart';
import 'package:arise_game/game/overlay/game_controlls.dart';
import 'package:arise_game/game/overlay/game_lost.dart';
import 'package:arise_game/game/overlay/game_resume.dart';
import 'package:arise_game/game/overlay/game_start_intro.dart';
import 'package:arise_game/game/overlay/won_overlay.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/levels.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  Key gameKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<GameBloc, GameState>(buildWhen: (previous, current) {
      return previous.level != current.level || previous.restart != current.restart;
    }, builder: (context, gameBloc) {
      final currentLevel = Level.levels[gameBloc.level - 1];
      return GameWidget.controlled(
          key: gameKey,
          gameFactory: () => AriseGame(level: currentLevel, screenSize: size, tileSize: GameViewConfig.MODIFIED_TILE, world: GameWorld()),
          overlayBuilderMap: {
            "startGame": (context, game) => GameStartIntro(level: currentLevel, game: game as AriseGame),
            "controller": (context, game) => GameControls(game: game as AriseGame),
            "gameWon": (context, game) => GameWon(game: game as AriseGame, isLastGame: currentLevel.isFinal, nexLevel: () => gameKey = UniqueKey()),
            "gameLost": (context, game) => GameLost(game: game as AriseGame, restart: () => gameKey = UniqueKey()),
            "resumeGame": (ctx, game) => GameResumeOverlay(game: game as AriseGame)
          },
          initialActiveOverlays: ["startGame"],
          loadingBuilder: (ctx) => Center(child: Image.asset(AppAsset.logo, width: size.height * 0.5, height: size.height * 0.5)),
          backgroundBuilder: (ctx) => background(size));
    });
  }

  Widget earningView() {
    return Positioned(
        top: 10,
        left: 10,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Image.asset("assets/images/coin.png", width: 25, height: 25),
              const SizedBox(width: 5),
              BlocBuilder<EarnedCoinCubit, int>(builder: (ctx, amount) {
                return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.amber));
              })
            ]),
          ),
        ));
  }

  Widget background(Size size) {
    return SizedBox.expand(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.6, width: size.width, child: Material(color: Color(0xffb4c6f5))),
          SizedBox(height: size.height * 0.4, width: size.width, child: Material(color: Color(0xff251613)))
        ],
      ),
    );
  }
}
