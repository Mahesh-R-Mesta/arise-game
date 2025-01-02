import 'dart:async';

import 'package:arise_game/game/component/behaviour/camera_behavior.dart';
import 'package:arise_game/game/component/behaviour/gravity_behaviour.dart';
import 'package:arise_game/game/component/behaviour/ground_collision_behaviour.dart';
import 'package:arise_game/game/component/behaviour/player_behavior.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/jungle_boar.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/items/harm_zone.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/items/shape.dart';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/utils/audio.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:get_it/get_it.dart';

enum PlayerState { idle, running, jumping, attack, death }

class Player extends GroundCharacter with HasGameRef<AriseGame>, KeyboardHandler {
  Player({super.position, super.size}) : super(anchor: Anchor.center);
  double damageCapacity = 1;
  late Lifeline lifeline;
  late HarmZone harmZone;

  final playerHitBox = RectangleHitbox(size: Vector2(40, 60), position: Vector2(30, 39));
  final audioService = GetIt.I.get<AudioService>();

  @override
  FutureOr<void> onLoad() async {
    final idleAnimation = spriteAnimationSequence(amount: 6, amountPerRow: 6, stepTime: 0.5, textureSize: Vector2(56, 56));
    final attackAnimation =
        spriteAnimationSequence(texturePosition: Vector2(0, 56), amount: 6, amountPerRow: 6, stepTime: 0.1, textureSize: Vector2(56, 56));
    final runningAnimation =
        spriteAnimationSequence(texturePosition: Vector2(0, 56 * 2), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56));
    final jumpingAnimation =
        spriteAnimationSequence(texturePosition: Vector2(0, 56 * 3), amount: 16, amountPerRow: 8, stepTime: 0.2, textureSize: Vector2(56, 56));
    final deathAnimation =
        spriteAnimationSequence(texturePosition: Vector2(0, 56 * 5), amount: 16, amountPerRow: 8, stepTime: 0.2, textureSize: Vector2(56, 56));
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.attack: attackAnimation,
      PlayerState.death: deathAnimation
    };
    lifeline = Lifeline(playerBoxWidth: width);
    harmZone = HarmZone(hitBoxSize: playerHitBox.position, playerSize: Vector2(getActorSize().width, getActorSize().height));
    add(PlayerBehavior());
    add(lifeline);
    add(playerHitBox);
    add(harmZone);
    gameRef.camera.follow(CameraBehavior(character: this, gap: 150));
    current = PlayerState.idle;
    return super.onLoad();
  }

  void harmedBy(PositionComponent enemy) {
    if (enemy is JungleBoar) {
      lifeline.reduce(enemy.damageCapacity);
      audioService.hurt();
      harmZone.blinkIt();
      if (lifeline.health == 0) {
        current = PlayerState.death;
        gameRef.overlays.remove("controller");
        Future.delayed(const Duration(seconds: 2), () {
          gameRef.overlays.add("gameLost");
          removeFromParent();
        });
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GameShop) {
      Future.delayed(const Duration(seconds: 2), () {
        gameRef.overlays
          ..remove("controller")
          ..add("gameWon");
      });
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  SpriteAnimation spriteAnimationSequence({
    required int amount,
    required double stepTime,
    required Vector2 textureSize,
    int? amountPerRow,
    Vector2? texturePosition,
  }) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache("character/char_blue.png"),
        SpriteAnimationData.sequenced(
            texturePosition: texturePosition, amount: amount, amountPerRow: amountPerRow, stepTime: stepTime, textureSize: textureSize));
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space) && playerOnGround) {
      current = PlayerState.jumping;
      jumpForce = 4;
      isJumped = true;
      playerOnGround = false;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) && !hittingRightWall) {
      if (current != PlayerState.jumping) current = PlayerState.running;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
      horizontalMovement = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
      current = PlayerState.attack;
      horizontalMovement = 0;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyA) && !hittingLeftWall) {
      if (current != PlayerState.jumping) current = PlayerState.running;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
      horizontalMovement = -1;
    } else {
      current = PlayerState.idle;
      horizontalMovement = 0;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  Vector2 getActorPosition() => Vector2(playerHitBox.position.x + position.x, playerHitBox.position.y + position.y);

  @override
  Size getActorSize() => Size(playerHitBox.size.x, playerHitBox.size.y);
}
