import 'package:audioplayers/audioplayers.dart';

class AudioService {
  late AudioPlayer backgroundPlayer;
  late AudioPlayer playerSound;
  late AudioPlayer coinGrabPlayer;
  initialize() {
    backgroundPlayer = AudioPlayer(playerId: "bg");
    coinGrabPlayer = AudioPlayer(playerId: "cn");
    playerSound = AudioPlayer(playerId: "pl");
  }

  playCoinReceive() async {
    await coinGrabPlayer.play(AssetSource("audio/got_coin.mp3"), volume: 0.4);
  }

  playBackground() async => await backgroundPlayer.play(AssetSource("audio/background.mp3"), volume: 0.5);

  // playBgRepeat() => backgroundPlayer.onPlayerComplete.listen((_) => playBackground());

  pauseBackground() => backgroundPlayer.pause();

  resumeBackground() => backgroundPlayer.resume();

  // attack() => playerSound

  hurt() {
    if (playerSound.state != PlayerState.playing) {
      playerSound.play(AssetSource("audio/manhurt.mp3"));
    }
  }

  dispose() {
    backgroundPlayer.stop();
    coinGrabPlayer.stop();
    backgroundPlayer.release();
    coinGrabPlayer.release();
    playerSound.release();
  }
}
