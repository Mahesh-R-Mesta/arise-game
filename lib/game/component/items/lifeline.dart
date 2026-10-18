import 'dart:async';

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

  static final Paint _borderPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  static final Paint _redFillPaint = Paint()..color = Colors.red;
  static final Paint _greenFillPaint = Paint()..color = Colors.green;
  static const Radius _barRadius = Radius.circular(6);

  @override
  void render(Canvas canvas) {
    final fillPaint = _health < 50 ? _redFillPaint : _greenFillPaint;
    final halfBox = playerBoxWidth / 2;
    final left = halfBox + position.x;
    final top = position.y + yPosition;
    final bottom = top + 5;
    canvas.drawRRect(
        RRect.fromLTRBR(left, top, left + width, bottom, _barRadius),
        _borderPaint);
    canvas.drawRRect(
        RRect.fromLTRBR(left, top, left + (_health * width / 100), bottom, _barRadius),
        fillPaint);
    super.render(canvas);
  }
}
