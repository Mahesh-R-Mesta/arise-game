import 'dart:async';
import 'dart:ui';

import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/helper/object.dart';
import 'package:flame/components.dart';

abstract class GroundCharacterGroupAnime extends GameObjectAnimeGroup {
  GroundCharacterGroupAnime({super.position, super.size, super.anchor, super.scale});

  bool isOnGround = false;
  bool isFacingRight = true;
  int horizontalMovement = 0;
  double jumpForce = 0;
  bool isJumped = false;

  bool hittingLeftWall = false;
  bool hittingRightWall = false;

  @override
  FutureOr<void> onLoad() {
    behavior.isOnGround = false;
    // add(GravityBehavior());
    // add(GroundCollision());
    return super.onLoad();
  }

  Size getActorSize();

  Vector2 getActorPosition();

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
        // jumpForce = 0;
        behavior.isOnGround = false;
      }
    }
    super.onCollisionEnd(other);
  }
}
