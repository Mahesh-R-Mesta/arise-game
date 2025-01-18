class Level {
  final String map;
  final List<String> instructions;
  final String level;
  final bool isFinal;
  final List<Conversation> conversation;

  Level({required this.level, required this.map, required this.instructions, this.isFinal = false, this.conversation = const []});

  static List<Level> levels = [
    Level(
        level: "Level - 1",
        instructions: ["Kill monsters", "Collect coins"],
        map: "tile_map_01.tmx",
        conversation: [
          Conversation(key: "pc-1", doText: "GO", message: "I will destroy all these monster and reallocate people back to this village")
        ]),
    Level(level: "Level - 2", instructions: ["Kill monsters", "Find sword"], map: "tile_map_02.tmx"),
    Level(level: "Level - 3", instructions: ["Kill monsters", "Get out from jungle"], map: "tile_map_03.tmx", isFinal: true)
  ];
}

class Conversation {
  final String key;
  final String? doText;
  final String message;
  Conversation({required this.key, required this.doText, required this.message});
}
