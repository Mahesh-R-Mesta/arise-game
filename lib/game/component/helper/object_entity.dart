import 'dart:async';
import 'dart:ui';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/behaviour/object_behavior.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/monster/wizard/wizard_shoot.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class GameObjectAnime extends SpriteAnimationComponent with EntityMixin, CollisionCallbacks {
  GameObjectAnime({super.position, super.size, super.scale});

  final behavior = ObjectBehavior<GameObjectAnime>();
  AriseGame? _cachedGame;

  bool get isWithinActiveViewport {
    final g = _cachedGame ??= findGame() as AriseGame?;
    if (g == null) return true;
    final camX = g.camera.viewfinder.position.x;
    if (camX == 0) return true;
    return (absolutePosition.x - camX).abs() <= g.screenSize.width * 1.3;
  }

  @override
  FutureOr<void> onLoad() {
    add(behavior);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (this is! ProjectileWeapon && this is! WizardShoot && behavior.isOnGround && !isWithinActiveViewport) return;
    super.update(dt);
  }

  SpriteAnimation spriteAnimationSequence({
    required Image image,
    required int amount,
    required double stepTime,
    required Vector2 textureSize,
    int? amountPerRow,
    Vector2? texturePosition,
  }) {
    return SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            texturePosition: texturePosition, amount: amount, amountPerRow: amountPerRow, stepTime: stepTime, textureSize: textureSize));
  }

  void onCollideOnWall(GroundType type) {}
}

class GameObjectAnimeGroup extends SpriteAnimationGroupComponent with EntityMixin, CollisionCallbacks {
  GameObjectAnimeGroup({super.position, super.size, super.anchor, super.scale, super.key});

  final behavior = ObjectBehavior<GameObjectAnimeGroup>();
  AriseGame? _cachedGame;

  bool get isWithinActiveViewport {
    final g = _cachedGame ??= findGame() as AriseGame?;
    if (g == null) return true;
    final camX = g.camera.viewfinder.position.x;
    if (camX == 0) return true;
    return (absolutePosition.x - camX).abs() <= g.screenSize.width * 1.3;
  }

  @override
  FutureOr<void> onLoad() {
    add(behavior);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (this is! Player && behavior.isOnGround && !isWithinActiveViewport) return;
    super.update(dt);
  }

  SpriteAnimation spriteAnimationSequence(
      {required Image image,
      required int amount,
      required double stepTime,
      required Vector2 textureSize,
      int? amountPerRow,
      Vector2? texturePosition,
      bool isLoop = true}) {
    return SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            texturePosition: texturePosition,
            amount: amount,
            amountPerRow: amountPerRow,
            stepTime: stepTime,
            textureSize: textureSize,
            loop: isLoop));
  }

  void onCollideOnWall(GroundType type) {}
}

class GameObjectSprite extends SpriteComponent with EntityMixin, CollisionCallbacks {
  GameObjectSprite({super.position, super.size, super.anchor, super.scale, super.key});
  final behavior = ObjectBehavior<GameObjectSprite>();

  @override
  FutureOr<void> onLoad() {
    add(behavior);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (behavior.isOnGround && behavior.horizontalMovement == 0) return;
    super.update(dt);
  }

  void onCollideOnWall(GroundType type) {}
}

