import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/component/behaviour/visible_range.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/items/flame_throw.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:async' as async;

enum MonsterState { idle, bombing }

enum Monster {
  goblin("character/Goblin/goblin.png", 12, Projectile.bomb), //Vector2(32, 40)
  flyingEye("character/Flying_eye/Attack3.png", 6, Projectile.eyeBomb),
  mushroom("character/Mushroom/Attack3.png", 11, Projectile.mushroomBomb),
  skeleton("character/Skeleton/Attack3.png", 6, Projectile.swordSwing); // Vector2(32, 80)

  final String charImage;
  final int charCount;
  final Projectile projectile;
  const Monster(this.charImage, this.charCount, this.projectile);

  static Monster parse(String name) {
    switch (name) {
      case "goblin":
        return Monster.goblin;
      case "flyingEye":
        return Monster.flyingEye;
      case "mushroom":
        return Monster.mushroom;
      case "skeleton":
        return Monster.skeleton;
      default:
        return Monster.goblin;
    }
  }
}

class MonsterCharacter extends GroundCharacterGroupAnime with HasGameRef<AriseGame> {
  final Monster monster;
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
    lifeline = Lifeline(playerBoxWidth: 250, yPosition: 65, scale: Vector2(0.6, 0.6));
    final facingRightAnimation = SpriteAnimation.fromFrameData(gameRef.images.fromCache(monster.charImage),
        SpriteAnimationData.sequenced(texturePosition: Vector2(0, 0), amount: 2, stepTime: 0.8, textureSize: Vector2(150, 150)));
    attackAnimation = SpriteAnimation.fromFrameData(
        gameRef.images.fromCache(monster.charImage),
        SpriteAnimationData.sequenced(
            texturePosition: Vector2(0, 0), amount: monster.charCount, stepTime: projectileTime / monster.charCount, textureSize: Vector2(150, 150)));
    animations = {MonsterState.idle: facingRightAnimation, MonsterState.bombing: attackAnimation};
    current = MonsterState.idle;
    add(RectangleHitbox(
      position: Vector2((width / 2) - 16, 60),
      size: Vector2(32, 80),
    ));

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
      final playerEarnedCoin = GetIt.I.get<EarnedCoin>();
      playerEarnedCoin.receivedCoin(reward);
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if ((other is Player && other.current == PlayerState.attack)) {
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

  // void faceShift() {
  //   if (isFacingRight) {
  //     flipHorizontallyAroundCenter();
  //     bomb();
  //     isFacingRight = false;
  //   } else {
  //     flipHorizontallyAroundCenter();
  //     bomb();
  //     isFacingRight = true;
  //   }
  // }

  @override
  void onCollideOnWall(GroundType type) {
    behavior.horizontalMovement = 0;
    super.onCollideOnWall(type);
  }

  @override
  Vector2 getActorPosition() => position;

  @override
  Size getActorSize() => Size(width, height);

  @override
  void update(double dt) {
    super.update(dt);
  }
}
