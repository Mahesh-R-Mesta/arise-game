import 'package:arise_game/game/utils/audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EarnedCoin extends Cubit<int> {
  EarnedCoin() : super(0);

  final gameAudio = GetIt.I.get<AudioService>();

  reset() => emit(0);

  receivedCoin(int amount) {
    gameAudio.playCoinReceive();
    emit(state + amount);
  }
}
