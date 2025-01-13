import 'dart:async';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/collisions/bomb_zone.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/audio.dart';
import 'package:arise_game/util/enum/projectile_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';

class ProjectileWeapon extends GameObjectAnime with HasGameRef<AriseGame> {
  final Projectile projectile;
  double damageCapacity = 0.1;
  final Vector2 posAdjust;
  ProjectileWeapon(this.projectile, this.damageCapacity, {required this.posAdjust, super.position});
  Vector2 hitBoxSize = Vector2(8, 8);

  final audioPlayer = GetIt.I.get<AudioService>();
  @override
  FutureOr<void> onLoad() {
    position = Vector2(position.x + posAdjust.x, position.y + posAdjust.y);
    animation = SpriteAnimation.fromFrameData(
        gameRef.images.fromCache(projectile.asset),
        SpriteAnimationData.sequenced(
            amount: projectile.frameCount, stepTime: projectile.blastInt / projectile.frameCount, textureSize: Vector2.all(projectile.size)));
    add(CircleHitbox(position: Vector2(projectile.size / 2, projectile.size / 2), radius: hitBoxSize.x, anchor: Anchor.center));
    add(BombingZone(this, damageCapacity, projectile));
    animationTicker?.onFrame = (frame) {
      if (frame == projectile.damageFrame) audioPlayer.playBlastSound();
    };
    Future.delayed(Duration(seconds: projectile.blastInt.toInt()), () => removeFromParent());
    return super.onLoad();
  }

  isStarted() => projectile.damageFrame < (animationTicker?.currentIndex ?? 0);

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      behavior.xVelocity = 0;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollideOnWall(GroundType type) {
    behavior.horizontalMovement = 0;
    super.onCollideOnWall(type);
  }
}
