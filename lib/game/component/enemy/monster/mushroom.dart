import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/enemy/monster/monster.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:flame/components.dart';

class Mushroom extends Monster with HasGameRef<AriseGame> {
  Mushroom({required super.damagePower, required super.rewardCoins, super.position}) : super(hitBox: Vector2(35, 44), visibleRange: Vector2(150, 66));

  @override
  FutureOr<void> onLoad() {
    behavior
      ..drag = 0.005
      ..xVelocity = 60
      ..mass = 0.4
      ..isOnGround = false;
    // debugMode = true;
    scale = Vector2(1.4, 1.4);
    lifeline = Lifeline(playerBoxWidth: 250, yPosition: height + 70, scale: Vector2(0.6, 0.6));
    final idle =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.mushroomIdle), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final attack =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.mushroomAttack), amount: 8, stepTime: 0.1, textureSize: Vector2.all(150));
    final death =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.mushroomDeath), amount: 4, stepTime: 0.3, textureSize: Vector2.all(150));
    final harm =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.mushroomHarmed), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final running =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.mushroomRun), amount: 8, stepTime: 0.1, textureSize: Vector2.all(150));
    animations = {
      MonsterState.idle: idle,
      MonsterState.attack: attack,
      MonsterState.die: death,
      MonsterState.harm: harm,
      MonsterState.running: running
    };

    current = MonsterState.idle;
    return super.onLoad();
  }
}
