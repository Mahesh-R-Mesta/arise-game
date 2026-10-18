import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class CameraBehavior extends Component implements ReadOnlyPositionProvider {
  final GroundCharacterEntity character;
  final AriseGame game;
  CameraBehavior({required this.character, required this.game});

  double xRangeMin = 100;
  double xRangeMax = 200;

  final Vector2 _cachedPosition = Vector2.zero();

  double getYAxisBound(Vector2 mapSize) {
    if (character.y > (mapSize.y * 0.32)) {
      return character.y;
    } else {
      return mapSize.y * 0.32;
    }
  }

  double getXAxisBound(Vector2 mapSize) {
    if (character.x <= (mapSize.x * 0.06)) {
      return mapSize.x * 0.06;
    }
    if (character.x >= (mapSize.x * 0.87)) {
      return mapSize.x * 0.87;
    }
    return character.x;
  }

  @override
  Vector2 get position {
    final mapSize = game.world.map.tiledMap.scaledSize;
    _cachedPosition.setValues(getXAxisBound(mapSize), getYAxisBound(mapSize));
    return _cachedPosition;
  }
}
