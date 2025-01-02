import 'dart:async';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/goblin.dart';
import 'package:arise_game/game/component/enemy/jungle_boar.dart';
import 'package:arise_game/game/component/items/coin.dart';
import 'package:arise_game/game/component/items/shape.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/config.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class GameWorld extends LeapWorld {
  late TiledComponent tileComponent;
  late Player player;
  final playerSize = Vector2(100, 100);
  final cameraAnchor = Anchor(300, 800);
  @override
  FutureOr<void> onLoad() async {
    gameRef.camera.viewfinder.anchor = Anchor.topLeft; // Anchor(0.2, 0.5);
    _addItems();
    _addEnemies();
    addPlayer();
    _addGround();
    _addCoins();
    return super.onLoad();
  }

  void addPlayer() {
    final spawnPoint = gameRef.leapMap.tiledMap.tileMap.getLayer<ObjectGroup>("spawn");
    if (spawnPoint != null) {
      for (final spawn in spawnPoint.objects) {
        if (spawn.class_ == "Player") {
          player = Player(position: Vector2(spawn.x, spawn.y), size: playerSize);
          add(player);
        }
      }
    }
  }

  void _addGround() {
    final groundLayer = gameRef.leapMap.tiledMap.tileMap.getLayer<ObjectGroup>("ground_layer");
    if (groundLayer == null) return;
    final tileViewInc = GameViewConfig.incValue();
    for (final ground in groundLayer.objects) {
      add(GroundBlock(
          type: GroundType.parse(ground.class_),
          position: Vector2(ground.x * tileViewInc, ground.y * tileViewInc),
          size: Vector2(ground.width * tileViewInc, ground.height * tileViewInc)));
    }
  }

  void _addCoins() {
    final coinsLayer = gameRef.leapMap.tiledMap.tileMap.getLayer<ObjectGroup>("coins");
    if (coinsLayer == null) return;
    for (final coin in coinsLayer.objects) {
      add(Coin(price: 5, position: Vector2(coin.x * GameViewConfig.incValue(), coin.y * GameViewConfig.incValue()), size: Vector2.all(16)));
    }
  }

  void _addEnemies() async {
    final enemies = gameRef.leapMap.tiledMap.tileMap.getLayer<ObjectGroup>("enemy");
    if (enemies == null) return;
    for (final enemy in enemies.objects) {
      if (enemy.class_ == "boar") {
        final type = enemy.properties.byName["type"]!.value as int;
        final reward = enemy.properties.byName["damageReward"]!.value as int;
        final speed = enemy.properties.byName["speed"]!.value as double;
        final harmCapacity = enemy.properties.byName["damageCapacity"]!.value as double;
        add(JungleBoar(
            boar: Boar.values[type - 1],
            damageCapacity: harmCapacity,
            damageReward: reward,
            speed: speed,
            position: Vector2(enemy.x * GameViewConfig.incValue(), enemy.y * GameViewConfig.incValue())));
      } else if (enemy.class_ == "goblin") {
        add(Goblin(position: Vector2(enemy.x * GameViewConfig.incValue(), enemy.y * GameViewConfig.incValue())));
      }
    }
  }

  void _addItems() {
    final items = gameRef.leapMap.tiledMap.tileMap.getLayer<ObjectGroup>("items");
    if (items == null) return;
    for (final item in items.objects) {
      if (item.class_ == "Shop") {
        add(GameShop(position: Vector2(item.x * GameViewConfig.incValue(), item.y * GameViewConfig.incValue())));
      }
    }
  }
}
