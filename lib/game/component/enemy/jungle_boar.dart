import 'dart:async';

import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
// import 'package:arise_game/game/component/collisions/player_attack_zone.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/items/harm_zone.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/util/audio.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';

enum Boar {
  normal("character/boar_run.png", "character/boar_death.png"),
  medium("character/boar_run_2.png", "character/boar_death_2.png"),
  danger("character/boar_run_3.png", "character/boar_death_3.png");

  final String runAsset;
  final String deathAsset;
  const Boar(this.runAsset, this.deathAsset);
}

class JungleBoar extends GroundCharacterEntity with HasGameRef<AriseGame> {
  final Boar boar;
  final double damageCapacity;
  final int damageReward;
  double speed; // = 70;
  JungleBoar({required this.boar, required this.damageCapacity, required this.damageReward, required this.speed, super.position, super.size});

  late Lifeline lifeline;
  late HarmZone harmZone;

  final assetSize = Vector2(48, 32);
  final playerEarnedCoin = GetIt.I.get<EarnedCoinCubit>();
  final audioPlayer = GetIt.I.get<AudioService>();
  int angryHitCount = 0;

  @override
  FutureOr<void> onLoad() {
    isFacingRight = false;
    behavior.xVelocity = speed;
    behavior.horizontalMovement = -1;
    size = Vector2(assetSize.x * 1.5, assetSize.y * 1.5);
    lifeline = Lifeline(playerBoxWidth: width);
    final runningAnimation = SpriteAnimation.fromFrameData(
        gameRef.images.fromCache(boar.runAsset), SpriteAnimationData.sequenced(amount: 6, stepTime: 0.2, textureSize: assetSize));
    final deathAnimation = SpriteAnimation.fromFrameData(
        gameRef.images.fromCache(boar.deathAsset), SpriteAnimationData.sequenced(amount: 4, stepTime: 0.2, textureSize: assetSize));
    animations = {PlayerState.running: runningAnimation, PlayerState.death: deathAnimation};
    current = PlayerState.running;
    harmZone = HarmZone(playerSize: size);
    add(harmZone);
    add(RectangleHitbox(size: size));
    add(lifeline);
    return super.onLoad();
  }

  harmed(double damage) {
    lifeline.reduce(damage);
    harmZone.blinkIt();
    if (lifeline.health == 0) death();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    // if (other is PlayerAttackZone && other.isAttacking()) {
    //   angryHitCount += 1;
    //   harmed(1.1 * 15);
    // }
    if (other is Player) {
      if (isFacingRight != other.isFacingRight) {
        if (other.isAttacking) {
          angryHitCount += 1;
          harmed(other.damageCapacity * 15);
          if (angryHitCount == 2) {
            audioPlayer.playRoarBoar();
            harmed(other.damageCapacity * 15);
            angryHitCount = 0;
          } else {
            if (isFacingRight) {
              turnLeft(); // if right facing it turn to left
            } else {
              turnRight(); // if left facing it turn to right
            }
          }
        } else if (other.current == PlayerState.shield) {
          if (other.isFacingRight != isFacingRight) {
            if (isFacingRight) {
              turnLeft(); // if right facing it turn to left
            } else {
              turnRight(); // if left facing it turn to right
            }
          }
        } else {
          other.harmedBy(this, damageCapacity * 15, playHurtingSound: true);
        }
      } else {
        other.harmedBy(this, damageCapacity * 15, playHurtingSound: true);
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (other.isAttacking) {
        audioPlayer.playRoarBoar();
        harmed(damageCapacity * 0.5);
      }
      // else if(other.current == PlayerState.shield) {
      //   other.isFacingRight && (other.position.x + other.size.x) <=
      // }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollideOnWall(GroundType type) {
    if (type == GroundType.left && !isFacingRight) turnRight();
    if (type == GroundType.right && isFacingRight) turnLeft();
    super.onCollideOnWall(type);
  }

  turnRight() {
    if (isFacingRight) return;
    flipHorizontallyAroundCenter();
    behavior.horizontalMovement = 1;
    isFacingRight = true;
  }

  turnLeft() {
    if (!isFacingRight) return;
    flipHorizontallyAroundCenter();
    behavior.horizontalMovement = -1;
    isFacingRight = false;
  }

  void death() {
    current = PlayerState.death;

    audioPlayer.boarRoarPlayer.stop();
    Future.delayed(Duration(milliseconds: 800), () {
      playerEarnedCoin.receivedCoin(damageReward);
      removeFromParent();
    });
  }

  @override
  void update(double dt) {
    position.x += (speed * dt * behavior.horizontalMovement);
    super.update(dt);
  }

  // @override
  // Vector2 getActorPosition() => position;

  // @override
  // Size getActorSize() => Size(width, height);
}
