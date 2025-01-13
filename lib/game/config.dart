mixin GameViewConfig {
  static bool debugMode = true;
  static bool groundDebugMode = false;
  static const double ACTUAL_TILE = 24;
  static const double MODIFIED_TILE = 64;
  static double incValue() => MODIFIED_TILE / ACTUAL_TILE;
  static double fractionValue() => ACTUAL_TILE / MODIFIED_TILE;
}
