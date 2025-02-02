import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/enemy/monster/monster.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:arise_game/util/enum/projectile_enum.dart';
import 'package:flame/components.dart';

class Skeleton extends Monster with HasGameRef<AriseGame> {
  final bool projectileAttack;
  final bool takeAround;
  Skeleton(
      {required super.damagePower,
      required super.rewardCoins,
      this.projectileAttack = false,
      super.faceRight,
      super.position,
      this.takeAround = false})
      : super(hitBox: Vector2(30, 44), visibleRange: Vector2(300, 66), projectileRange: projectileAttack ? Vector2(650, 66) : null);

  @override
  FutureOr<void> onLoad() {
    behavior
      ..drag = 0.005
      ..xVelocity = 35
      ..isOnGround = false;
    debugMode = GameViewConfig.monsterDebug;
    scale = Vector2(1.5, 1.5);
    lifeline = Lifeline(playerBoxWidth: 250, yPosition: height + 70, scale: Vector2(0.6, 0.6));
    final idle =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonIdle), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final attack =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonAttack), amount: 8, stepTime: 0.1, textureSize: Vector2.all(150));
    final death = spriteAnimationSequence(
        image: gameRef.images.fromCache(EnemyAssets.skeletonDead), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150), isLoop: false);
    final harm =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonHarmed), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final running =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonRun), amount: 4, stepTime: 0.1, textureSize: Vector2.all(150));
    final shield =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonRun), amount: 4, stepTime: 0.1, textureSize: Vector2.all(150));
    final swordThrow =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonThrow), amount: 6, stepTime: 0.3, textureSize: Vector2.all(150));
    animations = {
      MonsterState.idle: idle,
      MonsterState.attack: attack,
      MonsterState.die: death,
      MonsterState.harm: harm,
      MonsterState.running: running,
      MonsterState.shield: shield,
      MonsterState.bombing: swordThrow,
    };
    if (takeAround) takeARound(1500);
    current = MonsterState.idle;
    return super.onLoad();
  }

  @override
  ProjectileWeapon? getProjectile() {
    final bomb = ProjectileWeapon(Projectile.swordSwing, 1.1, posAdjust: Vector2(32, 40));
    bomb.behavior
      ..mass = 0.3
      ..isOnGround = false
      ..applyForceY(-1.3)
      ..applyForceX(40)
      ..horizontalMovement = 1;
    return bomb;
  }

  @override
  double get resistanceOverAttack => 0.40;

  @override
  double runSpeed() => 60;

  @override
  double walkSpeed() => 40;
}
