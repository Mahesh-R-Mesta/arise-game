import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/service/levels.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:leap/leap.dart';

class AriseGame extends LeapGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Level level;
  final Size screenSize;
  AriseGame({required this.level, required this.screenSize, required super.tileSize, required super.world});

  @override
  FutureOr<void> onLoad() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final imagePaths = manifest
        .listAssets()
        .where((path) => path.startsWith('assets/images/') && RegExp(r'\.(png|jpg|jpeg|svg|gif|webp|bmp|wbmp)$', caseSensitive: false).hasMatch(path))
        .map((path) => path.replaceFirst('assets/images/', ''))
        .toList();
    await images.loadAll(imagePaths);

    await loadWorldAndMap(tiledMapPath: level.map); //level.map);
    debugMode = GameViewConfig.debugMode;

    camera = CameraComponent.withFixedResolution(world: world, width: screenSize.width, height: screenSize.height);

    return super.onLoad();
  }
}
