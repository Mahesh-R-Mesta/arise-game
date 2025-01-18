import 'dart:async';

import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/storage.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  late AudioPlayer backgroundPlayer;
  late AudioPlayer playerSound;
  late AudioPlayer coinGrabPlayer;
  late AudioPlayer swordPlayer;
  late AudioPlayer blastPlayer;
  late AudioPlayer boarRoarPlayer;
  late AudioPlayer shieldPlayer;
  StreamSubscription? bgPlayerSubscription;

  bool get enableGameSoundEffect => LocalStorage.instance.effectSoundState;
  set enableGameSoundEffect(bool state) => LocalStorage.instance.enableEffectSound = state;

  initialize() {
    backgroundPlayer = AudioPlayer(playerId: "bg");
    coinGrabPlayer = AudioPlayer(playerId: "cn");
    playerSound = AudioPlayer(playerId: "pl");
    swordPlayer = AudioPlayer(playerId: "sw");
    blastPlayer = AudioPlayer(playerId: "bp");
    boarRoarPlayer = AudioPlayer(playerId: 'br');
    shieldPlayer = AudioPlayer(playerId: 'sh');
    if (LocalStorage.instance.bgSoundState) _playBackground();
  }

  disableBgMusic() {
    LocalStorage.instance.enableBgSound = false;
    backgroundPlayer.stop();
    bgPlayerSubscription?.cancel();
  }

  enableBgMusic() {
    LocalStorage.instance.enableBgSound = true;
    _playBackground();
  }

  _playBackground() async {
    await backgroundPlayer.play(AssetSource(AudioAsset.background), volume: 0.3);
    bgPlayerSubscription = backgroundPlayer.onPlayerComplete.listen((_) => _playBackground());
  }

  pauseBackground() {
    if (LocalStorage.instance.bgSoundState) backgroundPlayer.pause();
  }

  resumeBackground() {
    if (LocalStorage.instance.bgSoundState) backgroundPlayer.resume();
  }

  _playEffect(AudioPlayer player, String assetAudio, {double? volume = 0.5, bool stopOld = true}) async {
    if (!enableGameSoundEffect) return;
    if (player.state == PlayerState.playing && stopOld) await player.stop();
    await player.play(AssetSource(assetAudio), volume: volume);
  }

  playCoinReceive() async => _playEffect(coinGrabPlayer, AudioAsset.coin);

  playSwordSound() async => _playEffect(swordPlayer, AudioAsset.swordSwing, stopOld: false);

  playBlastSound() async => _playEffect(blastPlayer, AudioAsset.bomb, volume: 0.5);

  playRoarBoar() async => _playEffect(boarRoarPlayer, AudioAsset.boar, volume: 0.6);

  playShield() async => _playEffect(shieldPlayer, AudioAsset.shield, volume: 0.6);

  hurt() async => _playEffect(playerSound, AudioAsset.playerHurt);

  bool isBGNotPlaying() => backgroundPlayer.state != PlayerState.playing;
  bool isBGPlaying() => backgroundPlayer.state == PlayerState.playing;
  bool isBGCompleted() => backgroundPlayer.state == PlayerState.completed;

  stop() async {
    await backgroundPlayer.stop();
    await coinGrabPlayer.stop();
    await playerSound.stop();
    await blastPlayer.stop();
    await swordPlayer.stop();
    await boarRoarPlayer.stop();
  }

  dispose() async {
    await backgroundPlayer.release();
    await coinGrabPlayer.release();
    await playerSound.release();
    await blastPlayer.dispose();
    await swordPlayer.dispose();
    await boarRoarPlayer.dispose();
  }
}
