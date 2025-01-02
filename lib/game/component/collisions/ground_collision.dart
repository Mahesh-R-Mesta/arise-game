import 'dart:async';

import 'package:arise_game/game/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/src/components/position_component.dart';
import 'package:leap/leap.dart';
import 'package:vector_math/vector_math_64.dart';

enum GroundType {
  bottom("ground"),
  left("leftGroundWall"),
  right("rightGroundWall");

  final String type;
  const GroundType(this.type);
  static GroundType parse(String type) {
    if (GroundType.right.type == type) {
      return GroundType.right;
    } else if (GroundType.left.type == type) {
      return GroundType.left;
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
    debugMode = GameViewConfig.groundDebugMode;
    add(RectangleHitbox());
    return super.onLoad();
  }
}
