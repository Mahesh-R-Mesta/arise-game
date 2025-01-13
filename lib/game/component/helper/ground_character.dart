import 'dart:async';

import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:flame/components.dart';

abstract class GroundCharacterEntity extends GameObjectAnimeGroup {
  GroundCharacterEntity({this.jumpForce = 0, super.position, super.size, super.anchor, super.scale});

  bool isOnGround = false;
  bool isFacingRight = true;
  double jumpForce = 0;
  bool isJumped = false;

  bool hittingLeftWall = false;
  bool hittingRightWall = false;

  @override
  FutureOr<void> onLoad() {
    behavior.isOnGround = false;
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock) {
      if (other.type == GroundType.left) {
        hittingLeftWall = true;
      }
      if (other.type == GroundType.right) {
        hittingRightWall = true;
      }
      if (other.type == GroundType.bottom) {
        // jumpForce = 0;
        behavior.isOnGround = true;
      }
    }
    super.onCollision(intersectionPoints, other);
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
        behavior.isOnGround = false;
      }
    }
    super.onCollisionEnd(other);
  }
}
