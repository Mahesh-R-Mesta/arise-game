import 'dart:async' as async;

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/collisions/moster_view.dart';
import 'package:arise_game/game/component/enemy/monster/wizard/wizard_shoot.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/enum/wizard_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Wizard extends GroundCharacterEntity with HasGameRef<AriseGame> {
  Wizard({super.position}) : super(scale: Vector2(0.7, 0.7), anchor: Anchor.center);

  late Lifeline lifeline;

  @override
  async.FutureOr<void> onLoad() {
    debugMode = false;
    isFacingRight = false;
    size = Vector2.all(140);
    lifeline = Lifeline(playerBoxWidth: 120, scale: Vector2(1.2, 1.2));

    final idle = spriteAnimationSequence(
        texturePosition: Vector2(80 * 4, 0),
        image: gameRef.images.fromCache(WizardState.idle.asset),
        amount: 6,
        stepTime: 0.2,
        textureSize: Vector2.all(80));
    final run = spriteAnimationSequence(
        image: gameRef.images.fromCache(WizardState.run.asset), amount: 6, stepTime: 0.1, textureSize: Vector2.all(80), isLoop: false);
    final attack = spriteAnimationSequence(
        image: gameRef.images.fromCache(WizardState.attack.asset), amountPerRow: 3, amount: 10, stepTime: 0.2, textureSize: Vector2.all(80));
    final harm =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.harm.asset), amount: 3, stepTime: 0.3, textureSize: Vector2.all(80));
    final death = spriteAnimationSequence(
        image: gameRef.images.fromCache(WizardState.die.asset), amount: 10, stepTime: 0.2, textureSize: Vector2.all(80), isLoop: false);
    animations = {
      WizardState.idle: idle,
      WizardState.attack: attack,
      WizardState.run: run,
      WizardState.die: death,
      WizardState.harm: harm,
    };
    add(lifeline);
    add(RectangleHitbox(anchor: Anchor.center, position: Vector2(size.x / 2, size.y / 2), size: Vector2(65, 120)));
    add(MonsterSight(inViewRang: viewRange, visibleRange: Vector2(600, 60), parentSize: size));
    current = WizardState.idle;

    walk();
    return super.onLoad();
  }

  onTurnRange(Set<Vector2> intersect, PositionComponent other) {}

  viewRange(Set<Vector2> intersect, PositionComponent other) async {
    if (other is Player) {
      guardingWalk?.cancel();
      behavior.horizontalMovement = 0;
      current = WizardState.idle;
      await conversation();
      if (other.position.x > position.x) {
        turnRight();
      } else {
        turnLeft();
      }
      current = WizardState.attack;
      animationTicker?.onFrame = (index) {
        if (index == 9) {
          final shoot = WizardShoot(position: Vector2(-7, 30));
          shoot.behavior
            ..xVelocity = 200
            ..horizontalMovement = -1; //isFacingRight ? 1 : -1;
          add(shoot);
        }
      };
    }
  }

  moveLeft() {
    current = WizardState.run;
    behavior
      ..applyForceX(50)
      ..horizontalMovement = -1;
  }

  turnRight() {
    if (!isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
  }

  turnLeft() {
    if (isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
  }

  moveRight() {
    current = WizardState.run;
    behavior
      ..applyForceX(50)
      ..horizontalMovement = 1;
  }

  bool isConversationComplete = false;
  conversation() async {
    if (isConversationComplete) return;
    final completer = async.Completer();
    gameRef.level.startConversation("heroVsWizard", gameRef, onCompete: () {
      isConversationComplete = true;
      completer.complete();
    });
    return await completer.future;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (other.isAttacking) {
        current = WizardState.harm;
        animationTicker?.onFrame = (index) {
          if (index == 2) {
            current = WizardState.attack;
          }
        };
        //   // Future.delayed(const Duration(microseconds: 200), () {
        //   //   current = WizardState.idle;
        //   // });
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  harmed() {}

  avoidHit() {
    behavior
      ..applyForceY(-2.5)
      ..isOnGround = false;
    current = WizardState.run;
    if (isFacingRight) {
      behavior
        ..xVelocity = 80
        ..horizontalMovement = 1;
    } else {
      behavior
        ..xVelocity = 80
        ..horizontalMovement = -1;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      if ((other.position.x - (isFacingRight ? width : 0)) > position.x) {
        turnRight();
        // if (isPlayerHittingWall) return;
        // moveRight();
      } else {
        turnLeft();
        // if (isPlayerHittingWall) return;
        // moveLeft();
      }
    }
    super.onCollisionEnd(other);
  }

  async.Timer? guardingWalk;
  walk() {
    guardingWalk = async.Timer.periodic(Duration(seconds: 2), (_) {
      if (isFacingRight) {
        turnLeft();
        moveLeft();
      } else {
        turnRight();
        moveRight();
      }
    });
  }
}
