class Level {
  final String map;
  final List<String> instructions;
  final String level;

  Level({required this.level, required this.map, required this.instructions});

  static List<Level> levels = [
    Level(level: "Level - 1", instructions: ["Kill monsters", "Collect coins"], map: "tile_map_01.tmx"),
    Level(level: "Level - 2", instructions: ["Kill monsters", "Find sword"], map: "tile_map_02.tmx"),
    Level(level: "Level - 3", instructions: ["Kill monsters", "Get out from jungle"], map: "tile_map_03.tmx")
  ];
}
