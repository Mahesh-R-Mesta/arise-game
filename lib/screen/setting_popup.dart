import 'package:arise_game/game/bloc/player_character.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:arise_game/util/widget/toast.dart';

import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
// import 'package:image/image.dart' as img;

class SettingsPopup extends StatelessWidget {
  final BuildContext context;
  const SettingsPopup({super.key, required this.context});

  show() => showDialog(context: context, barrierColor: Colors.black87.withAlpha(190), builder: (ctx) => SettingsPopup(context: ctx));

  @override
  Widget build(BuildContext context) {
    final audioPlayer = GetIt.I.get<AudioService>();
    final bgAudioEffectNotifier = ValueNotifier<bool>(audioPlayer.isBGPlaying());
    final gameSoundEffectNotifier = ValueNotifier<bool>(audioPlayer.enableGameSoundEffect);
    final isJoyStickControlNotifier = ValueNotifier<bool>(LocalStorage.instance.joystickState);
    final nameTextController = TextEditingController(text: LocalStorage.instance.playerName);
    final _focusNode = FocusNode();

    void updateControlState(bool isJoyStick) {
      LocalStorage.instance.enableJoystick = isJoyStick;
      isJoyStickControlNotifier.value = isJoyStick;
    }

    return SizedBox.expand(
      child: Material(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                flex: 1,
                child: Column(
                  spacing: 10,
                  children: [
                    const SizedBox(height: 10),
                    Text("Select character", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 12,
                          children: [
                            CharacterBox(player: PlayerCharacter.blue, size: 116),
                            CharacterBox(player: PlayerCharacter.red, size: 116),
                            CharacterBox(player: PlayerCharacter.purple, size: 116),
                            CharacterBox(player: PlayerCharacter.green, size: 116)
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topRight,
                            child:
                                IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close, color: Colors.white, size: 40.sp))),
                        Row(
                          children: [
                            Text("Player name:", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19, color: Colors.white)),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 200.w,
                              child: TextField(
                                focusNode: _focusNode,
                                style: TextStyle(color: Colors.white, fontSize: 19),
                                controller: nameTextController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton.icon(
                                onPressed: () async {
                                  _focusNode.unfocus();
                                  LocalStorage.instance.setPlayerName = nameTextController.text.trim();
                                  await GetIt.I.get<LeaderboardDatabase>().updatePlayerName(nameTextController.text.trim());
                                  ToastMessage(message: "Player name updated successfully", gravity: ToastGravity.BOTTOM).show();
                                },
                                icon: Icon(Icons.check, color: Colors.white, size: 35),
                                label: Text("Done")),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Divider(color: Colors.white),
                        Text("CONTROL SETTINGS", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
                        Divider(color: Colors.white),
                        ValueListenableBuilder(
                            valueListenable: isJoyStickControlNotifier,
                            builder: (context, isJoyStick, _) {
                              return Row(
                                children: [
                                  InkWell(
                                      onTap: () => updateControlState(false),
                                      child: Text("Buttons control",
                                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.white))),
                                  Radio<bool>(
                                      value: isJoyStick,
                                      groupValue: false,
                                      onChanged: (value) => updateControlState(false),
                                      fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                        if (states.contains(WidgetState.disabled)) {
                                          return Colors.white.withAlpha(100);
                                        }
                                        return Colors.white;
                                      })),
                                  SizedBox(width: 50.w),
                                  InkWell(
                                      onTap: () => updateControlState(true),
                                      child: Text("Joystick control",
                                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.white))),
                                  Radio(
                                      value: isJoyStick,
                                      groupValue: true,
                                      onChanged: (value) => updateControlState(true),
                                      fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                        if (states.contains(WidgetState.disabled)) {
                                          return Colors.white.withAlpha(100);
                                        }
                                        return Colors.white;
                                      })),
                                ],
                              );
                            }),
                        SizedBox(height: 35.h),
                        Text("SOUND SETTINGS", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
                        Divider(color: Colors.white),
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
                                      return Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_off, color: Colors.white, size: 40.sp);
                                    }),
                                SizedBox(width: 15.w),
                                Text("BACKGROUND MUSIC", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
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
                                      return Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_off, color: Colors.white, size: 40.sp);
                                    }),
                                SizedBox(width: 15.w),
                                Text("GAME SOUND EFFECT", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
                              ],
                            )),
                      ],
                    ),
                  ),
                ))
          ],
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
