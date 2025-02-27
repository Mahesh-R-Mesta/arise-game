import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/items/house_item.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/overlay/game_activity_overlay.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class HealthSyrup extends GameObjectSprite with HasGameRef<AriseGame> {
  HealthSyrup({super.position}) : super(scale: Vector2(1.5, 1.5));

  @override
  FutureOr<void> onLoad() async {
    behavior
      ..isOnGround = false
      ..mass = 0.2;
    sprite = await Sprite.load(GameAssets.syrup, images: gameRef.images);
    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.overlays.addEntry(
          "syrup",
          (ctx, game) => GameActivityOverlayButton(
              message: "Ohh! This formula will help me to heal instantly",
              doText: "Drink",
              onTap: () {
                gameRef.overlays.remove("syrup");
                removeFromParent();
                other.lifeline.resetHealth();
              }));
      gameRef.overlays.add("syrup");
    }
    if (other is HouseItemSprite && other.item == HouseItems.table) {
      behavior.isOnGround = true;
      behavior.yVelocity = 0;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    gameRef.overlays.remove("syrup");
    super.onCollisionEnd(other);
  }
}
