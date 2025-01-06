import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum Worm {
  incoming,
  out;

  static Worm parse(String game) {
    if (game == "start") {
      return Worm.out;
    } else {
      return Worm.incoming;
    }
  }
}

class WormHole extends GameObjectAnime with HasGameRef<AriseGame> {
  Worm type;
  WormHole({required this.type, super.position}) : super(scale: Vector2(1.5, 1.5));

  @override
  FutureOr<void> onLoad() {
    // behavior.isOnGround = false;
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache(GameAssets.wormhole),
        SpriteAnimationData.sequenced(amount: 20, amountPerRow: 4, stepTime: 0.2, textureSize: Vector2(96, 80)));
    add(RectangleHitbox(size: Vector2(width, height), anchor: Anchor.topLeft));
    if (type == Worm.out) {
      Future.delayed(const Duration(seconds: 2), () => removeFromParent());
    }
    return super.onLoad();
  }
}
