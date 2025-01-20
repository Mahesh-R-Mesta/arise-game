import 'dart:async';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/game/component/helper/ground_character.dart';
import 'package:arise_game/util/enum/wizard_enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Wizard extends GroundCharacterEntity with HasGameRef<AriseGame> {
  Wizard({super.position}) : super(scale: Vector2(1.3, 1.3), anchor: Anchor.center);
  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    size = Vector2.all(140);
    final idle =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.idle.asset), amount: 10, stepTime: 0.2, textureSize: Vector2.all(140));
    final walk =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.walk.asset), amount: 8, stepTime: 0.2, textureSize: Vector2.all(140));
    final run =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.run.asset), amount: 8, stepTime: 0.1, textureSize: Vector2.all(140));
    final attack =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.attack.asset), amount: 12, stepTime: 0.2, textureSize: Vector2.all(140));
    final jump =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.jump.asset), amount: 3, stepTime: 0.2, textureSize: Vector2.all(140));
    final harm =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.harm.asset), amount: 3, stepTime: 0.2, textureSize: Vector2.all(140));
    final fall =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.fall.asset), amount: 3, stepTime: 0.2, textureSize: Vector2.all(140));
    final death =
        spriteAnimationSequence(image: gameRef.images.fromCache(WizardState.die.asset), amount: 18, stepTime: 0.2, textureSize: Vector2.all(140));
    animations = {
      WizardState.idle: idle,
      WizardState.attack: attack,
      WizardState.fall: fall,
      WizardState.jump: jump,
      WizardState.run: run,
      WizardState.die: death,
      WizardState.harm: harm,
      WizardState.walk: walk
    };
    add(RectangleHitbox(anchor: Anchor.center, position: Vector2(size.x / 2, size.y / 2), size: Vector2(32, 54)));
    current = WizardState.attack;
    return super.onLoad();
  }
}
