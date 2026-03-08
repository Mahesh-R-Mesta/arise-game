import 'dart:ui';

import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/game/game.dart';
import 'package:arise_game/screen/guide_popup.dart';
import 'package:arise_game/screen/leader_board/add_player.dart';
import 'package:arise_game/screen/leader_board/leader_board.dart';
import 'package:arise_game/screen/popup/level_selection_popup.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/screen/popup/info_popup.dart';
import 'package:arise_game/screen/popup/quit_confirm_popup.dart';
import 'package:arise_game/screen/setting_popup.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerName = LocalStorage.instance.playerName;
      if (playerName == null) {
        showDialog(context: context, builder: (ctx) => AddPlayerToLeaderBoard());
      }
    });
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
    final duration = 600.ms;
    final delay = 200.ms;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background Layer
            Opacity(
              opacity: 0.9,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAsset.sunRise),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                        ],
                        radius: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top Left: Guide
            Positioned(
              top: 20,
              left: 20,
              child: WoodenSquareButton(
                size: Size.square(55.w),
                onTap: () => GuidePopup(context: context).show(),
                widget: Icon(Icons.question_mark, size: 28.sp, color: Colors.white),
              ).animate().fadeIn(duration: duration).slideX(begin: -0.2),
            ),

            // Top Right: Info
            Positioned(
              top: 20,
              right: 20,
              child: WoodenSquareButton(
                size: Size.square(55.w),
                onTap: () => InfoPopup(context: context).show(),
                widget: Icon(Icons.info_outline, size: 28.sp, color: Colors.white),
              ).animate().fadeIn(duration: duration).slideX(begin: 0.2),
            ),

            // Bottom Left: Leaderboard
            Positioned(
              bottom: 20,
              left: 20,
              child: WoodenSquareButton(
                size: Size.square(55.w),
                onTap: () async => await Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const LeaderBoardScreen()),
                ),
                widget: Icon(Icons.leaderboard, size: 28.sp, color: Colors.white),
              ).animate().fadeIn(duration: duration).slideX(begin: -0.2),
            ),

            // Main Menu
            SizedBox.expand(
              child: Column(
                spacing: 12.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with Breathing Animation
                  Image.asset(AppAsset.logo, width: 140.h, height: 140.h)
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: 2000.ms,
                        curve: Curves.easeInOut,
                      )
                      .animate()
                      .fadeIn(duration: duration)
                      .slideY(begin: -0.1),
                  
                  SizedBox(height: 10.h),

                  // Menu Buttons with Staggered Animation
                  WoodenButton(
                    size: Size(160.w, 52.h),
                    text: 'STORY',
                    onTap: () async {
                      context.read<GameBloc>().add(GameStart(level: 0));
                      await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const GamePage()));
                      if (context.mounted) context.read<EarnedCoinCubit>().reset();
                    },
                  ).animate().fadeIn(delay: delay, duration: duration).slideY(begin: 0.2),

                  WoodenButton(
                    size: Size(160.w, 52.h),
                    text: 'NEW GAME',
                    onTap: () async {
                      LevelSelection(
                        context: context,
                        onLevelSelect: (level) async {
                          context.read<GameBloc>().add(GameStart(level: level));
                          await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const GamePage()));
                        },
                      ).show();
                      context.read<EarnedCoinCubit>().reset();
                    },
                  ).animate().fadeIn(delay: delay + 100.ms, duration: duration).slideY(begin: 0.2),

                  WoodenButton(
                    size: Size(150.w, 52.h),
                    text: 'SETTINGS',
                    onTap: () => SettingsPopup(context: context).show(),
                  ).animate().fadeIn(delay: delay + 200.ms, duration: duration).slideY(begin: 0.2),

                  WoodenButton(
                    size: Size(100.w, 52.h),
                    text: 'QUIT',
                    onTap: () => QuitConfirmation(context: context).show(),
                  ).animate().fadeIn(delay: delay + 300.ms, duration: duration).slideY(begin: 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
