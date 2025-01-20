import 'package:arise_game/util/constant/assets_constant.dart';

enum WizardState {
  idle(EnemyAssets.wizardIdle),
  walk(EnemyAssets.wizardWalk),
  run(EnemyAssets.wizardRun),
  jump(EnemyAssets.wizardJump),
  fall(EnemyAssets.wizardFall),
  harm(EnemyAssets.wizardHarm),
  attack(EnemyAssets.wizardAttack),
  die(EnemyAssets.wizardDeath);

  final String asset;
  const WizardState(this.asset);
}
