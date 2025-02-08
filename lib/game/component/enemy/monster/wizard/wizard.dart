import 'dart:async' as async;
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/collisions/monster_view.dart';
import 'package:arise_game/game/component/enemy/monster/wizard/wizard_shoot.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:arise_game/util/enum/wizard_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';

class Wizard extends GroundCharacterEntity with HasGameRef<AriseGame> {
  Wizard({super.position}) : super(scale: Vector2(0.7, 0.7), anchor: Anchor.center);

  late Lifeline lifeline;
  int rewardCoin = 100;

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
        image: gameRef.images.fromCache(WizardState.attack.asset), amountPerRow: 3, amount: 10, stepTime: 0.1, textureSize: Vector2.all(80));
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
    add(ViewSight(inViewRang: viewRange, visibleRange: Vector2(600, 60), parentSize: size));
    current = WizardState.idle;

    walk();
    return super.onLoad();
  }

  viewRange(Set<Vector2> intersect, PositionComponent other) async {
    if (other is Player) {
      guardingWalk?.cancel();
      behavior.horizontalMovement = 0;
      current = WizardState.idle;
      await conversation(other);
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
  conversation(Player player) async {
    if (isConversationComplete) return;
    final completer = async.Completer();
    player
      ..behavior.horizontalMovement = 0
      ..current = PlayerState.idle;
    gameRef
      ..overlays.remove("controller")
      ..level.startConversation("heroVsWizard", gameRef, onCompete: () {
        isConversationComplete = true;
        gameRef.overlays.add("controller");
        completer.complete();
      });
    return await completer.future;
  }

  int hitCount = 0;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (other.isAttacking) {
        current = WizardState.harm;
        harmed(other.damageCapacity * 0.2);
        animationTicker?.onFrame = (index) {
          if (index == 2 && current != WizardState.die) {
            current = WizardState.attack;
          }
        };
        hitCount += 1;
        if (hitCount == 3 && current != WizardState.die) {
          hitCount = 0;
          avoidHit();
        }
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  void harmed(double damageCapacity) {
    lifeline.reduce(damageCapacity);
    final playerEarnedCoin = GetIt.I.get<EarnedCoinCubit>();
    if (lifeline.health == 0) {
      playerEarnedCoin.receivedCoin(rewardCoin);
      current = WizardState.die;
      Future.delayed(Duration(milliseconds: (animation!.frames.first.stepTime * animation!.frames.length * 1000).toInt()), () => removeFromParent());
    }
  }

  avoidHit() {
    behavior
      ..applyForceY(-2.8)
      ..isOnGround = false;
    current = WizardState.idle;
    if (isFacingRight) {
      behavior
        ..xVelocity = 110
        ..horizontalMovement = 1;
    } else {
      behavior
        ..xVelocity = 110
        ..horizontalMovement = -1;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock) behavior.horizontalMovement = 0;
    super.onCollisionStart(intersectionPoints, other);
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

  @override
  void onCollideOnWall(GroundType type) {
    behavior.horizontalMovement = 0;
    current = WizardState.idle;
    super.onCollideOnWall(type);
  }
}
