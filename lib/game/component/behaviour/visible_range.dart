import 'dart:async';

import 'package:arise_game/game/component/helper/field.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class VisibleRange extends GameField with CollisionCallbacks {
  Function(Set<Vector2> intersectionPoints, PositionComponent other)? onVisible;
  Function(Set<Vector2> intersectionPoints, PositionComponent other)? onVisibleStart;
  Function(PositionComponent other)? onVisibleEnd;
  final Vector2 rangeSize;
  VisibleRange(this.rangeSize);

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    add(RectangleHitbox(size: rangeSize, position: Vector2(0, 10)));
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    onVisibleStart?.call(intersectionPoints, other);
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    onVisibleEnd?.call(other);

    super.onCollisionEnd(other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    onVisible?.call(intersectionPoints, other);
    super.onCollision(intersectionPoints, other);
  }
}
