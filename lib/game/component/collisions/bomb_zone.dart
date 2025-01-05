import 'dart:async';

import 'package:arise_game/game/component/helper/field.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class BombingZone extends GameField with CollisionCallbacks {
  final SpriteAnimationComponent parent;
  final double damageCapacity;
  final Projectile projectile;
  BombingZone(this.parent, this.damageCapacity, this.projectile);

  @override
  FutureOr<void> onLoad() async {
    debugMode = GameViewConfig.debugMode;
    add(CircleHitbox(position: Vector2(parent.height / 2, parent.width / 2), radius: 23, anchor: Anchor.center));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    int index = parent.animationTicker?.currentIndex ?? 0;
    if (other is Player && index > projectile.blastInt) {
      other.harmedBy(parent, damageCapacity);
    }
    super.onCollision(intersectionPoints, other);
  }
}
