import 'dart:ui';

import 'package:leap/leap.dart';

class GameField extends PhysicalEntity {
  @override
  void onLoad() {
    debugColor = Color(0xFF00FF00);
    super.onLoad();
  }
}
