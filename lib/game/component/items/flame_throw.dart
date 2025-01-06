import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/jungle_boar.dart';
import 'package:arise_game/game/component/enemy/moster_character.dart';
import 'package:arise_game/game/component/helper/object.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class FlameThrower extends GameObjectAnime with HasGameRef<AriseGame> {
  double damageCapacity = 30;
  Vector2 adjust;
  FlameThrower({required this.adjust, super.position, super.scale});

  @override
  FutureOr<void> onLoad() {
    position = Vector2(position.x + adjust.x, position.y + adjust.y);
    debugMode = true; //GameViewConfig.debugMode;
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache("flame_thrower.png"),
        SpriteAnimationData.sequenced(amount: 7, amountPerRow: 3, stepTime: 0.1, textureSize: Vector2(96, 48)));
    add(RectangleHitbox());
    Future.delayed(const Duration(seconds: 2), () {
      if (!isRemoved) removeFromParent();
    });
    return super.onLoad();
  }

  throwForce(double force, {int dir = 1}) {
    if (dir == 1) {
      flipHorizontallyAroundCenter();
    }
    behavior
      ..isOnGround = true
      ..horizontalMovement = dir
      ..applyForceX(force);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is MonsterCharacter) {
      other.harmed(damageCapacity);
      removeFromParent();
    }
    if (other is JungleBoar) {
      other.harmed(damageCapacity);
      removeFromParent();
    }
    if (other is GroundBlock) {
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
