// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/constant/color_constant.dart';
import 'package:flutter/material.dart';

class GameActivityOverlayButton extends StatelessWidget {
  final String image;
  final String character;
  final String message;
  final String? doText;
  final Function() onTap;

  const GameActivityOverlayButton({
    super.key,
    this.character = "Shreehan",
    this.image = AppAsset.hero,
    required this.onTap,
    required this.message,
    required this.doText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
          color: Color(0xfffbedea),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2.0, color: Color(0xff9a6c55))),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350, minWidth: 200, minHeight: 69, maxHeight: 85),
            // size: size,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Image.asset(image,
                    width: 40,
                    height: 40,
                    frameBuilder: (_, child, __, ___) => Material(
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(width: 1.5, color: AppColor.darkOrange)),
                        child: child)),
                const SizedBox(width: 5),
                Flexible(
                  child: Text.rich(TextSpan(
                      text: "$character:",
                      children: [TextSpan(text: message, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200))],
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 5),
                if (doText != null)
                  ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        side: BorderSide(width: 1.4, color: AppColor.dimOrange),
                        padding: EdgeInsets.all(3),
                      ),
                      child: Text(doText!, style: TextStyle(color: Colors.white))),
                const SizedBox(width: 5),
                // Text(message, style: TextStyle(fontSize: 15))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
