import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class GravityBehavior extends Behavior<GroundCharacter> {
  double yVelocity = 0;
  double gravity = 5.0;

  @override
  void update(double dt) {
    // if player jumped set velocity and disable it
    if (parent.isJumped) {
      yVelocity = -parent.jumpForce;
      parent.isJumped = false;
      parent.playerOnGround = false;
    }
    // if player not on ground gravity works
    if (!parent.playerOnGround) {
      yVelocity += (gravity * dt);
      parent.position.y += yVelocity;
    } else {
      if (parent.current == PlayerState.jumping) {
        if (parent.horizontalMovement != 0) {
          parent.current = PlayerState.running;
        } else {
          parent.current = PlayerState.idle;
        }
      }
    }
    super.update(dt);
  }
}
