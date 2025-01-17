import 'dart:async' as async;
import 'dart:math';

import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/monster/moster_view.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';

abstract class Monster extends GroundCharacterEntity {
  final double damagePower;
  final int rewardCoins;
  final Vector2 hitBox;
  final Vector2 visibleRange;
  final Vector2? projectileRange;

  bool activeFollow = false;

  int hit = 0;
  int hitLimit = 30;

  bool faceRight;

  Monster(
      {required this.damagePower,
      required this.rewardCoins,
      required this.visibleRange,
      required this.hitBox,
      this.projectileRange,
      this.faceRight = true,
      super.position,
      super.size,
      super.anchor,
      super.scale});

  late Lifeline lifeline;
  @override
  async.FutureOr<void> onLoad() {
    anchor = Anchor.center;
    debugMode = GameViewConfig.monsterDebug;
    add(lifeline);
    if (!faceRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
    current = MonsterState.idle;
    add(RectangleHitbox(anchor: Anchor.center, position: Vector2(width / 2, (height / 2) + 6), size: hitBox));
    add(MonsterSight(inViewRang: viewRange, visibleRange: visibleRange, parentSize: size));
    if (projectileRange != null) add(MonsterSight(inViewRang: projectileAlert, visibleRange: projectileRange!, parentSize: size));
    return super.onLoad();
  }

  projectileAlert(Set<Vector2> intersect, PositionComponent other) {
    if (other is Player) {
      if (!animations!.containsKey(MonsterState.bombing)) return;
      current = MonsterState.bombing;
      animationTicker?.onFrame = (index) {
        if (animationTicker?.isLastFrame == true) {
          throwProjectile();
        }
      };
    }
  }

  ProjectileWeapon? getProjectile() => null;

  void throwProjectile() async {
    if (MonsterState.bombing != current) return;
    final bomb = getProjectile();
    if (bomb == null) return;
    // bomb.behavior
    //   ..mass = 0.3
    //   ..isOnGround = false
    //   ..applyForceY(-1.5)
    //   ..applyForceX(40)
    //   ..horizontalMovement = 1;
    print(" X:${bomb.behavior.xVelocity} Y:${bomb.behavior.yVelocity}  ${bomb.behavior.horizontalMovement} ");
    await add(bomb);
  }

  turnLeft() {
    if (isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
  }

  async.Timer? guardingWalk;
  takeARound() {
    guardingWalk = async.Timer.periodic(Duration(milliseconds: Random().nextInt(2000) + 800), (_) {
      if (isFacingRight) {
        turnLeft();
        moveLeft();
      } else {
        turnRight();
        moveRight();
      }
    });
  }

  moveLeft() {
    current = MonsterState.running;
    behavior
      ..applyForceX(60)
      ..horizontalMovement = -1;
  }

  turnRight() {
    if (!isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
  }

  moveRight() {
    current = MonsterState.running;
    behavior
      ..applyForceX(60)
      ..horizontalMovement = 1;
  }

  viewRange(Set<Vector2> intersect, PositionComponent other) {
    if (other is Player) {
      animationTicker?.onFrame = null;
      if (other.position.x > position.x) {
        turnRight();
        if (isPlayerHittingWall) return;
        moveRight();
      } else {
        turnLeft();
        if (isPlayerHittingWall) return;
        moveLeft();
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
        // }
        // else if (other.isFacingRight == isFacingRight && other.current != PlayerState.attack) {
        //   final bothOpposite = isFacingRight ? position.y > other.position.y : position.y < other.position.y;
        //   if (bothOpposite) {
        //     current = MonsterState.attack;
        //     if (animationTicker!.currentIndex > 5) {
        //       other.harmedBy(this, damagePower);
        //     }
        //   }
      } else {
        if (MonsterState.die == current) return super.onCollision(intersectionPoints, other);
        current = MonsterState.harm;
        onHarmed();
        harmed(other.damageCapacity * 0.5);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void onHarmed() {}

  moveAside() async {
    behavior.horizontalMovement = isFacingRight ? -1 : 1;
    current = MonsterState.running;
    await Future.delayed(const Duration(seconds: 1), () {
      behavior.horizontalMovement = 0;
      current = MonsterState.idle;
    });
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
      if (!isPlayerHittingWall) {
        if (dir != 0) {
          behavior.horizontalMovement = dir;
        } else {
          behavior.horizontalMovement = isFacingRight ? 1 : -1;
        }
      }
    }
    super.onCollideOnWall(type);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (other.position.x > position.x) {
        turnRight();
      } else {
        turnLeft();
      }
    }
    super.onCollisionStart(intersectionPoints, other);
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
