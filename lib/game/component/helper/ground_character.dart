import 'dart:async';
import 'dart:ui';

import 'package:arise_game/game/component/behaviour/gravity_behaviour.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

abstract class GroundCharacter extends SpriteAnimationGroupComponent with EntityMixin, CollisionCallbacks {
  GroundCharacter({super.position, super.size, super.anchor, super.scale});

  bool playerOnGround = false;
  bool isFacingRight = true;
  int horizontalMovement = 0;
  double jumpForce = 0;
  bool isJumped = false;
  bool hittingLeftWall = false;
  bool hittingRightWall = false;

  @override
  FutureOr<void> onLoad() {
    add(GravityBehavior());
    return super.onLoad();
  }

  Size getActorSize();

  Vector2 getActorPosition();

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock) {
      // ground collision
      final hitBoxSize = getActorSize();
      final hitBoxPos = getActorPosition();
      if (other.type == GroundType.bottom && hitBoxPos.y + hitBoxSize.height > other.y) {
        playerOnGround = true;
      }
      if (other.type == GroundType.left) {
        hittingLeftWall = true;
      }
      if (other.type == GroundType.right) {
        hittingRightWall = true;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock) {
      final hitBoxSize = getActorSize();
      final hitBoxPos = getActorPosition();
      if (other.type == GroundType.bottom && hitBoxPos.y + hitBoxSize.height >= other.y) {
        playerOnGround = true;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is GroundBlock) {
      if (other.type == GroundType.left) {
        hittingLeftWall = false;
      }
      if (other.type == GroundType.right) {
        hittingRightWall = false;
      }
      if (other.type == GroundType.bottom) {
        // jumpForce = 0;
        playerOnGround = false;
      }
    }
    super.onCollisionEnd(other);
  }
}
