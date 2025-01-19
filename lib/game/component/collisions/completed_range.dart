import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/field_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CompletedRange extends GameField with CollisionCallbacks, HasGameRef<AriseGame> {
  CompletedRange({super.position, super.size});
  @override
  void onLoad() {
    add(RectangleHitbox(position: Vector2(width / 2, height / 2), size: size, anchor: Anchor.center));
    super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.overlays.remove("controller");
      gameRef.level.startConversation("playEnd", game, onCompete: () {
        other.current = PlayerState.walking;
        other.behavior
          ..xVelocity = 30
          ..horizontalMovement = 1;
        Future.delayed(const Duration(seconds: 2), () {
          gameRef.overlays.add("gameWon");
          other.removeFromParent();
        });
      });
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
