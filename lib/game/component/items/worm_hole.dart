import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/overlay/game_activity_overlay.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum Worm {
  incoming,
  out;

  static Worm parse(String game) {
    if (game == "start") {
      return Worm.out;
    } else {
      return Worm.incoming;
    }
  }
}

class WormHole extends GameObjectAnime with HasGameRef<AriseGame> {
  Worm type;
  WormHole({required this.type, super.position}) : super(scale: Vector2(1.5, 1.5));

  @override
  FutureOr<void> onLoad() {
    // behavior.isOnGround = false;
    debugMode = true;
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache(GameAssets.wormhole),
        SpriteAnimationData.sequenced(amount: 20, amountPerRow: 4, stepTime: 0.2, textureSize: Vector2(96, 80)));
    add(RectangleHitbox(position: Vector2(width / 2, height / 2), size: Vector2(width + 100, height), anchor: Anchor.center));
    if (type == Worm.out) {
      Future.delayed(const Duration(seconds: 4), () => removeFromParent());
    }
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && type == Worm.incoming) {
      gameRef.overlays.remove("controller");
      other
        ..current = PlayerState.idle
        ..behavior.horizontalMovement = 0;
      gameRef.overlays.addEntry("wormHole", (_, game) {
        return GameActivityOverlayButton(
            onTap: () {
              gameRef.overlays.remove("wormHole");
              other
                ..current = PlayerState.walking
                ..behavior.xVelocity = 45
                ..behavior.horizontalMovement = 1;
              Future.delayed(const Duration(seconds: 4), () {
                other.removeFromParent();
                Future.delayed(const Duration(seconds: 2), () {
                  gameRef.overlays.add("gameWon");
                  removeFromParent();
                });
              });
            },
            message: "Oh! Its a  portal, lets get into it",
            doText: "GO");
      });
      gameRef.overlays.add("wormHole");
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
