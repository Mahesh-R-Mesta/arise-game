import 'dart:async';

import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/src/components/position_component.dart';
import 'package:leap/leap.dart';
import 'package:vector_math/vector_math_64.dart';

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
    add(RectangleHitbox());
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
    super.onCollisionEnd(other);
  }
}
