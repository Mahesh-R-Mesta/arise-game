import 'dart:async';

import 'package:arise_game/game/component/behaviour/gravity_behaviour.dart';
import 'package:arise_game/game/component/behaviour/ground_collision_behaviour.dart';
import 'package:arise_game/game/component/behaviour/player_behavior.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/jungle_boar.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/services/hardware_keyboard.dart';

enum PlayerState { idle, running, jumping, attack, death }

class Player extends SpriteAnimationGroupComponent with HasGameRef<AriseGame>, KeyboardHandler, EntityMixin, CollisionCallbacks {
  Player({super.position, super.size}) : super(anchor: Anchor.center);

  bool playerOnGround = false;
  bool isFacingRight = true;
  int horizontalMovement = 0;
  double jumpForce = 0;
  bool isJumped = false;
  bool hittingLeftWall = false;
  bool hittingRightWall = false;

  final playerHitBox = RectangleHitbox(size: Vector2(40, 60), position: Vector2(30, 39));

  Vector2 get hitBoxPos => Vector2(playerHitBox.position.x + position.x, playerHitBox.position.y + position.y);
  Size get hitBoxSize => Size(playerHitBox.size.x, playerHitBox.size.y);

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

    add(GravityBehavior());
    add(GroundCollision());
    add(PlayerBehavior());
    add(Lifeline(position: position, size: Vector2(50, 5)));
    add(playerHitBox);
    gameRef.camera.follow(this);
    current = PlayerState.idle;

    return super.onLoad();
  }

  void attacked(PositionComponent enemy) {
    if (enemy is JungleBoar) {
      // enemy.damageCapacity
      // current = PlayerState.death;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock) {
      // ground collision
      if (other.type == GroundType.bottom && hitBoxPos.y + hitBoxSize.height > other.y) {
        playerOnGround = true;
      }
      if (other.type == GroundType.left) {
        hittingLeftWall = true;
      }
      if (other.type == GroundType.right) {
        hittingRightWall = true;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock) {
      if (other.type == GroundType.bottom && hitBoxPos.y + hitBoxSize.height >= other.y) {
        playerOnGround = true;
      }
      // if (other.type == GroundType.left) {
      //   if (other.x + other.width >= hitBoxPos.x - hitBoxSize.width) {
      //     hittingLeftWall = true;
      //   }
      // }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is GroundBlock) {
      if (other.type == GroundType.left) {
        hittingLeftWall = false;
      }
      if (other.type == GroundType.right) {
        hittingRightWall = false;
      }
      if (other.type == GroundType.bottom) {
        // jumpForce = 0;
        playerOnGround = false;
      }
    }
    super.onCollisionEnd(other);
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
}
