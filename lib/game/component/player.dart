import 'dart:async';
import 'package:arise_game/game/component/behaviour/camera_behavior.dart';
import 'package:arise_game/game/component/behaviour/player_behavior.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/jungle_boar.dart';
import 'package:arise_game/game/component/enemy/worm_hole.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
// import 'package:arise_game/game/component/items/flame_throw.dart';
import 'package:arise_game/game/component/enemy/projectile_weapon.dart';
import 'package:arise_game/game/component/items/harm_zone.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/util/audio.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/controller.dart';
import 'package:arise_game/util/storage.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:get_it/get_it.dart';

enum PlayerState { idle, walking, running, jumping, lightning, shield, attack, attack1, attack2, neal, death }

enum PlayerCharacter {
  red(GameAssets.characterRed, GameAssets.characterRed2),
  blue(GameAssets.characterBlue, GameAssets.characterBlue2),
  purple(GameAssets.characterPurple, GameAssets.characterPurple2);

  final String asset1;
  final String asset2;
  const PlayerCharacter(this.asset1, this.asset2);
}

class Player extends GroundCharacterGroupAnime with HasGameRef<AriseGame>, KeyboardHandler {
  Player({super.position, super.size}) : super(anchor: Anchor.center);
  double damageCapacity = 1;
  late Lifeline lifeline;
  late HarmZone harmZone;

  final character = LocalStorage.instance.getPlayerCharacter;

  final playerHitBox = RectangleHitbox(size: Vector2(40, 60), position: Vector2(30, 39));
  final audioService = GetIt.I.get<AudioService>();

  @override
  FutureOr<void> onLoad() async {
    behavior
      ..xVelocity = 75
      ..drag = 0.005;
    final idleAnimation =
        spriteAnimationSequence(imagePath: character.asset1, amount: 6, amountPerRow: 6, stepTime: 0.5, textureSize: Vector2(56, 56));

    final attackAnimation = spriteAnimationSequence(
        imagePath: character.asset1, texturePosition: Vector2(0, 56), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56));
    final runningAnimation = spriteAnimationSequence(
        imagePath: character.asset1, texturePosition: Vector2(0, 56 * 2), amount: 8, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56));
    final jumpingAnimation = spriteAnimationSequence(
        imagePath: character.asset1, texturePosition: Vector2(0, 56 * 3), amount: 16, amountPerRow: 8, stepTime: 0.06, textureSize: Vector2(56, 56));
    final deathAnimation = spriteAnimationSequence(
        imagePath: character.asset1, texturePosition: Vector2(0, 56 * 6), amount: 12, amountPerRow: 8, stepTime: 0.2, textureSize: Vector2(56, 56));
    final lightningAnime = spriteAnimationSequence(
        imagePath: character.asset1, texturePosition: Vector2(0, 56 * 8), amount: 8, amountPerRow: 8, stepTime: 0.3, textureSize: Vector2(56, 56));
    final walkingAnime =
        spriteAnimationSequence(imagePath: character.asset2, amount: 10, amountPerRow: 8, stepTime: 0.2, textureSize: Vector2(56, 56));
    final attack1Animation = spriteAnimationSequence(
        imagePath: character.asset2, texturePosition: Vector2(0, 56 * 4), amount: 8, amountPerRow: 8, stepTime: 0.2, textureSize: Vector2(56, 56));
    final shieldAnimation = spriteAnimationSequence(
        imagePath: character.asset1, texturePosition: Vector2(0, 56 * 10), amount: 3, stepTime: 0.3, textureSize: Vector2(56, 56), isLoop: false);
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.attack: attackAnimation,
      PlayerState.attack1: attack1Animation,
      PlayerState.death: deathAnimation,
      PlayerState.lightning: lightningAnime,
      PlayerState.walking: walkingAnime,
      PlayerState.shield: shieldAnimation
    };
    lifeline = Lifeline(playerBoxWidth: width);
    harmZone = HarmZone(hitBoxSize: playerHitBox.position, playerSize: Vector2(getActorSize().width, getActorSize().height));
    add(PlayerBehavior());
    add(lifeline);
    add(playerHitBox);
    add(harmZone);
    // gameRef.camera.viewfinder.anchor = Anchor.topCenter;
    // gameRef.camera.follow(this);
    gameRef.camera.follow(CameraBehavior(character: this, gap: 150));
    current = PlayerState.lightning;

    return super.onLoad();
  }

  // thunderAttack() {
  //   final flameThrower = FlameThrower(adjust: Vector2(width, 50), scale: Vector2(0.7, 0.7));
  //   flameThrower.throwForce(150, dir: isFacingRight ? 1 : -1);
  // }

  void harmedBy(PositionComponent enemy, double damage, {bool playHurtingSound = true}) {
    if (enemy is ProjectileWeapon && !enemy.isStarted()) return;

    lifeline.reduce(damage);
    if (playHurtingSound) audioService.hurt();
    if (lifeline.health > 0) harmZone.blinkIt();

    if (lifeline.health == 0) {
      current = PlayerState.death;
      gameRef.overlays.remove("controller");
      Future.delayed(const Duration(seconds: 2), () {
        gameRef.overlays.add("gameLost");
        removeFromParent();
      });
    }
  }

  @override
  void onRemove() {
    audioService.stop();
    super.onRemove();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is WormHole && other.type == Worm.incoming) {
      Future.delayed(const Duration(seconds: 2), () {
        gameRef.overlays.remove("controller");
        removeFromParent();
        Future.delayed(const Duration(seconds: 2), () {
          gameRef.overlays.add("gameWon");
          other.removeFromParent();
        });
      });
    }

    if ((other is JungleBoar || other is ProjectileWeapon) && current == PlayerState.shield) {
      audioService.playShield();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  SpriteAnimation spriteAnimationSequence(
      {required String imagePath,
      required int amount,
      required double stepTime,
      required Vector2 textureSize,
      int? amountPerRow,
      Vector2? texturePosition,
      bool isLoop = true}) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache(imagePath),
        SpriteAnimationData.sequenced(
            texturePosition: texturePosition,
            amount: amount,
            amountPerRow: amountPerRow,
            stepTime: stepTime,
            textureSize: textureSize,
            loop: isLoop));
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
      horizontalMovement = 0;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollideOnWall(GroundType type) {
    if (type == GroundType.left && behavior.horizontalMovement == -1) behavior.horizontalMovement = 0;
    if (type == GroundType.right && behavior.horizontalMovement == 1) behavior.horizontalMovement = 0;
    super.onCollideOnWall(type);
  }

  @override
  Vector2 getActorPosition() => Vector2(playerHitBox.position.x + position.x, playerHitBox.position.y + position.y);

  @override
  Size getActorSize() => Size(playerHitBox.size.x, playerHitBox.size.y);
}
