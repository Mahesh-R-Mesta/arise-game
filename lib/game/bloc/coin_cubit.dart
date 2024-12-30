import 'package:flutter_bloc/flutter_bloc.dart';

class EarnedCoin extends Cubit<int> {
  EarnedCoin() : super(0);

  receivedCoin(int amount) {
    emit(state + amount);
  }
}
