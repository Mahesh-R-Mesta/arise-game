import 'dart:math';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

class CameraBehavior extends Component implements ReadOnlyPositionProvider {
  final GroundCharacterEntity character;
  final AriseGame game;
  CameraBehavior({required this.character, required this.game});

  double xRangeMin = 100;
  double xRangeMax = 200;

  double getYAxisBound() {
    final mapSize = game.world.map.tiledMap.scaledSize;
    if (character.y > (mapSize.y * 0.32)) {
      return character.y;
    } else {
      return mapSize.y * 0.32;
    }
  }

  double getXAxisBound() {
    final mapSize = game.world.map.tiledMap.scaledSize;
    if (character.x <= (mapSize.x * 0.06)) {
      return mapSize.x * 0.06;
    }
    if (character.x >= (mapSize.x * 0.86)) {
      return mapSize.x * 0.86;
    }
    return character.x;
  }

  @override
  Vector2 get position {
    return Vector2(getXAxisBound(), getYAxisBound());
  }
}
