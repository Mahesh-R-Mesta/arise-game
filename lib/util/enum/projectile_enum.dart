enum Projectile {
  bomb("character/Goblin/bombing.png", 19, 11, 3, 100),
  mushroomBomb("character/Mushroom/Projectile_sprite.png", 8, 4, 2, 50),
  swordSwing("character/Skeleton/Sword_sprite.png", 8, 0, 3, 92),
  eyeBomb("character/Flying_eye/projectile_sprite.png", 8, 3, 2, 48);

  final String asset;
  final int frameCount;
  final int damageFrame;
  final double blastInt;
  final double size;
  const Projectile(this.asset, this.frameCount, this.damageFrame, this.blastInt, this.size);
}
