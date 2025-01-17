import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:flame/components.dart';

class FireStick extends GameObjectAnime with HasGameRef<AriseGame> {
  FireStick({super.position, super.size}) : super(scale: Vector2(1.3, 1.3));
  final path = "background/decorations/torch_big/";
  @override
  FutureOr<void> onLoad() async {
    animation = SpriteAnimation.spriteList([for (int i = 0; i < 5; i++) await Sprite.load("${path}torch_big_${i + 1}.png", images: gameRef.images)],
        stepTime: 0.1);
    return super.onLoad();
  }
}
