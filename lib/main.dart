import 'package:arise_game/app_config.dart';
import 'package:arise_game/util/firebase_option.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player_character.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/service/controller.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/screen/home.dart';
import 'package:arise_game/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
// import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseSetting.option);
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await GetStorage.init();
  GameViewConfig.debugMode = false;
  GetIt.I
    ..registerLazySingleton(GameButtonBridge.new)
    ..registerLazySingleton(AudioService.new)
    ..registerLazySingleton(EarnedCoinCubit.new)
    ..registerLazySingleton(LocalStorage.new)
    ..registerLazySingleton(LeaderboardDatabase.new)
    ..registerLazySingleton(GameBloc.new);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => GetIt.I.get<EarnedCoinCubit>()),
          BlocProvider(create: (ctx) => PlayerCharacterCubit()),
          BlocProvider(create: (ctx) => GetIt.I.get<GameBloc>())
        ],
        child: ScreenUtilInit(
          designSize: AppConfig.designSize,
          minTextAdapt: true,
          child: MaterialApp(
              title: 'Arise: The monster invasion',
              debugShowCheckedModeBanner: false,
              theme: theme(),
              builder: (context, child) {
                final mediaQuery = MediaQuery.of(context);
                final constrained = mediaQuery.textScaler.clamp(minScaleFactor: 1, maxScaleFactor: 1.1);
                return MediaQuery(data: mediaQuery.copyWith(textScaler: constrained), child: child!);
              },
              home: HomePage()),
        ));
  }
}
