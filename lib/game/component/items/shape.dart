import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class GameShop extends GameObjectAnime with HasGameRef<AriseGame> {
  GameShop({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache("background/decorations/shop_anim.png"),
        SpriteAnimationData.sequenced(amount: 6, stepTime: 0.3, textureSize: Vector2(118, 128)));

    add(RectangleHitbox(size: size));
    return super.onLoad();
  }
}
