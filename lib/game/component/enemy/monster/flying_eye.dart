import 'dart:async' as async;
import 'dart:math';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/enemy/monster/monster.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:flame/components.dart';

class FlyingEye extends Monster with HasGameRef<AriseGame> {
  FlyingEye({required super.damagePower, required super.rewardCoins, super.position, super.faceRight})
      : super(visibleRange: Vector2.all(200), hitBox: Vector2(35, 35));

  final flightHeight = 250.0;

  @override
  async.FutureOr<void> onLoad() {
    debugMode = false;
    behavior.isOnGround = true;
    scale = Vector2(1.5, 1.5);
    lifeline = Lifeline(playerBoxWidth: 250, yPosition: height + 70, scale: Vector2(0.6, 0.6));
    final flying = spriteAnimationSequence(
        image: gameRef.images.fromCache(EnemyAssets.flyingEyeFlight), amount: 8, stepTime: 0.2, textureSize: Vector2.all(150));
    final attack = spriteAnimationSequence(
        image: gameRef.images.fromCache(EnemyAssets.flyingEyeAttack), amount: 8, stepTime: 0.1, textureSize: Vector2.all(150));
    final harmed = spriteAnimationSequence(
        image: gameRef.images.fromCache(EnemyAssets.flyingEyeHarmed), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    final death =
        spriteAnimationSequence(image: gameRef.images.fromCache(EnemyAssets.flyingEyeDeath), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    animations = {
      MonsterState.idle: flying,
      MonsterState.attack: attack,
      MonsterState.die: death,
      MonsterState.harm: harmed,
      MonsterState.running: flying
    };
    current = MonsterState.running;
    takeARound();
    return super.onLoad();
  }

  async.Timer? guarding;
  takeARound() {
    guarding = async.Timer.periodic(Duration(milliseconds: Random().nextInt(2000) + 100), (_) {
      if (isFacingRight) {
        turnLeft();
        moveLeft();
      } else {
        turnRight();
        moveRight();
      }
    });
  }

  Vector2? target;

  @override
  viewRange(Set<Vector2> intersect, PositionComponent other) {
    if (other is Player) {
      guarding?.cancel();
      target = intersect.first;
      super.viewRange(intersect, other);
    }
  }

  @override
  onHarmed() {
    target = null;
  }

  fly() {
    if (current == MonsterState.die) {
      behavior.applyForceY(1);
      return;
    }
    if (target == null) {
      if (position.y > flightHeight) {
        behavior.applyForceY(-1);
        behavior.isOnGround = false;
      }
    } else {
      if (position.y > target!.y) {
        behavior.applyForceY(-0.5);
      }
    }
  }

  @override
  void update(double dt) {
    fly();
    super.update(dt);
  }
}
