import 'dart:async' as async;
import 'dart:ui';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/items/lifeline.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum GoblinState { idle, bombing }

class Goblin extends GroundCharacter with HasGameRef<AriseGame> {
  Goblin({super.position, super.size}) : super(anchor: Anchor.center, scale: Vector2(1.5, 1.5));

  double bombingTime = 5;

  late Lifeline lifeline;

  late SpriteAnimation attackAnimation;

  @override
  async.FutureOr<void> onLoad() {
    lifeline = Lifeline(playerBoxWidth: 250, scale: Vector2(0.5, 0.5));
    final facingRightAnimation = SpriteAnimation.fromFrameData(gameRef.images.fromCache("character/goblin.png"),
        SpriteAnimationData.sequenced(texturePosition: Vector2(0, 60), amount: 2, stepTime: 0.8, textureSize: Vector2(150, 40)));
    attackAnimation = SpriteAnimation.fromFrameData(gameRef.images.fromCache("character/goblin.png"),
        SpriteAnimationData.sequenced(texturePosition: Vector2(0, 60), amount: 12, stepTime: bombingTime / 12, textureSize: Vector2(150, 40)));
    animations = {GoblinState.idle: facingRightAnimation, GoblinState.bombing: attackAnimation};
    current = GoblinState.bombing;
    add(RectangleHitbox(position: Vector2((width / 2) - 16, 0), size: Vector2(32, 40)));
    // async.Timer.periodic(Duration(seconds: bombingTime.toInt()), (_) => bomb());
    // attackAnimation
    add(lifeline);
    flipHorizontallyAroundCenter();
    animationTicker?.onFrame = (index) {
      if (index == 11) bomb();
    };
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && other.position.x < position.x && isFacingRight) {
      bomb();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && other.current == PlayerState.attack) {
      lifeline.reduce(other.damageCapacity);
      if (lifeline.health == 0) {
        removeFromParent();
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void bomb() async {
    // if (GoblinState.bombing != current) return;
    // final bomb = Bomb(3, posAdjust: Vector2(32, -40));
    // bomb.behavior.applyForce(3, 20, isRight: false, isOnGround: false);

    // await add(bomb);
  }

  // void faceShift() {
  //   if (isFacingRight) {
  //     flipHorizontallyAroundCenter();
  //     bomb();
  //     isFacingRight = false;
  //   } else {
  //     flipHorizontallyAroundCenter();
  //     bomb();
  //     isFacingRight = true;
  //   }
  // }

  @override
  Vector2 getActorPosition() => position;

  @override
  Size getActorSize() => Size(width, height);

  @override
  void update(double dt) {
    super.update(dt);
  }
}
