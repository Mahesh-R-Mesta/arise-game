import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/game/utils/controller.dart';
import 'package:arise_game/game/game.dart';
import 'package:arise_game/game/maps/game_world.dart';
import 'package:arise_game/game/utils/audio.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  GetIt.I
    ..registerLazySingleton(GameButtonBridge.new)
    ..registerLazySingleton(AudioService.new)
    ..registerLazySingleton(EarnedCoin.new);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(providers: [BlocProvider(create: (ctx) => GetIt.I.get<EarnedCoin>())], child: const GamePage()),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  final gameAudio = GetIt.I.get<AudioService>();
  final audioPlayNotifier = ValueNotifier<bool>(true);

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
    gameAudio..initialize();
    // ..playBackground();
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
    final buttonBridge = GetIt.I.get<GameButtonBridge>();
    return Stack(
      children: [
        GameWidget.controlled(gameFactory: () => AriseGame(tileSize: GameViewConfig.MODIFIED_TILE, world: GameWorld())),
        Positioned(
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
            )),
        Positioned(
            bottom: 20,
            left: 30,
            child: GestureDetector(
                onTapDown: (_) => buttonBridge.onMoveLeftDown(),
                onTapUp: (_) => buttonBridge.onMoveLeftUp(),
                child: Image.asset("assets/images/arrow_right.png"))),
        Positioned(
            bottom: 20,
            left: 150,
            child: GestureDetector(
                onTapDown: (_) => buttonBridge.onMoveRightDown(),
                onTapUp: (_) => buttonBridge.onMoveRightUp(),
                child: Image.asset("assets/images/arrow_left.png"))),
        Positioned(
            bottom: 20,
            right: 100,
            child: GestureDetector(
                onTapDown: (_) => buttonBridge.onJumpDown(),
                onTapUp: (details) => buttonBridge.onJumpUp(),
                child: Image.asset("assets/images/arrow_up.png"))),
        Positioned(
            bottom: 100,
            right: 30,
            child: GestureDetector(
                onTapDown: (_) => buttonBridge.attackDown(),
                onTapUp: (details) => buttonBridge.attackUp(),
                child: Image.asset("assets/images/attack.png"))),
        Positioned(
            right: 10,
            top: 10,
            child: IconButton(
                onPressed: () {
                  if (audioPlayNotifier.value) {
                    gameAudio.pauseBackground();
                    audioPlayNotifier.value = false;
                  } else {
                    gameAudio.resumeBackground();
                    audioPlayNotifier.value = true;
                  }
                },
                icon: ValueListenableBuilder<bool>(
                    valueListenable: audioPlayNotifier,
                    builder: (context, running, _) {
                      return running ? Icon(Icons.volume_up, color: Colors.white, size: 35) : Icon(Icons.volume_off, color: Colors.white, size: 35);
                    })))
      ],
    );
  }
}
