import 'package:arise_game/game/component/helper/field_entity.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class MonsterSight extends GameField with CollisionCallbacks {
  final Vector2 parentSize;
  final Vector2 visibleRange;
  final Anchor anchor;
  final Function(Set<Vector2> intersect, PositionComponent other) inViewRang;

  MonsterSight({required this.parentSize, this.anchor = Anchor.center, required this.visibleRange, required this.inViewRang});
  @override
  void onLoad() {
    anchor = Anchor.center;
    // debugMode = true;
    add(RectangleHitbox(anchor: anchor, position: Vector2(parentSize.x / 2, parentSize.y / 2), size: visibleRange));
    super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    inViewRang.call(intersectionPoints, other);
    super.onCollisionStart(intersectionPoints, other);
  }
}
