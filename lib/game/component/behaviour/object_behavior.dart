import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class ObjectBehavior<T extends EntityMixin> extends Behavior<T> {
  double xVelocity = 0;
  double yVelocity = 0;
  double gravity = 5;
  double drag = 0.05;
  double mass = 0.5;
  bool isOnGround = true;
  int horizontalMovement = 1;

  ObjectBehavior(
      {this.xVelocity = 0,
      this.yVelocity = 0,
      this.gravity = 5,
      this.isOnGround = true,
      this.drag = 0.05,
      this.mass = 0.5,
      this.horizontalMovement = 1});

  applyForce(double force, double angle, {bool isRight = true, bool isOnGround = true}) {
    horizontalMovement = isRight ? -1 : 1;
    this.isOnGround = isOnGround;
    yVelocity = -(force / mass) * sin(radians(angle));
    xVelocity = horizontalMovement * (force / mass) * cos(radians(angle));
    print("h: $yVelocity v: $xVelocity");
  }

  @override
  void update(double dt) {
    if (!isOnGround) {
      yVelocity += (gravity * dt);
      (parent as PositionComponent).position.y += yVelocity;
    }
    if (xVelocity >= 0) {
      xVelocity -= (drag * horizontalMovement);
      (parent as PositionComponent).position.x += xVelocity;
    }
    super.update(dt);
  }
}
