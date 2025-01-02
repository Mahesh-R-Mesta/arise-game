import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

class CameraBehavior extends Component implements ReadOnlyPositionProvider {
  final GroundCharacterGroupAnime character;
  final double gap;
  CameraBehavior({required this.character, required this.gap});

  @override
  Vector2 get position {
    return Vector2(character.x - gap, -15 + (character.y * 0.2));
  }
}
