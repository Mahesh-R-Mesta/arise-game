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

mixin GameAssets {
  static const String character = "character/"; //character/char_blue_2.png
  static const String characterBlue2 = "${character}char_blue_2.png"; //character/
  static const String characterRed2 = "${character}char_red_2.png"; //character/char_blue_2.png
  static const String characterPurple2 = "${character}char_purple_2.png"; //character/char_blue_2.png

  static const String characterBlue = "${character}char_blue.png"; //character/char_blue_2.png
  static const String characterRed = "${character}char_red.png"; //character/char_blue_2.png
  static const String characterPurple = "${character}char_purple.png";
  static const String fire = "fire.png";
  static const String wormhole = "worm_hole.png"; //character/char_blue_2.png
  static const String arrowLeft = "assets/images/arrow_left.png"; //character/char_blue_2.png
  static const String coin = "assets/images/coin.png"; //character/char_blue_2.png
  static const String arrowUp = "assets/images/arrow_up.png";

  static const String attack = "assets/images/attack.png"; //character/char_blue_2.png
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
