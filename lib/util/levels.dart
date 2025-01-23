// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/overlay/game_activity_overlay.dart';
import 'package:arise_game/util/constant/assets_constant.dart';

class Level {
  final String map;
  final List<String> instructions;
  final String level;
  final bool isFinal;
  final List<Conversation> conversation;

  Level({required this.level, required this.map, required this.instructions, this.isFinal = false, this.conversation = const []});

  startConversation(String talkId, AriseGame game, {Function? onCompete, Function(int)? indexEvent}) {
    final converse = conversation.firstWhere((talk) => talk.key == talkId);
    talk(int index) {
      indexEvent?.call(index);
      game.overlays.addEntry(converse.talks[index].key, (_, g) {
        return GameActivityOverlayButton(
            onTap: () {
              game.overlays.remove(converse.talks[index].key);
              if (index == converse.talks.length - 1) {
                onCompete?.call();
                return;
              }
              talk(index + 1);
            },
            image: converse.talks[index].image,
            character: converse.talks[index].character,
            message: converse.talks[index].message,
            doText: converse.talks[index].doText);
      });
      game.overlays.add(converse.talks[index].key);
    }

    talk(0);
  }

  static List<Level> levels = [
    Level(
        level: "Level - 1",
        instructions: ["Kill monsters", "Collect coins"],
        map: "tile_map_01.tmx",
        conversation: [
          Conversation(key: "playStart", talks: [
            PlayerTalk(key: "pc-1", doText: "NEXT", message: "Hi, my name is Shreehan, and I am a skilled warrior"),
            PlayerTalk(key: "pc-2", doText: "NEXT", message: "I have arrived in this village to free it from the monsters"),
            PlayerTalk(key: "pc-3", doText: "NEXT", message: "and to restore my people to their rightful homes"),
            PlayerTalk(key: "pc-4", doText: "YES", message: "I believe I can count on your support to help me accomplish this mission")
          ])
        ]),
    Level(level: "Level - 2", instructions: ["Kill monsters", "Find sword"], map: "tile_map_02.tmx"),
    Level(
        level: "Level - 3",
        instructions: ["Kill monsters", "Get out from jungle"],
        map: "tile_map_03.tmx",
        conversation: [
          Conversation(key: "heroVsWizard", talks: [
            PlayerTalk(
                image: AppAsset.wizard,
                character: "Wizard",
                key: 'w-31',
                message: "Ah, the warrior! So, it was you who dared to slay my minions.",
                doText: "NEXT"),
            PlayerTalk(key: 'pc-32', message: "Because of your tyranny, my people were forced to abandon their homeland!", doText: "NEXT"),
            PlayerTalk(key: 'pc-33', message: "But today, I will ensure you face justice for your wickedness!", doText: "NEXT"),
            PlayerTalk(
                image: AppAsset.wizard,
                character: "Wizard",
                key: 'w-31',
                message: "Ha! Foolish child. You believe you can defeat me? Such delusions amuse me!",
                doText: "NEXT"),
          ]),
          Conversation(key: "playEnd", talks: [
            PlayerTalk(key: 'pc-32', message: "Hurray! I have successfully accomplished my mission", doText: "NEXT"),
            PlayerTalk(key: 'pc-33', message: "Now, I can return and guide my people back to their rightful homes", doText: "DONE"),
          ])
        ],
        isFinal: true)
  ];
}

class Conversation {
  final String key;
  final List<PlayerTalk> talks;
  Conversation({
    required this.key,
    required this.talks,
  });
}

class PlayerTalk {
  final String key;
  final String? doText;
  final String message;
  final String character;
  final String image;
  PlayerTalk({required this.key, this.image = AppAsset.hero, this.character = "Shreehan", required this.doText, required this.message});
}
