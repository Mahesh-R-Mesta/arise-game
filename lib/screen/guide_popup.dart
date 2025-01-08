import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class GuidePopup extends StatelessWidget {
  final BuildContext context;
  const GuidePopup({required this.context, super.key});

  show() async => await showDialog(context: context, builder: (ctx) => GuidePopup(context: ctx));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          elevation: 3,
          color: Colors.black54,
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
          )),
    );
  }
}

class _GameInfoView extends StatelessWidget {
  const _GameInfoView({super.key});

  Widget guideContainer({required String asset, Widget? icon, required String text, required SpriteAnimationData data, bool flipX = false}) {
    return SizedBox(
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
            Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Game Controls", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
        Expanded(
            child: GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 2),
          children: [
            guideContainer(
                asset: GameAssets.characterBlue,
                icon: Image.asset(GameAssets.arrowLeft, width: 25, height: 25),
                text: "Move right",
                data: SpriteAnimationData.sequenced(
                    texturePosition: Vector2(0, 56 * 2), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56))),
            guideContainer(
                asset: GameAssets.characterBlue,
                icon: Image.asset(GameAssets.arrowLeft, width: 25, height: 25),
                text: "Move right",
                data: SpriteAnimationData.sequenced(
                    texturePosition: Vector2(0, 56 * 2), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56))),
            guideContainer(
                asset: GameAssets.characterBlue,
                icon: Image.asset(GameAssets.arrowLeft, width: 25, height: 25),
                text: "Move left",
                flipX: true,
                data: SpriteAnimationData.sequenced(
                    texturePosition: Vector2(0, 56 * 2), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56))),
            guideContainer(
                asset: GameAssets.characterBlue,
                icon: Image.asset(GameAssets.arrowUp, width: 25, height: 25),
                text: "Jump",
                flipX: false,
                data: SpriteAnimationData.sequenced(
                    texturePosition: Vector2(0, 56 * 3), amount: 16, amountPerRow: 8, stepTime: 0.06, textureSize: Vector2(56, 56))),
            guideContainer(
                asset: GameAssets.characterBlue,
                icon: Image.asset(GameAssets.attack, width: 25, height: 25),
                text: "Attack",
                flipX: false,
                data: SpriteAnimationData.sequenced(
                    texturePosition: Vector2(0, 56), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56))),
            guideContainer(
                asset: GameAssets.characterBlue,
                icon: Image.asset(GameAssets.attack, width: 25, height: 25),
                text: "Double tap",
                flipX: false,
                data: SpriteAnimationData.sequenced(texturePosition: Vector2(0, 56 * 10), amount: 3, stepTime: 0.3, textureSize: Vector2(56, 56))),
          ],
        )),
        Text("Collect coins & kill monsters", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
