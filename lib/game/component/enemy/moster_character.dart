import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/component/behaviour/visible_range.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';

import 'package:get_it/get_it.dart';
import 'dart:async' as async;

class MonsterCharacter extends GroundCharacterEntity with HasGameRef<AriseGame> {
  final MonsterType monster;
  final double projectileTime;
  final int reward;
  final double damage;

  MonsterCharacter({required this.monster, required this.damage, this.reward = 20, this.projectileTime = 2, super.position, super.size})
      : super(anchor: Anchor.center, scale: Vector2(1.5, 1.5));

  late Lifeline lifeline;

  late SpriteAnimation attackAnimation;

  @override
  async.FutureOr<void> onLoad() {
    // debugMode = true;
    // behavior.isOnGround = false;
    anchor = Anchor.center;
    lifeline = Lifeline(playerBoxWidth: 250, yPosition: 65, scale: Vector2(0.6, 0.6));
    final facingRightAnimation = SpriteAnimation.fromFrameData(gameRef.images.fromCache(monster.bombing),
        SpriteAnimationData.sequenced(texturePosition: Vector2(0, 0), amount: 2, stepTime: 0.8, textureSize: Vector2(150, 150)));
    attackAnimation = SpriteAnimation.fromFrameData(
        gameRef.images.fromCache(monster.bombing),
        SpriteAnimationData.sequenced(
            texturePosition: Vector2(0, 0), amount: monster.charCount, stepTime: projectileTime / monster.charCount, textureSize: Vector2(150, 150)));
    final death = spriteAnimationSequence(image: gameRef.images.fromCache(monster.die), amount: 4, stepTime: 0.2, textureSize: Vector2.all(150));
    animations = {MonsterState.idle: facingRightAnimation, MonsterState.bombing: attackAnimation, MonsterState.die: death};
    current = MonsterState.idle;
    add(RectangleHitbox(anchor: Anchor.center, position: Vector2(width / 2, height / 2), size: Vector2(32, 50)));
    final visibleRange = VisibleRange(Vector2(500, 66));
    add(visibleRange);
    add(lifeline);
    flipHorizontallyAroundCenter();

    visibleRange.onVisibleStart = (intersects, object) {
      if (object is Player) {
        current = MonsterState.bombing;
        animationTicker?.onFrame = (index) {
          if (animationTicker?.isLastFrame == true) bomb();
        };
      }
    };

    visibleRange.onVisibleEnd = (object) {
      if (object is Player) {
        current = MonsterState.idle;
        animationTicker?.onFrame = null;
      }
    };
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && other.position.x < position.x && isFacingRight) {
      bomb();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  harmed(double damage) {
    lifeline.reduce(damage);
    if (lifeline.health == 0) {
      final playerEarnedCoin = GetIt.I.get<EarnedCoinCubit>();
      playerEarnedCoin.receivedCoin(reward);
      current = MonsterState.die;
      Future.delayed(Duration(milliseconds: (animation!.frames.first.stepTime * animation!.frames.length * 1000).toInt()), () => removeFromParent());
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if ((other is Player && other.isAttacking)) {
      harmed(other.damageCapacity);
    }
    super.onCollision(intersectionPoints, other);
  }

  void bomb() async {
    if (MonsterState.bombing != current) return;
    final bomb = ProjectileWeapon(monster.projectile, damage, posAdjust: Vector2(32, 40));
    bomb.behavior
      ..mass = 0.3
      ..isOnGround = false
      ..applyForceY(-1.5)
      ..applyForceX(40)
      ..horizontalMovement = 1;
    print(" X:${bomb.behavior.xVelocity} Y:${bomb.behavior.yVelocity}  ${bomb.behavior.horizontalMovement} ");
    await add(bomb);
  }

  @override
  void onCollideOnWall(GroundType type) {
    behavior.horizontalMovement = 0;
    super.onCollideOnWall(type);
  }

  // @override
  // Vector2 getActorPosition() => position;

  // @override
  // Size getActorSize() => Size(width, height);
}
