class GameButtonBridge {
  Function(bool)? onLeftMove;
  Function(bool)? onRightMove;
  Function(bool)? onPressJump;
  Function(bool)? onAttack;
  Function()? onDoubleTap;

  void onMoveLeftDown() {
    if (onLeftMove != null) onLeftMove?.call(true);
  }

  void onMoveLeftUp() {
    if (onLeftMove != null) onLeftMove?.call(false);
  }

  void onMoveRightDown() {
    if (onRightMove != null) onRightMove?.call(true);
  }

  void onMoveRightUp() {
    if (onRightMove != null) onRightMove?.call(false);
  }

  void onJumpUp() {
    if (onPressJump != null) onPressJump?.call(false);
  }

  void onJumpDown() {
    if (onPressJump != null) onPressJump?.call(true);
  }

  void attackDown() {
    if (onAttack != null) onAttack?.call(true);
  }

  void attackUp() {
    if (onAttack != null) onAttack?.call(false);
  }

  void attackDoubleTap() {
    if (onDoubleTap != null) onDoubleTap?.call();
  }
}
