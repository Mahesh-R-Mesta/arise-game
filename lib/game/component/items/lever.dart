import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class LeverStick extends GameObjectAnime with HasGameRef<AriseGame> {
  LeverStick({super.position});
  @override
  FutureOr<void> onLoad() async {
    behavior.isOnGround = false;
    animation = SpriteAnimation.spriteList(
        [for (int i = 0; i < 5; i++) await Sprite.load("${GameAssets.leverFolder}lever_floor_${i + 1}.png", images: gameRef.images)],
        stepTime: 0.2);
    flipHorizontallyAroundCenter();
    add(RectangleHitbox());
    return super.onLoad();
  }
}
