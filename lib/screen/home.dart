import 'package:arise_game/game/game.dart';
import 'package:arise_game/screen/info_popup.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Image.asset("assets/images/background/background_layer_1.png", height: size.height, width: size.width, fit: BoxFit.fill),
            SizedBox.expand(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/app/logo.png", width: 150, height: 150),
                  WoodenButton(
                      size: Size(150, 55),
                      text: 'NEW GAME',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => GamePage()))),
                  WoodenButton(size: Size(100, 55), text: 'INFO', onTap: () => InfoPopup(context: context).show()),
                  WoodenButton(size: Size(90, 55), text: 'QUIT', onTap: () => Navigator.of(context).pop())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
