import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:vector_math/vector_math_64.dart';

class GroundCollision extends CollisionBehavior<GroundBlock, Player> {
  @override
  void onCollision(Set<Vector2> intersectionPoints, GroundBlock other) {
    print("$other");

    super.onCollision(intersectionPoints, other);
  }
}
