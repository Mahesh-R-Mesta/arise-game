import 'dart:async';
import 'dart:ui';

import 'package:arise_game/game/config.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Lifeline extends PositionComponent {
  final double playerBoxWidth;
  final double yPosition;
  Lifeline({required this.playerBoxWidth, this.yPosition = 0, super.scale}) : super(anchor: Anchor.topCenter, size: Vector2(50, 5));

  double _health = 100;

  resetHealth() => _health = 100;

  double get health => _health;

  void reduce(double damage) {
    if (_health == 0) return;
    _health = _health - damage;
    if (_health < 0) _health = 0;
  }

  @override
  FutureOr<void> onLoad() {
    debugMode = GameViewConfig.debugMode;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = _health < 50 ? Colors.red : Colors.green;
    final halfBox = playerBoxWidth / 2;
    canvas.drawRRect(
        RRect.fromLTRBR(halfBox + position.x, position.y + yPosition, halfBox + position.x + width, position.y + 5 + yPosition, Radius.circular(6)),
        borderPaint);
    canvas.drawRRect(
        RRect.fromLTRBR(halfBox + position.x, position.y + yPosition, halfBox + position.x + ((_health) * width / 100), position.y + 5 + yPosition,
            Radius.circular(6)),
        fillPaint); // canvas.drawRRect(RRect.fromLTRBR(position.x, position.y, position.x + 100, position.y + 10, Radius.circular(6)), borderPaint);
    super.render(canvas);
  }
}
