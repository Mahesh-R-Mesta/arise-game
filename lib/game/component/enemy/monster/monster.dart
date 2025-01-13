import 'dart:async';

import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/monster/moster_view.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';

class Monster extends GroundCharacterEntity {
  final double damagePower;
  final int rewardCoins;
  final Vector2 hitBox;
  final Vector2 visibleRange;

  bool activeFollow = false;

  Monster(
      {required this.damagePower,
      required this.rewardCoins,
      required this.visibleRange,
      required this.hitBox,
      super.position,
      super.size,
      super.anchor,
      super.scale});

  late Lifeline lifeline;
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;

    add(lifeline);
    current = MonsterState.idle;
    add(RectangleHitbox(anchor: Anchor.center, position: Vector2(width / 2, (height / 2) + 6), size: hitBox));
    add(MonsterSight(inViewRang: _viewRange, visibleRange: visibleRange, parentSize: size));
    return super.onLoad();
  }

  _viewRange(Set<Vector2> intersect, PositionComponent other) {
    if (other is Player) {
      if (other.position.x > position.x) {
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = MonsterState.running;
        behavior
          ..applyForceX(70)
          ..horizontalMovement = 1;
      } else {
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = MonsterState.running;
        behavior
          ..applyForceX(70)
          ..horizontalMovement = -1;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      behavior.horizontalMovement = 0;
      if (other.current != PlayerState.attack && current != MonsterState.die) {
        current = MonsterState.attack;
        if (animationTicker!.currentIndex > 5) {
          other.harmedBy(this, damagePower);
        }
      } else {
        if (MonsterState.die == current) return super.onCollision(intersectionPoints, other);
        current = MonsterState.harm;
        harmed(other.damageCapacity * 0.5);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollideOnWall(GroundType type) async {
    if ([GroundType.left, GroundType.right].contains(type)) {
      final dir = behavior.horizontalMovement;
      behavior.horizontalMovement = 0;
      behavior
        ..applyForceY(-3.7)
        ..isOnGround = false;
      await Future.delayed(const Duration(milliseconds: 100));
      behavior.horizontalMovement = dir;
    }
    super.onCollideOnWall(type);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player && current != MonsterState.die) {
      if (!activeFollow) {
        current = MonsterState.idle;
      } else {
        current = MonsterState.idle;
      }
    }
    super.onCollisionEnd(other);
  }

  void harmed(double damageCapacity) {
    lifeline.reduce(damageCapacity);
    final playerEarnedCoin = GetIt.I.get<EarnedCoinCubit>();
    if (lifeline.health == 0) {
      playerEarnedCoin.receivedCoin(rewardCoins);
      current = MonsterState.die;
      Future.delayed(Duration(milliseconds: (animation!.frames.first.stepTime * animation!.frames.length * 1000).toInt()), () => removeFromParent());
    }
  }
}
