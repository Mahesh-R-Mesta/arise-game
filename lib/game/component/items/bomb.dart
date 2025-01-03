import 'dart:async';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/collisions/bomb_zone.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/helper/object.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bomb extends GameObjectAnime with HasGameRef<AriseGame> {
  double damageCapacity = 0.1;

  final double timer;
  Vector2 posAdjust;
  Bomb(this.timer, {required this.posAdjust, super.position});
  Vector2 hitBoxSize = Vector2(8, 8);
  @override
  FutureOr<void> onLoad() {
    position = Vector2(position.x + posAdjust.x, position.y + posAdjust.y);
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache("character/bombing.png"),
        SpriteAnimationData.sequenced(amount: 19, stepTime: timer / 19, textureSize: Vector2.all(100)));
    add(RectangleHitbox(position: Vector2(48, 48), size: hitBoxSize));
    add(BombingZone(this));
    Future.delayed(Duration(seconds: timer.toInt()), () => removeFromParent());
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      behavior.xVelocity = 0;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollideOnWall(GroundType type) {
    behavior.horizontalMovement = 0;
    super.onCollideOnWall(type);
  }
}
