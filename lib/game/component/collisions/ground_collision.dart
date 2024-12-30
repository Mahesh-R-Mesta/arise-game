import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';

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

class GroundBlock extends RectangleComponent with EntityMixin {
  final GroundType type;
  GroundBlock({required this.type, super.size, super.position}) : super(paint: Paint()..color = Colors.transparent);

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    add(RectangleHitbox());
    return super.onLoad();
  }
}
