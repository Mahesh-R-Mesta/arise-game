import 'package:audioplayers/audioplayers.dart';

class AudioService {
  late AudioPlayer backgroundPlayer;
  late AudioPlayer coinGrabPlayer;
  initialize() {
    backgroundPlayer = AudioPlayer(playerId: "bg");
    coinGrabPlayer = AudioPlayer(playerId: "cn");
  }

  playCoinReceive() async {
    await coinGrabPlayer.play(AssetSource("audio/got_coin.mp3"), volume: 0.4);
  }

  playBackground() async => await backgroundPlayer.play(AssetSource("audio/background.mp3"), volume: 0.5);

  // playBgRepeat() => backgroundPlayer.onPlayerComplete.listen((_) => playBackground());

  pauseBackground() => backgroundPlayer.pause();

  resumeBackground() => backgroundPlayer.resume();

  dispose() {
    backgroundPlayer.stop();
    coinGrabPlayer.stop();
    backgroundPlayer.release();
    coinGrabPlayer.release();
  }
}
