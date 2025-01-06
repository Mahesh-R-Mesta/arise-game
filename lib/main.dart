import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player_character.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/util/controller.dart';
import 'package:arise_game/util/audio.dart';
import 'package:arise_game/util/storage.dart';
import 'package:arise_game/screen/home.dart';
import 'package:arise_game/theme.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await GetStorage.init();
  GameViewConfig.debugMode = false;
  GetIt.I
    ..registerLazySingleton(GameButtonBridge.new)
    ..registerLazySingleton(AudioService.new)
    ..registerLazySingleton(EarnedCoinCubit.new)
    ..registerLazySingleton(LocalStorage.new);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (ctx) => GetIt.I.get<EarnedCoinCubit>()),
      BlocProvider(create: (ctx) => PlayerCharacterCubit()),
      BlocProvider(create: (ctx) => GameBloc())
    ], child: MaterialApp(title: 'First Game', debugShowCheckedModeBanner: false, theme: theme(), home: HomePage()));
  }
}
