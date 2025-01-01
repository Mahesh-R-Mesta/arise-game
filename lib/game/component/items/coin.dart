import 'dart:async';

import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/arise_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';

class Coin extends SpriteAnimationComponent with HasGameRef<AriseGame>, CollisionCallbacks {
  final int price;
  Coin({super.position, super.size, required this.price});

  final earnedCoin = GetIt.I.get<EarnedCoin>();

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      earnedCoin.receivedCoin(price);
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(gameRef.images.fromCache("coins.png"),
        SpriteAnimationData.sequenced(amount: 6, amountPerRow: 6, stepTime: 0.3, textureSize: Vector2.all(200)));
    add(RectangleHitbox(size: size));
    return super.onLoad();
  }
}
