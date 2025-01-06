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
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  List<String> tileMapAsset = ["map_level_01.tmx", "map_level_02.tmx"];
  int level = 0;
  Key gameWidgetKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
        buildWhen: (previous, current) => false, //current is GameRunning,
        builder: (context, gameState) {
          return GameWidget.controlled(
              key: gameWidgetKey,
              gameFactory: () => AriseGame(gameMap: tileMapAsset[level], tileSize: GameViewConfig.MODIFIED_TILE, world: GameWorld()),
              overlayBuilderMap: {
                "startGame": (context, game) => GameStartIntro(gameLevel: level + 1, game: game as AriseGame),
                "controller": (context, game) => GameControls(game: game as AriseGame),
                "gameWon": (context, game) => GameWon(
                    game: game as AriseGame,
                    nexLevel: () => setState(() {
                          level += 1;
                          gameWidgetKey = UniqueKey();
                        })),
                "gameLost": (context, game) => GameLost(
                    game: game as AriseGame,
                    restart: () => setState(() {
                          gameWidgetKey = UniqueKey();
                        })),
                "resumeGame": (ctx, game) => GameResumeOverlay(game: game as AriseGame)
              },
              initialActiveOverlays: [
                "startGame"
              ]);
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
}
