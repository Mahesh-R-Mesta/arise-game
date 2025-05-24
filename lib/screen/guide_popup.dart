// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuidePopup extends StatelessWidget {
  final BuildContext context;
  const GuidePopup({required this.context, super.key});

  show() async =>
      await showDialog(barrierColor: Colors.black87.withAlpha(190), useSafeArea: true, context: context, builder: (ctx) => GuidePopup(context: ctx));

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 3,
        color: Colors.transparent,
        child: Stack(
          children: [
            SizedBox.expand(
              child: Padding(padding: const EdgeInsets.all(15), child: _GameInfoView()),
            ),
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    padding: EdgeInsets.all(20),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.white, size: 40)))
          ],
        ));
  }
}

class _GameInfoView extends StatelessWidget {
  const _GameInfoView();

  Widget guideContainer({required String asset, Widget? icon, required String text, required SpriteAnimationData data, bool flipX = false}) {
    return SizedBox.expand(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
              width: 100,
              height: 100,
              child: Transform.flip(
                flipX: flipX,
                child: SpriteAnimationWidget.asset(path: asset, data: data),
              )),
          Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            Transform.flip(flipX: flipX, child: icon),
            Text(text, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white))
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Game Controls", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: Colors.white)),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 2),
                    children: [
                      guideContainer(
                          asset: GameAssets.characterBlue,
                          icon: Image.asset(GameAssets.arrowLeft, width: 25.h, height: 25.h),
                          text: "Move right",
                          data: SpriteAnimationData.sequenced(
                              texturePosition: Vector2(0, 56 * 2), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56))),
                      guideContainer(
                          asset: GameAssets.characterBlue,
                          icon: Image.asset(GameAssets.arrowLeft, width: 25.h, height: 25.h),
                          text: "Move left",
                          flipX: true,
                          data: SpriteAnimationData.sequenced(
                              texturePosition: Vector2(0, 56 * 2), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56))),
                      guideContainer(
                          asset: GameAssets.characterBlue,
                          icon: Image.asset(GameAssets.arrowUp, width: 25.h, height: 25.h),
                          text: "Jump",
                          flipX: false,
                          data: SpriteAnimationData.sequenced(
                              texturePosition: Vector2(0, 56 * 3), amount: 16, amountPerRow: 8, stepTime: 0.06, textureSize: Vector2(56, 56))),
                      guideContainer(
                          asset: GameAssets.characterBlue,
                          icon: Image.asset(GameAssets.attack, width: 25.h, height: 25.h),
                          text: "Attack",
                          flipX: false,
                          data: SpriteAnimationData.sequenced(
                              texturePosition: Vector2(0, 56), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56))),
                      guideContainer(
                          asset: GameAssets.characterBlue2,
                          icon: Row(
                            children: [
                              Image.asset(GameAssets.arrowUp, width: 20.h, height: 20.h),
                              const SizedBox(width: 10),
                              Image.asset(GameAssets.attack, width: 20.h, height: 20.h)
                            ],
                          ),
                          text: "Jump & Attack",
                          flipX: false,
                          data: SpriteAnimationData.sequenced(
                              texturePosition: Vector2(0, 56 * 4), amount: 8, amountPerRow: 8, stepTime: 0.2, textureSize: Vector2(56, 56))),
                      // guideContainer(
                      //     asset: GameAssets.characterBlue,
                      //     icon: Image.asset(GameAssets.attack, width: 25, height: 25),
                      //     text: "Double tap",
                      //     flipX: false,
                      //     data: SpriteAnimationData.sequenced(texturePosition: Vector2(0, 56 * 10), amount: 3, stepTime: 0.3, textureSize: Vector2(56, 56))),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text("Or enable Joystick control from setting for movement",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, decoration: TextDecoration.underline)),
                  const SizedBox(height: 30),
                  Joystick(
                    includeInitialAnimation: true,
                    base: JoystickBase(
                      size: 180,
                      decoration: JoystickBaseDecoration(color: Colors.white.withAlpha(50)),
                      arrowsDecoration: JoystickArrowsDecoration(color: Colors.white54),
                    ),
                    listener: (_) {},
                  ),
                  const SizedBox(height: 30),
                  Text("Collect coins & kill monsters", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonGuide {
  final String text;
  final String image;
  ButtonGuide({
    required this.text,
    required this.image,
  });
}
