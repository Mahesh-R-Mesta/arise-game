import 'dart:ui';

import 'package:leap/leap.dart';

class GameField extends PhysicalEntity {
  GameField({super.position, super.size, super.anchor});
  @override
  void onLoad() {
    debugColor = Color(0xFF00FF00);
    super.onLoad();
  }
}
