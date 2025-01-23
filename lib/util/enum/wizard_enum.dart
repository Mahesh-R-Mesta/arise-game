import 'package:arise_game/util/constant/assets_constant.dart';

enum WizardState {
  idle(EnemyAssets.wizardIdle),
  run(EnemyAssets.wizardRun),
  attack(EnemyAssets.wizardAttack),
  die(EnemyAssets.wizardDeath),
  harm(EnemyAssets.wizardDeath);

  final String asset;
  const WizardState(this.asset);
}
