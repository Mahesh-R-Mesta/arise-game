abstract class GameState {
  final int level;
  final int restart;
  GameState({required this.restart, required this.level});
}

class GameInitial extends GameState {
  GameInitial({required super.restart, required super.level});
}

class GameRunning extends GameState {
  GameRunning({required super.restart, required super.level});
}

class GameStopped extends GameState {
  GameStopped({required super.restart, required super.level});
}
