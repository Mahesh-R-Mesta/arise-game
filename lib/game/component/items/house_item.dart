import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/object_entity.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum HouseItems {
  table("table", GameAssets.table),
  leftChair("leftChair", GameAssets.chair),
  rightChair("rightChair", GameAssets.chair),
  bookShelf_1("bookShelf1", GameAssets.bookShelf1),
  boolShelf_2("bookShelf2", GameAssets.bookShelf2);

  final String name;
  final String image;
  const HouseItems(this.name, this.image);
  static bool contain(String key) {
    return HouseItems.values.any((item) => item.name == key);
  }

  static HouseItems? parse(String key) {
    try {
      return HouseItems.values.firstWhere((item) => item.name == key);
    } catch (e) {
      return null;
    }
  }
}

class HouseItemSprite extends GameObjectSprite with HasGameRef<AriseGame> {
  final HouseItems item;
  HouseItemSprite({required this.item, super.position});
  @override
  FutureOr<void> onLoad() async {
    behavior.isOnGround = false;
    switch (item) {
      case HouseItems.table:
        scale = Vector2(1.5, 1.5);
      case HouseItems.leftChair || HouseItems.rightChair:
        scale = Vector2(1.4, 1.4);
      case HouseItems.bookShelf_1:
        scale = Vector2(1.2, 1.2);
      case HouseItems.boolShelf_2:
        scale = Vector2(1.2, 1.2);
    }

    sprite = await Sprite.load(item.image, images: gameRef.images);
    if (item == HouseItems.leftChair) {
      flipHorizontallyAroundCenter();
    }
    add(RectangleHitbox());
    return super.onLoad();
  }
}
