mixin GameViewConfig {
  static const double ACTUAL_TILE = 32;
  static const double MODIFIED_TILE = 64;

  static double incValue() => MODIFIED_TILE / ACTUAL_TILE;
}
