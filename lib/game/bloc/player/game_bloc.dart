import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/game/bloc/player/game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial(level: 1)) {
    on<GameStart>(_onGameStart);
    on<GamePause>(_onGamePause);
    on<GameResume>(_onGameResume);
    on<GameNextLevel>(_nextLevel);
    on<GameRestart>(_onRestartGame);
    on<GameEnd>(_onGameEnd);
  }

  _onGameStart(GameEvent event, Emitter emit) {
    if (event is GameStart) {
      emit(GameRunning(restart: false, level: event.level));
    }
  }

  _onGamePause(GameEvent event, Emitter emit) {
    if (event is GamePause) {
      emit(GameStopped(level: state.level));
    }
  }

  _onGameResume(GameEvent event, Emitter emit) {
    if (event is GameResume) {
      emit(GameRunning(restart: false, level: state.level));
    }
  }

  _onGameEnd(GameEvent event, Emitter emit) {
    if (event is GameEnd) {
      emit(GameInitial(level: state.level));
    }
  }

  _nextLevel(GameEvent event, Emitter emit) {
    if (event is GameNextLevel) {
      emit(GameRunning(restart: false, level: event.level));
    }
  }

  _onRestartGame(GameEvent event, Emitter emit) {
    if (event is GameRestart) {
      emit(GameRunning(restart: true, level: state.level));
    }
  }
}
