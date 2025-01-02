mixin GameViewConfig {
  static bool debugMode = false;
  static bool groundDebugMode = false;
  static const double ACTUAL_TILE = 32;
  static const double MODIFIED_TILE = 64;
  static double incValue() => MODIFIED_TILE / ACTUAL_TILE;
  static double fractionValue() => ACTUAL_TILE / MODIFIED_TILE;
}
