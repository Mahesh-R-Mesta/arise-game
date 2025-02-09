import 'package:flutter/widgets.dart';

mixin AppConfig {
  static const String appName = 'Arise Game';
  static const String appVersion = '1.0.0';
  static const Size designSize = Size(913.2, 432.0);

  // static double widthOfView(double height) => designSize.width * height / designSize.height;
  // static double heightOfView(double width) => designSize.height * (width / designSize.width);
}
