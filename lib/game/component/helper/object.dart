import 'dart:async';
import 'package:arise_game/game/component/behaviour/object_behavior.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class GameObjectAnime extends SpriteAnimationComponent with EntityMixin, CollisionCallbacks {
  GameObjectAnime({super.position, super.size, super.scale});

  final behavior = ObjectBehavior<GameObjectAnime>();

  @override
  FutureOr<void> onLoad() {
    add(behavior);
    return super.onLoad();
  }

  // SpriteAnimation spriteAnimationSequence({
  //   required String imagePath,
  //   required int amount,
  //   required double stepTime,
  //   required Vector2 textureSize,
  //   int? amountPerRow,
  //   Vector2? texturePosition,
  // }) {
  //   return SpriteAnimation.fromFrameData(
  //       game.images.fromCache("character/char_blue.png"),
  //       SpriteAnimationData.sequenced(
  //           texturePosition: texturePosition, amount: amount, amountPerRow: amountPerRow, stepTime: stepTime, textureSize: textureSize));
  // }

  void onCollideOnWall(GroundType type) {}
}

class GameObjectAnimeGroup extends SpriteAnimationGroupComponent with EntityMixin, CollisionCallbacks {
  GameObjectAnimeGroup({super.position, super.size, super.anchor, super.scale});

  final behavior = ObjectBehavior<GameObjectAnimeGroup>();

  @override
  FutureOr<void> onLoad() {
    add(behavior);
    return super.onLoad();
  }

  void onCollideOnWall(GroundType type) {}
}
