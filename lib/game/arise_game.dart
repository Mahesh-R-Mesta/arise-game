import 'dart:async';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/game/maps/game_world.dart';
import 'package:arise_game/service/levels.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:leap/leap.dart';

class AriseGame extends LeapGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Level level;
  final Size screenSize;

  AriseGame({
    required this.level,
    required this.screenSize,
    required super.tileSize,
    required super.world,
  }) {
    images = Flame.images;
  }

  static Set<String>? _cachedManifestPaths;
  static final Set<String> _allCharacterAssets = {
    for (final c in PlayerCharacter.values) ...[c.asset1, c.asset2],
  };

  static Future<void> preloadAssets() async {
    if (_cachedManifestPaths == null) {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _cachedManifestPaths = manifest
          .listAssets()
          .where((path) =>
              path.startsWith('assets/images/') &&
              !path.startsWith('assets/images/app/') &&
              RegExp(r'\.(png|jpg|jpeg|webp|bmp|gif|wbmp)$', caseSensitive: false).hasMatch(path))
          .map((path) => path.replaceFirst('assets/images/', ''))
          .toSet();
    }

    final activeChar = LocalStorage.instance.getPlayerCharacter;
    final pathsToLoad = _cachedManifestPaths!.where((path) {
      if (_allCharacterAssets.contains(path) && path != activeChar.asset1 && path != activeChar.asset2) {
        return false;
      }
      return !Flame.images.containsKey(path);
    }).toList();

    if (pathsToLoad.isNotEmpty) {
      await Flame.images.loadAll(pathsToLoad);
    }
  }

  bool _settledForStartOverlay = false;

  @override
  FutureOr<void> onLoad() async {
    await preloadAssets();

    await loadWorldAndMap(tiledMapPath: level.map, images: images);
    debugMode = GameViewConfig.debugMode;

    camera = CameraComponent.withFixedResolution(world: world, width: screenSize.width, height: screenSize.height);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_settledForStartOverlay && overlays.isActive("startGame")) {
      final gameWorld = world;
      if (gameWorld is GameWorld && gameWorld.isPlayerReady && gameWorld.player.behavior.isOnGround) {
        _settledForStartOverlay = true;
        pauseEngine();
      }
    }
  }
}

