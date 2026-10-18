import 'dart:async';

import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

enum GroundType {
  bottom("ground"),
  left("leftGroundWall"),
  right("rightGroundWall"),
  top("topFloor");

  final String type;
  const GroundType(this.type);
  static GroundType parse(String type) {
    if (GroundType.right.type == type) {
      return GroundType.right;
    } else if (GroundType.left.type == type) {
      return GroundType.left;
    } else if (GroundType.top.type == type) {
      return GroundType.top;
    } else {
      return GroundType.bottom;
    }
  }
}

class GroundBlock extends PhysicalEntity with CollisionCallbacks {
  final GroundType type;
  GroundBlock({required this.type, super.size, super.position}) : super();

  @override
  FutureOr<void> onLoad() async {
    debugMode = GameViewConfig.groundAllDebugMode;
    if (type == GroundType.bottom && GameViewConfig.onlyBottomGroundDebug) debugMode = true;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GameObjectAnime) {
      if (type == GroundType.bottom) {
        other.behavior.isOnGround = true;
        other.behavior.yVelocity = 0;
      }
      if (type == GroundType.right || type == GroundType.left) {
        other.onCollideOnWall(type);
      }
      if (type == GroundType.top) {
        other.behavior.yVelocity = 0;
      }
    }
    // ground sticking issue fixed
    if (type == GroundType.bottom && other is Player) {
      double groundLevelThreshold = (other.position.y + other.height) - position.y - 50;
      if (groundLevelThreshold > 3) {
        other.position.y -= groundLevelThreshold;
      }
    }

    if (other is GameObjectAnimeGroup) {
      if (type == GroundType.bottom) {
        other.behavior.isOnGround = true;
        other.behavior.yVelocity = 0;
      }
      if (type == GroundType.right || type == GroundType.left) {
        other.onCollideOnWall(type);
      }
      if (type == GroundType.top) {
        other.behavior.yVelocity = 0;
      }
    }

    if (other is GameObjectSprite) {
      if (type == GroundType.bottom) {
        other.behavior.isOnGround = true;
        other.behavior.yVelocity = 0;
      }
      if (type == GroundType.right || type == GroundType.left) {
        other.onCollideOnWall(type);
      }
      if (type == GroundType.top) {
        other.behavior.yVelocity = 0;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // if (type == GroundType.bottom) {
    //   if (other.position.y + other.height > po sition.y) {
    //     final diff = (other.position.y + other.height) - position.y - 1;
    //     other.position.y -= diff;
    //   }
    // }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is GameObjectAnime) {
      if (type == GroundType.bottom) other.behavior.isOnGround = false;
    }
    if (other is GameObjectAnimeGroup) {
      if (type == GroundType.bottom) other.behavior.isOnGround = false;
    }
    if (other is GameObjectSprite) {
      if (type == GroundType.bottom) other.behavior.isOnGround = false;
    }
    super.onCollisionEnd(other);
  }
}
