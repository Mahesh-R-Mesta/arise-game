import 'dart:async';
import 'dart:ui';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/game/maps/game_world.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class AriseGame extends LeapGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  final String gameMap;
  late GameWorld gameWorld;
  AriseGame({required this.gameMap, required super.tileSize, required super.world});

  @override
  Color backgroundColor() => const Color(0xFFBBDEFB);
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await loadWorldAndMap(tiledMapPath: gameMap);
    gameWorld = GameWorld();
    debugMode = GameViewConfig.debugMode;
    // leapMap.tiledMap.position;
    // camera = CameraComponent.withFixedResolution(height: 500, width: 1000);
    // camera.follow(leapMap.tiledMap);

    await add(gameWorld);
    return super.onLoad();
  }

  // @override
  // void onMapLoaded(LeapMap map) async {
  //   // remove(gameWorld);
  //   // // gameWorld.addPlayer();
  //   // add(GameWorld());
  // }

  // nextLevelGame() async {
  //   await loadWorldAndMap(tiledMapPath: tileMapAsset[level - 1]);
  //   // GetIt.I.get<EarnedCoin>().reset();
  // }
}
