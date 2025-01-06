import 'package:arise_game/util/audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EarnedCoinCubit extends Cubit<int> {
  EarnedCoinCubit() : super(0);

  final gameAudio = GetIt.I.get<AudioService>();

  reset() => emit(0);

  receivedCoin(int amount) {
    gameAudio.playCoinReceive();
    emit(state + amount);
  }
}
