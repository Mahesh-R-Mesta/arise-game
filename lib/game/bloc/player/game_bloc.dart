import 'package:arise_game/game/bloc/player/game_event.dart';
import 'package:arise_game/game/bloc/player/game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial(restart: 0, level: 1)) {
    on<GameStart>(_onGameStart);
    on<GamePause>(_onGamePause);
    on<GameResume>(_onGameResume);
    on<GameNextLevel>(_nextLevel);
    on<GameRestart>(_onRestartGame);
    on<GameEnd>(_onGameEnd);
  }

  _onGameStart(GameStart event, Emitter emit) {
    emit(GameRunning(restart: 0, level: event.level));
  }

  _onGamePause(GamePause event, Emitter emit) {
    int restartCount = 0;
    if (state is GameRunning) {
      restartCount = (state as GameRunning).restart;
    }
    emit(GameStopped(restart: restartCount, level: state.level));
  }

  _onGameResume(GameResume event, Emitter emit) {
    int restartCount = 0;
    if (state is GameStopped) {
      restartCount = (state as GameStopped).restart;
    }
    emit(GameRunning(restart: restartCount, level: state.level));
  }

  _onGameEnd(GameEnd event, Emitter emit) {
    emit(GameInitial(restart: 0, level: 1));
  }

  _nextLevel(GameNextLevel event, Emitter emit) {
    emit(GameRunning(restart: 0, level: event.level));
  }

  _onRestartGame(GameRestart event, Emitter emit) {
    int restartCount = 0;
    if (state is GameRunning) {
      restartCount = (state as GameRunning).restart;
    } else if (state is GameStopped) {
      restartCount = (state as GameStopped).restart;
    }
    emit(GameRunning(restart: restartCount + 1, level: state.level));
  }
}
