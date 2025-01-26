import 'package:arise_game/util/constant/assets_constant.dart';

enum PlayerState { idle, walking, running, jumping, jumpAfter, lightning, shield, attack, attack1, attack2, neal, death, harmed }

enum PlayerCharacter {
  red(GameAssets.characterRed, GameAssets.characterRed2),
  blue(GameAssets.characterBlue, GameAssets.characterBlue2),
  purple(GameAssets.characterPurple, GameAssets.characterPurple2),
  green(GameAssets.characterGreen, GameAssets.characterGreen2);

  final String asset1;
  final String asset2;
  const PlayerCharacter(this.asset1, this.asset2);
}
