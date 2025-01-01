import 'dart:async';
import 'package:arise_game/game/config.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HarmZone extends PositionComponent {
  final Vector2 playerSize;
  final Vector2? hitBoxSize;
  HarmZone({
    this.hitBoxSize,
    required this.playerSize,
  }) : super(anchor: Anchor.center);
  @override
  FutureOr<void> onLoad() {
    debugMode = GameViewConfig.debugMode;
    return super.onLoad();
  }

  bool highlight = false;

  blinkIt() async {
    highlight = true;
    Future.delayed(const Duration(milliseconds: 100), () => highlight = false);
  }

  @override
  void render(Canvas canvas) {
    if (highlight) {
      canvas.drawRect(Rect.fromLTWH(position.x + (hitBoxSize?.x ?? 0), position.y + (hitBoxSize?.y ?? 0), playerSize.x, playerSize.y),
          Paint()..color = Colors.red.withOpacity(0.5));
    }
    super.render(canvas);
  }
}
