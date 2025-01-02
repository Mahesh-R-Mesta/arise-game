import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/game/maps/game_world.dart';
import 'package:arise_game/game/overlay/game_controlls.dart';
import 'package:arise_game/game/overlay/game_lost.dart';
import 'package:arise_game/game/overlay/game_start_intro.dart';
import 'package:arise_game/game/overlay/won_overlay.dart';
import 'package:arise_game/game/utils/audio.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  final gameAudio = GetIt.I.get<AudioService>();

  Key gameWidgetKey = UniqueKey();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      gameAudio.pauseBackground();
    } else if (state == AppLifecycleState.resumed) {
      gameAudio.resumeBackground();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    gameAudio
      ..initialize()
      ..playBackground();
    // ..playBgRepeat();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    gameAudio.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget.controlled(
        key: gameWidgetKey,
        gameFactory: () => AriseGame(tileSize: GameViewConfig.MODIFIED_TILE, world: GameWorld()),
        overlayBuilderMap: {
          "startGame": (context, game) => GameStartIntro(game: game as AriseGame),
          "controller": (context, game) => GameControls(),
          "gameWon": (context, game) => GameWon(game: game as AriseGame),
          "gameLost": (context, game) => GameLost(
              game: game as AriseGame,
              restart: () => setState(() {
                    gameWidgetKey = UniqueKey();
                  })),
        },
        initialActiveOverlays: [
          "startGame"
        ]);
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
              BlocBuilder<EarnedCoin, int>(builder: (ctx, amount) {
                return Text(amount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.amber));
              })
            ]),
          ),
        ));
  }
}
