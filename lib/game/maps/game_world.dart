import 'dart:async';
import 'package:arise_game/game/component/collisions/completed_range.dart';
import 'package:arise_game/game/component/collisions/ground_collision.dart';
import 'package:arise_game/game/component/enemy/fire.dart';
import 'package:arise_game/game/component/enemy/jungle_boar.dart';
import 'package:arise_game/game/component/enemy/monster/flying_eye.dart';
import 'package:arise_game/game/component/enemy/monster/goblin.dart';
import 'package:arise_game/game/component/enemy/monster/mushroom.dart';
import 'package:arise_game/game/component/enemy/monster/skeleton.dart';
import 'package:arise_game/game/component/enemy/moster_character.dart';
import 'package:arise_game/game/component/enemy/monster/wizard/wizard.dart';
import 'package:arise_game/game/component/items/lever.dart';
import 'package:arise_game/game/component/items/worm_hole.dart';
import 'package:arise_game/game/component/items/coin.dart';
import 'package:arise_game/game/component/items/door.dart';
import 'package:arise_game/game/component/items/fire_stick.dart';
import 'package:arise_game/game/component/items/health_drink.dart';
import 'package:arise_game/game/component/items/shape.dart';
import 'package:arise_game/game/component/items/house_item.dart';
import 'package:arise_game/game/component/items/sword.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/game/config.dart';
import 'package:arise_game/util/enum/monster_enum.dart';
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
      final tileViewInc = GameViewConfig.incValue();
      for (final spawn in spawnPoint.objects) {
        if (spawn.class_ == "Player") {
          player = Player(
              position: Vector2(spawn.x * tileViewInc, spawn.y * tileViewInc),
              size: playerSize,
              damageCapacity: spawn.properties.byName["damageCap"]!.value as double,
              runSpeed: spawn.properties.byName["runSpeed"]!.value as double,
              jumpForce: spawn.properties.byName["jumpForce"]!.value as double);
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
      final amount = coin.properties.byName["amount"]!.value as int;
      add(Coin(price: amount, position: Vector2(coin.x * GameViewConfig.incValue(), coin.y * GameViewConfig.incValue()), size: Vector2.all(16)));
    }
  }

  void _addEnemies() async {
    final enemies = gameRef.leapMap.tiledMap.tileMap.getLayer<ObjectGroup>("enemy");
    if (enemies == null) return;
    for (final enemy in enemies.objects) {
      final position = Vector2(enemy.x * GameViewConfig.incValue(), enemy.y * GameViewConfig.incValue());
      if (enemy.class_ == "boar") {
        final type = enemy.properties.byName["type"]!.value as int;
        final reward = enemy.properties.byName["damageReward"]!.value as int;
        final speed = enemy.properties.byName["speed"]!.value as double;
        final harmCapacity = enemy.properties.byName["damageCapacity"]!.value as double;
        add(JungleBoar(boar: Boar.values[type - 1], damageCapacity: harmCapacity, damageReward: reward, speed: speed, position: position));
      } else if (["goblin", "skeleton", "mushroom", "flyingEye"].contains(enemy.class_)) {
        final damage = enemy.properties.byName["damage"]!.value as double;
        final reward = enemy.properties.byName["reward"]!.value as int;
        add(MonsterCharacter(monster: MonsterType.parse(enemy.class_), damage: damage, reward: reward, position: position));
      } else if (enemy.class_ == "Fire") {
        add(Fire(position: position));
      } else if (enemy.class_ == "goblin_attacker") {
        final damage = enemy.properties.byName["damage"]!.value as double;
        final reward = enemy.properties.byName["reward"]!.value as int;
        final facingRight = (enemy.properties.byName["faceDir"]?.value as bool?) ?? false;
        final proAttack = enemy.properties.byName["projectileAttack"]!.value as bool;
        final takeAround = (enemy.properties.byName["takeAround"]?.value as bool?) ?? false;
        add(Goblin(position: position, damagePower: damage, faceRight: facingRight, rewardCoins: reward, bombing: proAttack, takeAround: takeAround));
      } else if (enemy.class_ == "mushroom_attacker") {
        final damage = enemy.properties.byName["damage"]!.value as double;
        final reward = enemy.properties.byName["reward"]!.value as int;
        final facingRight = (enemy.properties.byName["faceDir"]?.value as bool?) ?? false;
        final proAttack = enemy.properties.byName["projectileAttack"]!.value as bool;
        final takeAround = (enemy.properties.byName["takeAround"]?.value as bool?) ?? false;
        add(Mushroom(
            position: position,
            damagePower: damage,
            faceRight: facingRight,
            rewardCoins: reward,
            projectileAttack: proAttack,
            takeAround: takeAround));
      } else if (enemy.class_ == "skeleton_attacker") {
        final damage = enemy.properties.byName["damage"]!.value as double;
        final reward = enemy.properties.byName["reward"]!.value as int;
        final proAttack = enemy.properties.byName["projectileAttack"]!.value as bool;
        final facingRight = (enemy.properties.byName["faceDir"]?.value as bool?) ?? false;
        final takeAround = (enemy.properties.byName["takeAround"]?.value as bool?) ?? false;
        add(Skeleton(
            position: position,
            damagePower: damage,
            faceRight: facingRight,
            rewardCoins: reward,
            projectileAttack: proAttack,
            takeAround: takeAround));
      } else if (enemy.class_ == "flying_eye_attacker") {
        final damage = enemy.properties.byName["damage"]!.value as double;
        final reward = enemy.properties.byName["reward"]!.value as int;
        final facingRight = (enemy.properties.byName["faceDir"]?.value as bool?) ?? false;
        add(FlyingEye(position: position, damagePower: damage, faceRight: facingRight, rewardCoins: reward));
      } else if (enemy.class_ == "wizard") {
        add(Wizard(position: position));
      }
    }
  }

  Map<String, Door> doorConnect = {};

  void _addItems() {
    final items = gameRef.leapMap.tiledMap.tileMap.getLayer<ObjectGroup>("items");
    if (items == null) return;
    for (final item in items.objects) {
      final position = Vector2(item.x * GameViewConfig.incValue(), item.y * GameViewConfig.incValue());
      if (item.class_ == "Shop") {
        add(GameShop(position: position));
      } else if (item.class_ == "wormhole") {
        final type = item.properties.byName["type"]!.value as String;
        add(WormHole(type: Worm.parse(type), position: position));
      } else if (item.class_ == "fire_stick") {
        add(FireStick(position: position));
      } else if (HouseItems.contain(item.class_)) {
        final type = HouseItems.parse(item.class_);
        if (type == null) continue;
        add(HouseItemSprite(item: type, position: position));
      } else if (item.class_ == "door") {
        final connectId = item.properties.byName["id"]!.value as String;
        final frontType = item.properties.byName["front"]!.value as bool;
        add(Door(connectId, frontType, position: position));
      } else if (item.class_ == "magicalSword") {
        add(Sword(position: position));
      } else if (item.class_ == "health") {
        add(HealthSyrup(position: position));
      } else if (item.class_ == "complete") {
        add(CompletedRange(position: position, size: Vector2(item.width * GameViewConfig.incValue(), item.height * GameViewConfig.incValue())));
      } else if (item.class_ == "lever") {
        add(LeverStick(position: position));
      }
    }
  }
}
