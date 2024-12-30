import 'dart:async';
import 'dart:ui';
import 'package:arise_game/game/maps/game_world.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class AriseGame extends LeapGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late GameWorld gameWorld;
  AriseGame({required super.tileSize, required super.world});

  @override
  Color backgroundColor() => const Color(0xFFBBDEFB);
  @override
  FutureOr<void> onLoad() async {
    gameWorld = GameWorld();
    await images.loadAllImages();
    await loadWorldAndMap(tiledMapPath: "map_level_01.tmx");
    debugMode = true;
    await add(gameWorld);
    return super.onLoad();
  }
}
