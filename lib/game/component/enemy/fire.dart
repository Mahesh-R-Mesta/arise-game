import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Fire extends GameObjectAnime with HasGameRef<AriseGame> {
  Fire({super.position});
  final double damageCapacity = 1;
  @override
  FutureOr<void> onLoad() {
    behavior.isOnGround = GameViewConfig.debugMode;
    debugMode = GameViewConfig.debugMode;
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache(GameAssets.fire),
        SpriteAnimationData.sequenced(amount: 19, amountPerRow: 4, stepTime: 0.1, textureSize: Vector2.all(96)));
    add(RectangleHitbox(position: Vector2(96 / 2, 96 / 2), size: Vector2(32, 53), anchor: Anchor.topCenter));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      other.harmedBy(this, damageCapacity);
    }
    super.onCollision(intersectionPoints, other);
  }
}
