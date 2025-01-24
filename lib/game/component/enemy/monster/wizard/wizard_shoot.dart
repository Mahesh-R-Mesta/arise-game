import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/enum/wizard_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class WizardShoot extends GameObjectAnime with HasGameRef<AriseGame> {
  WizardShoot({super.position}) : super(scale: Vector2(1.2, 1.2));
  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache(WizardState.attack.asset),
        SpriteAnimationData.sequenced(texturePosition: Vector2(80, 80 * 3), amount: 2, stepTime: 0.1, textureSize: Vector2.all(80)));

    add(RectangleHitbox(anchor: Anchor.center, position: Vector2.all(size.x / 2), size: Vector2(30, 10)));
    return super.onLoad();
  }

  @override
  void onCollideOnWall(GroundType type) {
    removeFromParent();
    super.onCollideOnWall(type);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) other.harmedBy(this, 1.5);
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) removeFromParent();
    super.onCollisionEnd(other);
  }
}
