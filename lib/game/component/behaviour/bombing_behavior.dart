import 'dart:async';

import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class BombingRange extends Component with CollisionCallbacks {
  double rangeX = 100;
  // late RectangleHitbox hitBox;
  @override
  FutureOr<void> onLoad() {
    debugMode = GameViewConfig.debugMode;
    final hitBox = RectangleHitbox(size: Vector2(200, 200));
    add(hitBox);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      print("Player in bombing range");
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    // hitBox.position.x = parent.x - 100;

    super.update(dt);
  }
}
