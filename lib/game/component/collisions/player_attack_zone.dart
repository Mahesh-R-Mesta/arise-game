import 'package:arise_game/game/component/helper/field_entity.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerAttackZone extends GameField with CollisionCallbacks {
  PlayerAttackZone() : super(anchor: Anchor.center);
  // final playerSize;
  @override
  void onLoad() {
    size = Vector2(30, 50);
    anchor = Anchor.center;
    debugMode = true;
    debugColor = Colors.red;
    add(RectangleHitbox(anchor: Anchor.center, size: size, position: Vector2(size.x / 2, size.y / 2)));
    super.onLoad();
  }
}
