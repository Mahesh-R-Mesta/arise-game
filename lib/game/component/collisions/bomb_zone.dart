import 'dart:async';

import 'package:arise_game/game/component/helper/field.dart';
import 'package:arise_game/game/component/items/bomb.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/src/components/position_component.dart';

class BombingZone extends GameField with CollisionCallbacks {
  final SpriteAnimationComponent parent;
  BombingZone(this.parent);

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    add(CircleHitbox(position: Vector2(30, 30), radius: 23));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    int index = parent.animationTicker?.currentIndex ?? 0;
    print(index);
    if (other is Player && index > 11) {
      other.harmedBy(parent);
    }
    super.onCollision(intersectionPoints, other);
  }
}
