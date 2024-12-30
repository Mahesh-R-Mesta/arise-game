import 'dart:async';

import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class JungleBoar extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<AriseGame> {
  JungleBoar({super.position, super.size});

  int damageCapacity = 10;

  bool isOnGround = false;
  double speed = 70;
  int horizontalMovement = -1;

  final assetSize = Vector2(48, 32);
  late Vector2 startPosition;
  @override
  FutureOr<void> onLoad() {
    startPosition = position.clone();
    size = Vector2(assetSize.x * 1.5, assetSize.y * 1.5);
    animation = SpriteAnimation.fromFrameData(
        gameRef.images.fromCache("character/boar_run.png"), SpriteAnimationData.sequenced(amount: 6, stepTime: 0.2, textureSize: assetSize));
    add(RectangleHitbox(size: size));
    add(Lifeline(position: position, size: Vector2(50, 5)));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (other.current == PlayerState.attack) {
      } else {
        other.attacked(this);
      }
    }

    if (other is GroundBlock) {
      if (other.type == GroundType.bottom) {
        isOnGround = true;
      }
      if (other.type == GroundType.left) {
        if (horizontalMovement == -1) {
          flipHorizontallyAroundCenter();
        }
        horizontalMovement = 1;
      }
      if (other.type == GroundType.right) {
        if (horizontalMovement == 1) {
          flipHorizontallyAroundCenter();
        }
        horizontalMovement = -1;
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    if (!isOnGround) {
      position.y = position.y + (5 * dt);
    }
    position.x = position.x + (speed * dt * horizontalMovement);
    super.update(dt);
  }
}
