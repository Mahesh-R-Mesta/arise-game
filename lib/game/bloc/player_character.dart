import 'package:arise_game/util/enum/player_enum.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerCharacterCubit extends Cubit<PlayerCharacter> {
  PlayerCharacterCubit() : super(LocalStorage.instance.getPlayerCharacter);

  setPlayerType(PlayerCharacter type) {
    LocalStorage.instance.setPlayerCharacter = type;
    emit(type);
  }
}
