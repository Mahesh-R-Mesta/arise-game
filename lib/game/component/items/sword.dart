import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Sword extends GameObjectSprite with HasGameRef<AriseGame> {
  Sword({super.position}) : super(scale: Vector2(1.5, 1.5));

  @override
  FutureOr<void> onLoad() async {
    behavior
      ..isOnGround = false
      ..mass = 0.3;
    sprite = await Sprite.load(GameAssets.sword, images: gameRef.images);
    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.level.startConversation("magicalSword", gameRef, onCompete: () {
        removeFromParent();
        other.current = PlayerState.lightning;
      });
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      gameRef.level.removeTalk("magicalSword", gameRef);
    }
    super.onCollisionEnd(other);
  }
}
