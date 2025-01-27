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

  removeTalk(String talkId, AriseGame game) {
    final talks = conversation.firstWhere((talk) => talk.key == talkId);
    for (final talk in talks.talks) {
      if (game.overlays.activeOverlays.contains(talk.key) == true) {
        game.overlays.remove(talk.key);
      }
    }
  }

  static List<Level> levels = [
    Level(
        level: "The Warrior’s Return (Level 1)",
        instructions: [
          "Fight through the overrun village and uncover the source of the monsters",
          "Find the mysterious portal to continue your journey"
        ],
        map: "tile_map_01.tmx",
        conversation: [
          Conversation(key: "playStart", talks: [
            PlayerTalk(key: "pc-1", doText: "NEXT", message: "Hi, my name is Shreehan, and I am a skilled warrior"),
            PlayerTalk(
                key: "pc-1",
                doText: "NEXT",
                message:
                    "This was my father’s village, a simple place where we lived in peace... until the wizard turned it into a den of monsters."),
            PlayerTalk(key: "pc-2", doText: "NEXT", message: "I have arrived in this village to free it from the monsters"),
            PlayerTalk(key: "pc-3", doText: "NEXT", message: "and to restore my people to their rightful homes"),
            PlayerTalk(key: "pc-4", doText: "YES", message: "I believe I can count on your support to help me accomplish this mission")
          ]),
          Conversation(key: "wizardPortal", talks: [
            PlayerTalk(key: "pc-5", doText: "NEXT", message: "What... is this? It hums with a strange power, like nothing I’ve ever seen"),
            PlayerTalk(
                key: "pc-6",
                doText: "NEXT",
                message: "Could this be the wizard’s doing? If it leads to answers, I have no choice but to step through"),
          ])
        ]),
    Level(
        level: "Through the Veil (Level 2)",
        instructions: ["Explore the twisted version of the village, defeat stronger monsters", "And retrieve the magical sword to kill wizard"],
        map: "tile_map_02.tmx",
        conversation: [
          Conversation(key: "wizardPortal", talks: [
            PlayerTalk(key: "pc-6", doText: "NEXT", message: "What... is this? It hums with a strange power, like nothing I’ve ever seen"),
            PlayerTalk(
                key: "pc-7",
                doText: "NEXT",
                message: "Could this be the wizard’s doing? If it leads to answers, I have no choice but to step through"),
          ]),
          Conversation(key: "magicalSword", talks: [
            PlayerTalk(
                key: "pc-8",
                doText: "NEXT",
                message: "What’s this? A sword... but it’s unlike any weapon I’ve ever seen. It radiates power, as if it’s alive."),
            PlayerTalk(
                key: "pc-9",
                doText: "PICK IT",
                message: "This isn’t just steel... it’s magic. Could this be the key to defeating the wizard and his monsters?"),
          ])
        ]),
    Level(
        level: "The Wizard’s Palace (Level 3)",
        instructions: ["Storm the wizard’s palace, defeat his minions", "Face the wizard himself. End his reign of terror and save the village"],
        map: "tile_map_03.tmx",
        conversation: [
          Conversation(key: "playStart", talks: [
            PlayerTalk(key: 'pc-10', message: "Finally, I've reached the wizard’s palace", doText: "NEXT"),
            PlayerTalk(key: 'pc-11', message: "This is it—my final challenge. I must see it through, no matter the cost", doText: "NEXT"),
          ]),
          Conversation(key: "heroVsWizard", talks: [
            PlayerTalk(
                image: AppAsset.wizard,
                character: "Wizard",
                key: 'w-31',
                message: "So, the brave warrior has arrived... The one who slaughtered my creations",
                doText: "NEXT"),
            PlayerTalk(key: 'pc-12', message: "Because of your tyranny, my people were forced to abandon their homeland!", doText: "NEXT"),
            PlayerTalk(key: 'pc-13', message: "But today, I will ensure you face justice for your wickedness!", doText: "NEXT"),
            PlayerTalk(
                image: AppAsset.wizard,
                character: "Wizard",
                key: 'w-32',
                message: "Ha ha ha! Such bold words! Do you truly believe you can defeat me? Foolish child, you’re no match for my power.",
                doText: "DONE"),
          ]),
          Conversation(key: "playEnd", talks: [
            PlayerTalk(key: 'pc-14', message: "Hurray! I have successfully accomplished my mission", doText: "NEXT"),
            PlayerTalk(key: 'pc-15', message: "Now, I can return and guide my people back to their rightful homes", doText: "DONE"),
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
