import 'dart:async';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/enemy/monster/monster.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:arise_game/util/enum/projectile_enum.dart';
import 'package:flame/components.dart';

class Goblin extends Monster with HasGameRef<AriseGame> {
  final bool bombing;
  final bool takeAround;
  Goblin(
      {required super.damagePower,
      required super.rewardCoins,
      this.takeAround = false,
      this.bombing = false,
      super.faceRight,
      super.position,
      super.size,
      super.scale})
      : super(anchor: Anchor.center, hitBox: Vector2(30, 44), visibleRange: Vector2(250, 66), projectileRange: bombing ? Vector2(550, 66) : null);

  // final damagePower = 2.0;
  // final rewardPoint = 40;

  @override
  FutureOr<void> onLoad() {
    behavior
      ..drag = 0.005
      ..xVelocity = 60
      ..isOnGround = false;
    // debugMode = true;
    scale = Vector2(1.5, 1.5);
    lifeline = Lifeline(playerBoxWidth: 250, yPosition: height + 70, scale: Vector2(0.6, 0.6));
    final idle =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.goblinIdle), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final attack = spriteAnimationSequence(
        image: gameRef.images.fromCache(EnemyAssets.goblinSwordAttack), amount: 8, stepTime: 0.1, textureSize: Vector2.all(150));
    final death =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.goblinDie), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final harm =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.goblinHarm), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final running =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.goblinRun), amount: 8, stepTime: 0.1, textureSize: Vector2.all(150));
    final bombing = spriteAnimationSequence(
        image: gameRef.images.fromCache(EnemyAssets.goblinBombingThrow), amount: 12, stepTime: 0.1, textureSize: Vector2(150, 150));
    animations = {
      MonsterState.idle: idle,
      MonsterState.attack: attack,
      MonsterState.die: death,
      MonsterState.harm: harm,
      MonsterState.running: running,
      MonsterState.bombing: bombing
    };
    if (takeAround) takeARound(1000);
    return super.onLoad();
  }

  @override
  ProjectileWeapon? getProjectile() {
    final bomb = ProjectileWeapon(Projectile.bomb, 1.1, posAdjust: Vector2(32, 40));
    bomb.behavior
      ..mass = 0.3
      ..isOnGround = false
      ..applyForceY(-1.5)
      ..applyForceX(40)
      ..horizontalMovement = 1;
    return bomb;
  }

  @override
  double runSpeed() => 60;

  @override
  double walkSpeed() => 40;
}
