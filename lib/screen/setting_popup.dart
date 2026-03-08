import 'dart:ui';
import 'package:arise_game/game/bloc/player_character.dart';
import 'package:arise_game/service/audio.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/enum/player_enum.dart';
import 'package:arise_game/util/widget/toast.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class SettingsPopup extends StatelessWidget {
  final BuildContext context;
  const SettingsPopup({super.key, required this.context});

  show() => showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (ctx) => SettingsPopup(context: ctx),
      );

  @override
  Widget build(BuildContext context) {
    final audioPlayer = GetIt.I.get<AudioService>();
    final bgAudioEffectNotifier = ValueNotifier<bool>(audioPlayer.isBGPlaying());
    final gameSoundEffectNotifier = ValueNotifier<bool>(audioPlayer.enableGameSoundEffect);
    final isJoyStickControlNotifier = ValueNotifier<bool>(LocalStorage.instance.joystickState);
    final nameTextController = TextEditingController(text: LocalStorage.instance.playerName);
    final focusNode = FocusNode();

    final duration = 400.ms;
    final delayStep = 100.ms;

    return Center(
      child: Container(
        width: 0.85.sw,
        height: 0.8.sh,
        constraints: BoxConstraints(maxWidth: 600.w, maxHeight: 450.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Material(
              color: Colors.black.withValues(alpha: 0.75),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10, width: 1.5),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    // Character Sidebar
                    _buildCharacterSidebar(delayStep),

                    // Settings Main Content
                    Expanded(
                      child: Column(
                        children: [
                          _buildHeader(context),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPlayerNameSection(nameTextController, focusNode, delayStep * 2),
                                  SizedBox(height: 24.h),
                                  _SectionTitle(title: "CONTROLS", delay: delayStep * 3),
                                  _buildControlSettings(isJoyStickControlNotifier, delayStep * 4),
                                  SizedBox(height: 24.h),
                                  _SectionTitle(title: "AUDIO", delay: delayStep * 5),
                                  _buildAudioSettings(audioPlayer, bgAudioEffectNotifier, gameSoundEffectNotifier, delayStep * 6),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: duration).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutCubic),
    );
  }

  Widget _buildCharacterSidebar(Duration delay) {
    return Container(
      width: 130.w,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: const Border(right: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              "HEROES",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              itemCount: PlayerCharacter.values.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return CharacterBox(
                  player: PlayerCharacter.values[index],
                  size: 100.w,
                  delay: delay + (index * 50).ms,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 2,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Colors.white38, size: 28.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerNameSection(TextEditingController controller, FocusNode focusNode, Duration delay) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PLAYER NAME",
          style: TextStyle(color: Colors.white54, fontSize: 11.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                  ),
                  hintText: "Enter Name",
                  hintStyle: const TextStyle(color: Colors.white24),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _ActionButton(
              onPressed: () async {
                focusNode.unfocus();
                final name = controller.text.trim();
                LocalStorage.instance.setPlayerName = name;
                await GetIt.I.get<LeaderboardDatabase>().updatePlayerName(name);
                ToastMessage(message: "Name Saved!", gravity: ToastGravity.BOTTOM).show();
              },
              icon: Icons.check_rounded,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: delay).slideX(begin: 0.05);
  }

  Widget _buildControlSettings(ValueNotifier<bool> notifier, Duration delay) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, isJoystick, _) {
        return Row(
          children: [
            Expanded(
              child: _ToggleOption(
                label: "Buttons",
                isSelected: !isJoystick,
                onTap: () {
                  LocalStorage.instance.enableJoystick = false;
                  notifier.value = false;
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ToggleOption(
                label: "Joystick",
                isSelected: isJoystick,
                onTap: () {
                  LocalStorage.instance.enableJoystick = true;
                  notifier.value = true;
                },
              ),
            ),
          ],
        );
      },
    ).animate().fadeIn(delay: delay).slideX(begin: 0.05);
  }

  Widget _buildAudioSettings(AudioService audio, ValueNotifier<bool> bgN, ValueNotifier<bool> fxN, Duration delay) {
    return Column(
      children: [
        _AudioToggle(
          label: "Music",
          notifier: bgN,
          onToggle: (val) {
            val ? audio.enableBgMusic() : audio.disableBgMusic();
          },
        ),
        SizedBox(height: 12.h),
        _AudioToggle(
          label: "Effects",
          notifier: fxN,
          onToggle: (val) {
            audio.enableGameSoundEffect = val;
          },
        ),
      ],
    ).animate().fadeIn(delay: delay).slideX(begin: 0.05);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Duration delay;
  const _SectionTitle({required this.title, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.amberAccent.withValues(alpha: 0.7),
          fontWeight: FontWeight.w900,
          fontSize: 12.sp,
          letterSpacing: 2,
        ),
      ).animate().fadeIn(delay: delay).slideX(begin: -0.1),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amberAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.amberAccent.withValues(alpha: 0.5) : Colors.white10,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isSelected ? Colors.amberAccent : Colors.white60,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _AudioToggle extends StatelessWidget {
  final String label;
  final ValueNotifier<bool> notifier;
  final Function(bool) onToggle;

  const _AudioToggle({required this.label, required this.notifier, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, enabled, _) {
        return InkWell(
          onTap: () {
            notifier.value = !enabled;
            onToggle(notifier.value);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Icon(
                  enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: enabled ? Colors.blueAccent : Colors.white24,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch.adaptive(
                  value: enabled,
                  activeColor: Colors.blueAccent,
                  onChanged: (val) {
                    notifier.value = val;
                    onToggle(val);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  const _ActionButton({required this.onPressed, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 48.h,
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
      ),
    );
  }
}

class CharacterBox extends StatelessWidget {
  final PlayerCharacter player;
  final double size;
  final Duration delay;
  const CharacterBox({super.key, required this.player, required this.size, required this.delay});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCharacterCubit, PlayerCharacter>(
      builder: (context, selectedPlayer) {
        final isSelected = selectedPlayer == player;
        return InkWell(
          onTap: () => context.read<PlayerCharacterCubit>().setPlayerType(player),
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedScale(
            scale: isSelected ? 1.0 : 0.9,
            duration: 200.ms,
            child: AnimatedContainer(
              duration: 200.ms,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.white10,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: -2,
                        )
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SpriteAnimationWidget.asset(
                  key: Key(player.name),
                  path: player.asset2,
                  data: SpriteAnimationData.sequenced(
                    texturePosition: Vector2(0, 10),
                    amount: 10,
                    amountPerRow: 8,
                    stepTime: 0.1,
                    textureSize: Vector2(56, 56),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: delay).scale(begin: const Offset(0.8, 0.8));
  }
}
