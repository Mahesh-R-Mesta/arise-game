// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GameActivityOverlayButton extends StatelessWidget {
  final String message;
  final Size size;
  final Function() onTap;

  const GameActivityOverlayButton({
    super.key,
    required this.onTap,
    required this.size,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox.fromSize(
            size: size,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                children: [
                  SvgPicture.asset(AssetSvg.woodBt, width: size.width, height: size.height, fit: BoxFit.fitWidth),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(message, style: TextStyle(fontSize: 15, color: Colors.white))],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
