import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/enemy/monster/monster.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:flame/components.dart';

class Skeleton extends Monster with HasGameRef<AriseGame> {
  Skeleton({required super.damagePower, required super.rewardCoins, super.faceRight, super.position})
      : super(hitBox: Vector2(30, 44), visibleRange: Vector2(300, 66));

  @override
  FutureOr<void> onLoad() {
    behavior
      ..drag = 0.005
      ..xVelocity = 35
      ..isOnGround = false;
    // debugMode = true;
    scale = Vector2(1.5, 1.5);
    lifeline = Lifeline(playerBoxWidth: 250, yPosition: height + 70, scale: Vector2(0.6, 0.6));
    final idle =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonIdle), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final attack =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonAttack), amount: 8, stepTime: 0.1, textureSize: Vector2.all(150));
    final death =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonDead), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final harm =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonHarmed), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final running =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonRun), amount: 4, stepTime: 0.1, textureSize: Vector2.all(150));
    final shield =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.skeletonRun), amount: 4, stepTime: 0.1, textureSize: Vector2.all(150));
    animations = {
      MonsterState.idle: idle,
      MonsterState.attack: attack,
      MonsterState.die: death,
      MonsterState.harm: harm,
      MonsterState.running: running,
      MonsterState.shield: shield
    };

    current = MonsterState.idle;
    return super.onLoad();
  }
}
