import 'dart:async';
import 'package:arise_game/game/component/behaviour/camera_behavior.dart';
import 'package:arise_game/game/component/behaviour/player_behavior.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/collisions/player_attack_zone.dart';
import 'package:arise_game/game/component/enemy/jungle_boar.dart';
import 'package:arise_game/game/component/enemy/moster_character.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/items/harm_zone.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/util/audio.dart';
import 'package:arise_game/util/controller.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:arise_game/util/storage.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:get_it/get_it.dart';

class Player extends GroundCharacterEntity with HasGameRef<AriseGame>, KeyboardHandler {
  final double damageCapacity;
  final double runSpeed;
  Player({required super.jumpForce, required this.runSpeed, required this.damageCapacity, super.position, super.size})
      : super(anchor: Anchor.center, key: ComponentKey.named("player"));

  late Lifeline lifeline;
  late HarmZone harmZone;

  final character = LocalStorage.instance.getPlayerCharacter;
  final playerHitBox = RectangleHitbox(size: Vector2(40, 60), position: Vector2(32, 39));
  final audioService = GetIt.I.get<AudioService>();

  @override
  FutureOr<void> onLoad() async {
    debugMode = GameViewConfig.playerDebug;
    behavior
      ..xVelocity = 75
      ..drag = 0.005;
    final idleAnimation = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1), amount: 6, amountPerRow: 6, stepTime: 0.5, textureSize: Vector2(56, 56));
    final attackAnimation = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1),
        texturePosition: Vector2(0, 56),
        amount: 8,
        amountPerRow: 8,
        stepTime: 0.1,
        textureSize: Vector2(56, 56));
    final runningAnimation = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1),
        texturePosition: Vector2(0, 56 * 2),
        amount: 8,
        amountPerRow: 8,
        stepTime: 0.1,
        textureSize: Vector2(56, 56));
    final jumpingAnimation = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1),
        texturePosition: Vector2(0, 56 * 3),
        amount: 16,
        amountPerRow: 8,
        stepTime: 0.06,
        textureSize: Vector2(56, 56));
    final deathAnimation = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1),
        texturePosition: Vector2(0, 56 * 6),
        amount: 12,
        amountPerRow: 8,
        stepTime: 0.2,
        textureSize: Vector2(56, 56));
    final lightningAnime = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1),
        texturePosition: Vector2(0, 56 * 8),
        amount: 8,
        amountPerRow: 8,
        stepTime: 0.3,
        textureSize: Vector2(56, 56));
    final walkingAnime = spriteAnimationSequence(
        image: game.images.fromCache(character.asset2), amount: 10, amountPerRow: 8, stepTime: 0.2, textureSize: Vector2(56, 56));
    final attack1Animation = spriteAnimationSequence(
        image: game.images.fromCache(character.asset2),
        texturePosition: Vector2(0, 56 * 4),
        amount: 8,
        amountPerRow: 8,
        stepTime: 0.2,
        textureSize: Vector2(56, 56));
    final shieldAnimation = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1),
        texturePosition: Vector2(0, 56 * 10),
        amount: 3,
        stepTime: 0.3,
        textureSize: Vector2(56, 56),
        isLoop: false);
    final harmedAnime = spriteAnimationSequence(
        image: game.images.fromCache(character.asset1),
        texturePosition: Vector2(0, 56 * 5),
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(56, 56),
        isLoop: false);
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.attack: attackAnimation,
      PlayerState.attack1: attack1Animation,
      PlayerState.death: deathAnimation,
      PlayerState.lightning: lightningAnime,
      PlayerState.walking: walkingAnime,
      PlayerState.shield: shieldAnimation,
      PlayerState.harmed: harmedAnime
    };
    lifeline = Lifeline(playerBoxWidth: width, yPosition: 15);
    harmZone = HarmZone(hitBoxSize: playerHitBox.position, playerSize: Vector2(getActorSize().width, getActorSize().height));
    add(PlayerBehavior());
    add(lifeline);
    add(playerHitBox);
    add(harmZone);
    gameRef.camera.viewfinder.anchor = Anchor(0.3, 0.5);
    gameRef.camera.follow(CameraBehavior(character: this, game: gameRef));
    current = PlayerState.idle;
    add(PlayerAttackZone(isAttacking: () => isAttacking, size: size));
    // selfConversation();
    return super.onLoad();
  }

  bool get isAttacking => [PlayerState.attack, PlayerState.attack1, PlayerState.attack2].contains(current);

  void harmedBy(PositionComponent enemy, double damage, {bool playHurtingSound = true}) {
    if (enemy is ProjectileWeapon && !enemy.isStarted()) return;

    lifeline.reduce(damage);
    if (playHurtingSound) audioService.hurt();

    if (lifeline.health > 0) {
      harmZone.blinkIt();
    }

    if (lifeline.health == 0) {
      current = PlayerState.death;
      behavior.horizontalMovement = 0;
      gameRef.overlays.remove("controller");
      Future.delayed(const Duration(seconds: 2), () {
        gameRef.overlays.add("gameLost");
        removeFromParent();
      });
    }
  }

  @override
  void onRemove() {
    audioService.swordPlayer.stop();
    super.onRemove();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if ((other is JungleBoar || other is ProjectileWeapon) && current == PlayerState.shield) {
      audioService.playShield();
    }

    if (other is MonsterCharacter) {
      behavior.horizontalMovement = 0;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  final buttonBridge = GetIt.I.get<GameButtonBridge>();

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      buttonBridge.onJumpDown();
      // current = PlayerState.jumping;
      // jumpForce = 5;
      // isJumped = true;
      // isOnGround = false;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      buttonBridge.onMoveRightDown();
      // if (current != PlayerState.jumping) current = PlayerState.running;
      // if (!isFacingRight) {
      //   flipHorizontallyAroundCenter();
      //   isFacingRight = true;
      // }
      // horizontalMovement = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
      buttonBridge.attackDown();
      // current = PlayerState.attack;
      // horizontalMovement = 0;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyA) && !hittingLeftWall) {
      buttonBridge.onMoveLeftDown();
      // if (current != PlayerState.jumping) current = PlayerState.running;
      // if (isFacingRight) {
      //   flipHorizontallyAroundCenter();
      //   isFacingRight = false;
      // }
      // horizontalMovement = -1;
    } else {
      current = PlayerState.idle;
      // horizontalMovement = 0;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollideOnWall(GroundType type) {
    if (type == GroundType.left && behavior.horizontalMovement == -1) behavior.horizontalMovement = 0;
    if (type == GroundType.right && behavior.horizontalMovement == 1) behavior.horizontalMovement = 0;
    super.onCollideOnWall(type);
  }

  Vector2 getActorPosition() => Vector2(playerHitBox.position.x + position.x, playerHitBox.position.y + position.y);

  Size getActorSize() => Size(playerHitBox.size.x, playerHitBox.size.y);
}
