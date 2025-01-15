import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/enum/projectile_enum.dart';

enum MonsterState { idle, running, attack, harm, die, bombing, shield }

enum MonsterType {
  goblin(EnemyAssets.goblinBombingThrow, "", "", "", "", EnemyAssets.goblinDie, 12, Projectile.bomb), //Vector2(32, 40)
  flyingEye(EnemyAssets.flyingEyeThrow, "", "", "", "", EnemyAssets.flyingEyeDeath, 6, Projectile.eyeBomb),
  mushroom(EnemyAssets.mushroomThrow, "", "", "", "", EnemyAssets.mushroomDeath, 11, Projectile.mushroomBomb),
  skeleton(EnemyAssets.skeletonThrow, "", "", "", "", EnemyAssets.skeletonDead, 6, Projectile.swordSwing); // Vector2(32, 80)

  final String bombing;
  final String idle;
  final String attack;
  final String harm;
  final String die;
  final String running;
  final int charCount;
  final Projectile projectile;
  const MonsterType(this.bombing, this.idle, this.running, this.attack, this.harm, this.die, this.charCount, this.projectile);

  static MonsterType parse(String name) {
    switch (name) {
      case "goblin":
        return MonsterType.goblin;
      case "flyingEye":
        return MonsterType.flyingEye;
      case "mushroom":
        return MonsterType.mushroom;
      case "skeleton":
        return MonsterType.skeleton;
      default:
        return MonsterType.goblin;
    }
  }
}
