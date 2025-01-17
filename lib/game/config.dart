mixin GameViewConfig {
  static bool debugMode = false;
  static bool groundAllDebugMode = false;
  static bool onlyBottomGroundDebug = false;
  static const bool playerDebug = false;
  static const bool monsterDebug = false;
  static const double ACTUAL_TILE = 24;
  static const double MODIFIED_TILE = 64;

  static double incValue() => MODIFIED_TILE / ACTUAL_TILE;
  static double fractionValue() => ACTUAL_TILE / MODIFIED_TILE;
}
