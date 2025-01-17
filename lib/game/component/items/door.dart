import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/overlay/game_activity_overlay.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Door extends GameObjectSprite with HasGameRef<AriseGame> {
  final String id;
  final bool front;
  Door(this.id, this.front, {super.position}) : super(scale: Vector2(1.5, 1.5), key: ComponentKey.named(id + (front ? "front" : "back")));

  @override
  FutureOr<void> onLoad() async {
    behavior.isOnGround = false;
    sprite = await Sprite.load(GameAssets.door, images: gameRef.images);
    add(RectangleHitbox());

    return super.onLoad();
  }

  moveToNextDoor() {
    final player = gameRef.findByKey<Player>(ComponentKey.named("player"));
    final nextDoor = gameRef.findByKey<Door>(ComponentKey.named(id + (!front ? "front" : "back")));
    if (nextDoor != null) player?.position = Vector2(nextDoor.position.x, nextDoor.position.y + 30);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    gameRef.overlays
        .addEntry("doorOpen", (ctx, game) => GameActivityOverlayButton(size: Size(150, 50), message: "Open Door", onTap: () => moveToNextDoor()));
    if (other is Player) {
      gameRef.overlays.add("doorOpen");
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    gameRef.overlays.remove("doorOpen");
    super.onCollisionEnd(other);
  }
}
