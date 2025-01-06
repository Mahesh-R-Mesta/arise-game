import 'package:arise_game/game/bloc/player_character.dart';
import 'package:arise_game/game/component/player.dart';
import 'package:arise_game/util/audio.dart';

import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
// import 'package:image/image.dart' as img;

class SettingsPopup extends StatelessWidget {
  final BuildContext context;
  const SettingsPopup({super.key, required this.context});

  show() => showDialog(context: context, builder: (ctx) => SettingsPopup(context: ctx));

  @override
  Widget build(BuildContext context) {
    final audioPlayer = GetIt.I.get<AudioService>();
    final bgAudioEffectNotifier = ValueNotifier<bool>(audioPlayer.isBGPlaying());
    final gameSoundEffectNotifier = ValueNotifier<bool>(audioPlayer.enableGameSoundEffect);

    return Center(
      child: SizedBox.expand(
        child: Material(
          elevation: 3,
          color: Colors.black54,
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      spacing: 10,
                      children: [
                        Text("Select character", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white)),
                        CharacterBox(player: PlayerCharacter.blue, size: 116),
                        CharacterBox(player: PlayerCharacter.red, size: 116),
                        CharacterBox(player: PlayerCharacter.purple, size: 116),
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.topRight,
                              child:
                                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close, color: Colors.white, size: 40))),
                          IconButton(
                              onPressed: () {
                                if (audioPlayer.isBGPlaying()) {
                                  audioPlayer.disableBgMusic();
                                  bgAudioEffectNotifier.value = false;
                                } else if (audioPlayer.isBGNotPlaying()) {
                                  audioPlayer.enableBgMusic();
                                  bgAudioEffectNotifier.value = true;
                                }
                              },
                              icon: Row(
                                children: [
                                  ValueListenableBuilder<bool>(
                                      valueListenable: bgAudioEffectNotifier,
                                      builder: (context, isPlaying, _) {
                                        return Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_off, color: Colors.white, size: 40);
                                      }),
                                  const SizedBox(width: 15),
                                  Text("BACKGROUND MUSIC", style: TextStyle(fontSize: 18, color: Colors.white)),
                                ],
                              )),
                          IconButton(
                              onPressed: () {
                                gameSoundEffectNotifier.value = !gameSoundEffectNotifier.value;
                                audioPlayer.enableGameSoundEffect = gameSoundEffectNotifier.value;
                              },
                              icon: Row(
                                children: [
                                  ValueListenableBuilder<bool>(
                                      valueListenable: gameSoundEffectNotifier,
                                      builder: (context, isPlaying, _) {
                                        return Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_off, color: Colors.white, size: 40);
                                      }),
                                  const SizedBox(width: 15),
                                  Text("GAME SOUND EFFECT", style: TextStyle(fontSize: 18, color: Colors.white)),
                                ],
                              )),
                        ],
                      ),
                    ))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class CharacterBox extends StatelessWidget {
  final PlayerCharacter player;
  final double size;
  const CharacterBox({super.key, required this.player, required this.size});

  @override
  Widget build(BuildContext context) {
    final spriteAnimation = SpriteAnimationWidget.asset(
        key: Key(player.name),
        path: player.asset2,
        loadingBuilder: (ctx) => CircularProgressIndicator(),
        data:
            SpriteAnimationData.sequenced(texturePosition: Vector2(0, 10), amount: 10, amountPerRow: 8, stepTime: 0.1, textureSize: Vector2(56, 56)));
    return BlocBuilder<PlayerCharacterCubit, PlayerCharacter>(builder: (context, selectedPlayer) {
      final isSelected = selectedPlayer == player;
      return InkWell(
        onTap: () => context.read<PlayerCharacterCubit>().setPlayerType(player),
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: isSelected ? Colors.blueAccent : Colors.white, width: isSelected ? 3 : 1)),
          child: SizedBox.fromSize(
            size: Size.square(size), //(58 * 2, 58 * 2),
            child: spriteAnimation,
          ),
        ),
      );
    });
  }
}
