import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/overlay/game_activity_overlay.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Sword extends GameObjectSprite with HasGameRef<AriseGame> {
  Sword({super.position}) : super(scale: Vector2(1.5, 1.5));

  @override
  FutureOr<void> onLoad() async {
    behavior.isOnGround = false;
    sprite = await Sprite.load(GameAssets.sword, images: gameRef.images);
    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.overlays.addEntry(
          "rSword",
          (ctx, game) => GameActivityOverlayButton(
              message: "Ohh! Magical sword",
              doText: "Pick",
              onTap: () {
                gameRef.overlays.remove("rSword");
                removeFromParent();
                other.current = PlayerState.lightning;
              }));
      gameRef.overlays.add("rSword");
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    gameRef.overlays.remove("rSword");
    super.onCollisionEnd(other);
  }
}
