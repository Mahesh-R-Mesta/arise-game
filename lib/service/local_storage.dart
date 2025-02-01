import 'package:arise_game/util/enum/player_enum.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static LocalStorage get instance => GetIt.I.get<LocalStorage>();
  final _box = GetStorage();
  final String _bgSoundEffect = "BG_SOUND_EFFECT";
  final String _effectSound = "EFFECT_SOUND";
  final String _heroCharacter = "HERO_CHARACTER";
  final String _reviewStatus = "REVIEW_STATUS";
  final String _levelStatus = "LEVEL_STATUS";

  set enableBgSound(bool enable) {
    _box.write(_bgSoundEffect, enable);
  }

  bool get bgSoundState => _box.read<bool>(_bgSoundEffect) ?? true;

  set enableEffectSound(bool enable) => _box.write(_effectSound, enable);
  bool get effectSoundState => _box.read<bool>(_effectSound) ?? true;

  set setReviewRequestedCount(int count) => _box.write(_reviewStatus, count);
  int get reviewRequestCount => _box.read<int>(_reviewStatus) ?? 0;

  set setMaxLevelCompleted(int level) => _box.write(_levelStatus, level);
  int get maxLevelCompleted => _box.read(_levelStatus) ?? 1;

  set setPlayerCharacter(PlayerCharacter character) => _box.write(_heroCharacter, character.index);
  PlayerCharacter get getPlayerCharacter => PlayerCharacter.values[_box.read<int>(_heroCharacter) ?? 0];
}
