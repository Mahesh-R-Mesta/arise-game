import 'dart:async';
import 'dart:math';

import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/service/controller.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:get_it/get_it.dart';

class PlayerBehavior extends Behavior<Player> {
  final double speed = 75;
  PlayerBehavior();

  final buttonBridge = GetIt.I.get<GameButtonBridge>();
  final audioService = GetIt.I.get<AudioService>();
  Timer? attackTimer;
  Timer? swordPlayTimer;
  @override
  FutureOr<void> onLoad() {
    stopSwordPlay() {
      if (swordPlayTimer?.isActive == true) swordPlayTimer?.cancel();
    }

    buttonBridge.onLeftMove = (pressed) {
      if (pressed && !parent.hittingLeftWall) {
        parent.current = PlayerState.running;
        if (parent.isFacingRight) {
          parent.flipHorizontallyAroundCenter();
          parent.isFacingRight = false;
        }
        parent.behavior
          ..xVelocity = 75
          ..horizontalMovement = -1;
      } else {
        parent.current = PlayerState.idle;
        parent.behavior.horizontalMovement = 0;
      }
      stopSwordPlay();
    };

    buttonBridge.onRightMove = (pressed) {
      if (pressed && !parent.hittingRightWall) {
        // if (parent.current != PlayerState.jumping)
        parent.current = PlayerState.running;
        if (!parent.isFacingRight) {
          parent.flipHorizontallyAroundCenter();
          parent.isFacingRight = true;
        }
        parent.behavior
          ..applyForceX(37)
          ..horizontalMovement = 1;
      } else {
        parent.current = PlayerState.idle;
        parent.behavior
          ..applyForceX(37)
          ..horizontalMovement = 0;
      }
      stopSwordPlay();
    };

    buttonBridge.onActivateShield = (activate) {
      if (activate) {
        parent
          ..behavior.horizontalMovement = 0
          ..current = PlayerState.shield;
      }
    };

    buttonBridge.onPressJump = (pressed) {
      if (pressed && parent.behavior.isOnGround) {
        parent.current = PlayerState.jumping;
        parent.behavior
          ..applyForceY(-2.4)
          ..isOnGround = false;
        parent.isJumped = true;
        // parent.isOnGround = false;
      }
      stopSwordPlay();
    };
    bool lastTapped = false;
    buttonBridge.onAttackTap = () {
      if (parent.isAttacking) return lastTapped = true;

      swingSword() {
        if (parent.behavior.isOnGround) {
          parent.current = PlayerState.attack;
        } else {
          parent.current = PlayerState.attack1;
        }
        parent.behavior.horizontalMovement = 0;
        audioService.playSwordSound();
        parent.animationTicker?.onFrame = (frame) {
          if ((parent.current == PlayerState.attack && frame == 6) || (parent.current == PlayerState.attack1 && frame == 7)) {
            if (lastTapped && Random().nextBool()) {
              swingSword();
              lastTapped = false;
              return;
            }
            lastTapped = false;
            parent.current = PlayerState.idle;
          }
        };
      }

      swingSword();
    };

    // buttonBridge.onActivateShield = (pressed) {
    //   if (pressed) {
    //     if (parent.isAttacking) return;
    //     attackTimer?.cancel();
    //     if (parent.behavior.isOnGround) {
    //       parent.current = PlayerState.attack;
    //     } else {
    //       parent.current = PlayerState.attack1;
    //     }
    //     parent.behavior.horizontalMovement = 0;
    //     audioService.playSwordSound();
    //     swordPlayTimer = Timer.periodic(const Duration(milliseconds: 300), (_) => audioService.playSwordSound());
    //   } else {
    //     attackTimer = Timer.periodic(const Duration(milliseconds: 100 * 6), (t) {
    //       if (parent.isAttacking) {
    //         parent.current = PlayerState.idle;
    //         // if (parent.current == PlayerState.attack1) {
    //         //   parent.behavior.horizontalMovement = 0;
    //         // }
    //       }
    //       t.cancel();
    //     });
    //     swordPlayTimer?.cancel();
    //   }
    // };

    // buttonBridge.onDoubleTap = () {
    //   stopSwordPlay();
    //   parent.current = PlayerState.shield;
    // };

    return super.onLoad();
  }

  @override
  void onRemove() {
    swordPlayTimer?.cancel();
    super.onRemove();
  }

  @override
  void update(double dt) {
    if (parent.behavior.isOnGround && parent.current == PlayerState.jumping) {
      if (parent.behavior.horizontalMovement != 0) {
        parent.current = PlayerState.running;
      } else {
        parent.current = PlayerState.jumpAfter;
        parent.animationTicker?.onComplete = () {
          parent.current = PlayerState.idle;
        };
      }
    }
    super.update(dt);
  }
}
