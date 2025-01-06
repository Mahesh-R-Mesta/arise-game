abstract class GameEvent {}

class GameStart extends GameEvent {
  final int level;
  GameStart({required this.level});
}

class GameRestart extends GameEvent {}

class GameNextLevel extends GameEvent {
  final int level;
  GameNextLevel({required this.level});
}

class GamePause extends GameEvent {}

class GameResume extends GameEvent {}

class GameEnd extends GameEvent {}
