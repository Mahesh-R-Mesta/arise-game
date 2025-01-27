import 'package:arise_game/service/audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EarnedCoinCubit extends Cubit<int> {
  EarnedCoinCubit() : super(0);

  final gameAudio = GetIt.I.get<AudioService>();
  int lastCoinEarned = 0;

  reset() => emit(0);

  checkLastPoint() => lastCoinEarned = state;

  revertPoint() => emit(lastCoinEarned);

  receivedCoin(int amount) {
    gameAudio.playCoinReceive();
    emit(state + amount);
  }
}
