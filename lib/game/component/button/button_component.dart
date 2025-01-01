import 'dart:async';

import 'package:flame/components.dart';

class MovementButton extends SpriteComponent {
  MovementButton({super.size, super.position});
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("arrow_right.png");
    return super.onLoad();
  }

  // @override
  // void onTapDown(TapDownEvent event) {
  //   print("dasdasd");
  //   super.onTapDown(event);
  // }
}
