import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Lifeline extends PositionComponent {
  Lifeline({super.position, super.size}) : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // canvas.drawRRect(RRect.fromLTRBR(position.x - width, position.y - 220, position.x, position.y - 215, Radius.circular(6)), borderPaint);
    canvas.drawRRect(RRect.fromLTRBR(position.x, position.y, position.x + 100, position.y + 10, Radius.circular(6)), borderPaint);
    super.render(canvas);
  }
}
