import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class GroundCollision extends CollisionBehavior<GroundBlock, GroundCharacterEntity> {
  @override
  void onCollision(Set<Vector2> intersectionPoints, GroundBlock other) {
    print("$other");

    super.onCollision(intersectionPoints, other);
  }
}
