import 'dart:async';
import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/collisions/monster_view.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum Actor { walk, idle }

enum VillagerType {
  oldMan(GameAssets.oldManWalk, GameAssets.oldManIdle),
  oldWoman(GameAssets.oldWomanWalk, GameAssets.oldWomanIdle),
  man(GameAssets.manWalk, GameAssets.manIdle),
  woman(GameAssets.womanWalk, GameAssets.womanIdle),
  child(GameAssets.boyWalk, GameAssets.boyIdle);

  final String walk;
  final String idle;

  const VillagerType(this.walk, this.idle);

  static VillagerType parse(String type) {
    switch (type) {
      case "man":
        return VillagerType.man;
      case "oldMan":
        return VillagerType.oldMan;
      case "woman":
        return VillagerType.woman;
      case "oldWoman":
        return VillagerType.oldWoman;
      case "boy":
        return VillagerType.child;
    }
    return VillagerType.man;
  }
}

bool didPlayerSawUs = false;

class Villager extends GroundCharacterEntity with HasGameRef<AriseGame> {
  final VillagerType type;
  Villager({super.position, required this.type});
  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    behavior
      ..horizontalMovement = -1
      ..xVelocity = 20;
    scale = Vector2(1.8, 1.8);
    flipHorizontallyAroundCenter();
    final idleAnimation = spriteAnimationSequence(image: game.images.fromCache(type.idle), amount: 4, stepTime: 0.4, textureSize: Vector2(48, 48));
    final walkAnimation = spriteAnimationSequence(image: game.images.fromCache(type.walk), amount: 6, stepTime: 0.2, textureSize: Vector2(48, 48));
    add(RectangleHitbox());
    add(ViewSight(parentSize: size, visibleRange: Vector2(100, 60), inViewRang: onView));
    animations = {Actor.idle: idleAnimation, Actor.walk: walkAnimation};
    current = Actor.walk;
    return super.onLoad();
  }

  onView(Set<Vector2> intersect, PositionComponent other) {
    if (other is Player) {
      other
        ..behavior.horizontalMovement = 0
        ..current = PlayerState.idle;
      didPlayerSawUs = true;
      gameRef.level.startConversation("storyPlay", gameRef, onCompete: () {
        gameRef.overlays.add("gameWon");
      });
    }
  }

  @override
  void update(double dt) {
    if (didPlayerSawUs) {
      current = Actor.idle;
      behavior.horizontalMovement = 0;
    }

    super.update(dt);
  }
}
