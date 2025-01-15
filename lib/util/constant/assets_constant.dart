mixin AudioAsset {
  static const String path = "audio/";
  static const String background = "${path}background.mp3";
  static const String bomb = "${path}bomb_sound.mp3";
  static const String coin = "${path}got_coin.mp3";
  static const String playerHurt = "${path}manhurt.mp3";
  static const String boar = "${path}pig.mp3";
  static const String shield = "${path}shield.mp3";
  static const String swordSwing = "${path}sword-sound.mp3";
}

mixin AppAsset {
  static const String path = "assets/images/app/";
  static const String logo = "${path}logo.png";
  static const String splash = "${path}splash.png";
}

mixin GameAssets {
  static const String character = "character/"; //character/char_blue_2.png
  static const String characterBlue2 = "${character}char_blue_2.png"; //character/
  static const String characterRed2 = "${character}char_red_2.png"; //character/char_blue_2.png
  static const String characterPurple2 = "${character}char_purple_2.png"; //character/char_blue_2.png
  static const String characterGreen2 = "${character}char_green_2.png"; //character/char_blue_2.png

  static const String characterBlue = "${character}char_blue.png"; //character/char_blue_2.png
  static const String characterRed = "${character}char_red.png"; //character/char_blue_2.png
  static const String characterPurple = "${character}char_purple.png";
  static const String characterGreen = "${character}char_green.png";
  static const String fire = "fire.png";
  static const String wormhole = "worm_hole.png"; //character/char_blue_2.png
  static const String arrowLeft = "assets/images/arrow_left.png"; //character/char_blue_2.png
  static const String coin = "assets/images/coin.png"; //character/char_blue_2.png
  static const String arrowUp = "assets/images/arrow_up.png";

  static const String attack = "assets/images/attack.png"; //character/char_blue_2.png
}

mixin EnemyAssets {
  static const String path = "character/";
  static const String goblinIdle = "${path}Goblin/Idle.png";
  static const String goblinSwordAttack = "${path}Goblin/swordSwing.png";
  static const String goblinDie = "${path}Goblin/Death.png";
  static const String goblinHarm = "${path}Goblin/harm.png";
  static const String goblinRun = "${path}Goblin/Run.png";
  static const String goblinBombing = "${path}Goblin/Bombing.png";
  static const String goblinBombingThrow = "${path}Goblin/goblin.png";

  static const String flyingEyeDeath = "${path}Flying_eye/death.png";
  static const String flyingEyeThrow = "${path}Flying_eye/Attack3.png";
  static const String flyingEyeFlight = "${path}Flying_eye/flight.png";
  static const String flyingEyeHarmed = "${path}Flying_eye/harmed.png";
  static const String flyingEyeBombing = "${path}Flying_eye/projectile_sprite.png";
  static const String flyingEyeAttack = "${path}Flying_eye/attack.png";

  static const String mushroomIdle = "${path}Mushroom/Idle.png";
  static const String mushroomRun = "${path}Mushroom/Run.png";
  static const String mushroomHarmed = "${path}Mushroom/harmed.png";
  static const String mushroomDeath = "${path}Mushroom/Death.png";
  static const String mushroomAttack = "${path}Mushroom/attack.png";
  static const String mushroomThrow = "${path}Mushroom/Attack3.png";

  static const String skeletonIdle = "${path}Skeleton/Idle.png";
  static const String skeletonRun = "${path}Skeleton/Walk.png";
  static const String skeletonAttack = "${path}Skeleton/attack.png";
  static const String skeletonHarmed = "${path}Skeleton/harmed.png";
  static const String skeletonDead = "${path}Skeleton/death.png";
  static const String skeletonShield = "${path}Skeleton/Shield.png";
  static const String skeletonThrow = "${path}Skeleton/Attack3.png";
}

mixin AssetSvg {
  static const String path = "assets/svg/";
  static const String instagram = "${path}insta.svg";
  static const String linkedIn = "${path}linkedin.svg";
  static const String flutter = "${path}flutter.svg";
  static const String flame = "${path}fire.svg";
  static const String woodBt = "${path}woodbt.svg";
  static const String woodSqBt = "${path}woodsqbt.svg";
}
