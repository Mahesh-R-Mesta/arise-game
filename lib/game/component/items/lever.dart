import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/components.dart';

class LeverStick extends GameObjectAnime with HasGameRef<AriseGame> {
  @override
  FutureOr<void> onLoad() async {
    behavior.isOnGround = false;
    animation = SpriteAnimation.spriteList(
        [for (int i = 0; i < 5; i++) await Sprite.load("${GameAssets.leverFolder}lever_floor${i + 1}.png", images: gameRef.images)],
        stepTime: 0.2);

    return super.onLoad();
  }
}
