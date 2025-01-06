abstract class GameState {
  final int level;
  GameState({required this.level});
}

class GameInitial extends GameState {
  GameInitial({required super.level});
}

class GameRunning extends GameState {
  final bool restart;
  GameRunning({required this.restart, required super.level});
}

class GameStopped extends GameState {
  GameStopped({required super.level});
}
