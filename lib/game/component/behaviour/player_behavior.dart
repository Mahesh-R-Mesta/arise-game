import 'dart:async';

import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/audio.dart';
import 'package:arise_game/util/controller.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:get_it/get_it.dart';

class PlayerBehavior extends Behavior<Player> {
  final double speed = 75;

  final buttonBridge = GetIt.I.get<GameButtonBridge>();
  final audioService = GetIt.I.get<AudioService>();

  @override
  FutureOr<void> onLoad() {
    Timer? attackTimer;
    Timer? swordPlayTimer;

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

    buttonBridge.onPressJump = (pressed) {
      if (pressed && parent.behavior.isOnGround) {
        parent.current = PlayerState.jumping;
        parent.behavior
          ..applyForceY(-2.2)
          ..isOnGround = false;
        parent.isJumped = true;
        // parent.isOnGround = false;
      }
      stopSwordPlay();
    };

    buttonBridge.onAttack = (pressed) {
      if (pressed) {
        if (parent.current == PlayerState.attack) return;
        attackTimer?.cancel();
        parent.current = PlayerState.attack;
        parent.behavior.horizontalMovement = 0;
        audioService.playSwordSound();
        swordPlayTimer = Timer.periodic(const Duration(milliseconds: 300), (_) => audioService.playSwordSound());
      } else {
        attackTimer = Timer.periodic(const Duration(milliseconds: 100 * 6), (t) {
          if (parent.current == PlayerState.attack) {
            parent.current = PlayerState.idle;
          }
          t.cancel();
        });
        swordPlayTimer?.cancel();
      }
    };

    buttonBridge.onDoubleTap = () {
      stopSwordPlay();
      parent.current = PlayerState.shield;
    };

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (parent.behavior.isOnGround && parent.current == PlayerState.jumping) {
      if (parent.behavior.horizontalMovement != 0) {
        parent.current = PlayerState.running;
      } else {
        parent.current = PlayerState.idle;
      }
    }
    super.update(dt);
  }
}
