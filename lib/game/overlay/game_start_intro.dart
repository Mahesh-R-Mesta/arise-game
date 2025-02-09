import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/player/game_bloc.dart';
import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/service/levels.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameStartIntro extends StatelessWidget {
  final Level level;
  final AriseGame game;
  const GameStartIntro({required this.game, super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
        color: Colors.black54,
        child: SizedBox.expand(
          child: Column(
            spacing: 8.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAsset.logo, width: 0.3 * size.width, height: 0.3 * size.height),
              Text(level.level, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white)),
              for (final instruction in level.instructions)
                Text(instruction, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp, color: Colors.white)),
              // Text("Kill wild animals", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white)),
              SizedBox(height: 10.h),
              WoodenButton(
                  size: Size(170, 55.h),
                  onTap: () {
                    game.overlays.remove("startGame");
                    final restarted = context.read<GameBloc>().state.restart > 0;
                    if (level.conversation.any((talk) => talk.key == "playStart") && !restarted) {
                      level.startConversation("playStart", game, onCompete: () => game.overlays.add("controller"));
                    } else {
                      if (level.levelValue != 0) game.overlays.add("controller");
                    }
                  },
                  text: "Start game"),
              // const SizedBox(height: 5),
              WoodenSquareButton(
                  size: Size(60.h, 60.h),
                  onTap: () {
                    context.read<GameBloc>().add(GameEnd());
                    Navigator.of(context).pop();
                  },
                  widget: Icon(Icons.arrow_back, color: Colors.white, size: 40.sp)),
            ],
          ),
        ));
  }
}
