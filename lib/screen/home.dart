import 'dart:ui';

import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/game/game.dart';
import 'package:arise_game/screen/guide_popup.dart';
import 'package:arise_game/screen/leader_board/leader_board.dart';
import 'package:arise_game/screen/popup/level_selection_popup.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/screen/popup/info_popup.dart';
import 'package:arise_game/screen/popup/quit_confirm_popup.dart';
import 'package:arise_game/screen/setting_popup.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final gameAudio = GetIt.I.get<AudioService>();

  @override
  void initState() {
    FToast().init(context);
    GetIt.I.get<LeaderboardDatabase>().listenForAddedPlayer();
    gameAudio.initialize();
    WidgetsBinding.instance.addObserver(this);
    updateApp();
    super.initState();
  }

  updateApp() {
    InAppUpdate.checkForUpdate().then((info) async {
      await InAppUpdate.startFlexibleUpdate();
    }).catchError((error) {
      debugPrint("$error");
    });
  }

  requestAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

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
  void dispose() {
    gameAudio
      ..stop()
      ..dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.9,
              child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppAsset.sunRise), fit: BoxFit.fill)),
                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: SizedBox.expand()),
              ),
            ),
            Positioned(
                top: 15,
                right: 15,
                child: WoodenSquareButton(
                    size: Size.square(55.w),
                    onTap: () => InfoPopup(context: context).show(),
                    widget: Icon(Icons.info_outline, size: 30.sp, color: Colors.white))),
            Positioned(
                top: 15,
                left: 15,
                child: WoodenSquareButton(
                    size: Size.square(55.w),
                    onTap: () => GuidePopup(context: context).show(),
                    widget: Icon(Icons.question_mark, size: 30.sp, color: Colors.white))),
            Positioned(
                bottom: 15,
                left: 15,
                child: WoodenSquareButton(
                    size: Size.square(55.w),
                    onTap: () async => await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LeaderBoardScreen())),
                    widget: Icon(Icons.leaderboard, size: 30.sp, color: Colors.white))),
            SizedBox.expand(
              child: Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAsset.logo, width: 130.h, height: 130.h),
                  WoodenButton(
                      size: Size(150, 50.h),
                      text: 'STORY',
                      onTap: () async {
                        context.read<GameBloc>().add(GameStart(level: 0));
                        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => GamePage()));
                        context.read<EarnedCoinCubit>().reset();
                      }),
                  WoodenButton(
                      size: Size(150.w, 50.h),
                      text: 'NEW GAME',
                      onTap: () async {
                        LevelSelection(
                            context: context,
                            onLevelSelect: (level) async {
                              context.read<GameBloc>().add(GameStart(level: level));
                              await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => GamePage()));
                            }).show();
                        context.read<EarnedCoinCubit>().reset();
                      }),
                  WoodenButton(size: Size(140.w, 50.h), text: 'SETTINGS', onTap: () => SettingsPopup(context: context).show()),
                  WoodenButton(size: Size(90.w, 50.h), text: 'QUIT', onTap: () => QuitConfirmation(context: context).show())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
