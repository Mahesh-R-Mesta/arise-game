import 'dart:async';

import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/utils/controller.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:get_it/get_it.dart';

class PlayerBehavior extends Behavior<Player> {
  final double speed = 75;

  final buttonBridge = GetIt.I.get<GameButtonBridge>();

  @override
  FutureOr<void> onLoad() {
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
          ..xVelocity = 75
          ..horizontalMovement = 1;
      } else {
        parent.current = PlayerState.idle;
        parent.behavior
          ..xVelocity = 75
          ..horizontalMovement = 0;
      }
    };

    buttonBridge.onPressJump = (pressed) {
      if (pressed && parent.behavior.isOnGround) {
        parent.current = PlayerState.jumping;
        parent.behavior.applyForce(5, 90, isOnGround: false);
        parent.isJumped = true;
        // parent.isOnGround = false;
      }
    };

    Timer? attackTimer;

    buttonBridge.onAttack = (pressed) {
      if (pressed) {
        if (parent.current == PlayerState.attack) return;
        attackTimer?.cancel();
        parent.current = PlayerState.attack;
        parent.behavior.horizontalMovement = 0;
      } else {
        attackTimer = Timer.periodic(const Duration(milliseconds: 100 * 6), (t) {
          if (parent.current == PlayerState.attack) {
            parent.current = PlayerState.idle;
          }
          t.cancel();
        });
      }
    };

    return super.onLoad();
  }
}
