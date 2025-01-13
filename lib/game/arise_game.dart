import 'dart:async';
import 'dart:ui';
import 'package:arise_game/game/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class AriseGame extends LeapGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  final String gameMap;
  final Size screenSize;
  AriseGame({required this.gameMap, required this.screenSize, required super.tileSize, required super.world});

  // @override
  // Color backgroundColor() => const Color(0xFFBBDEFB);
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await loadWorldAndMap(tiledMapPath: gameMap);
    debugMode = GameViewConfig.debugMode;
    camera = CameraComponent.withFixedResolution(world: world, width: screenSize.width, height: screenSize.height);
    return super.onLoad();
  }
}
