import 'package:arise_game/game/component/helper/field_entity.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlayerAttackZone extends GameField with CollisionCallbacks {
  final bool Function() isAttacking;
  PlayerAttackZone({required this.isAttacking, super.size}) : super(anchor: Anchor.center);
  // final playerSize;
  @override
  void onLoad() {
    add(RectangleHitbox(anchor: Anchor.center, size: Vector2(43, 70), position: Vector2(size.x + 20, size.y + 15)));
    super.onLoad();
  }
}
