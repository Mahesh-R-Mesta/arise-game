import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WoodenSquareButton extends StatelessWidget {
  final Size size;
  final Widget widget;
  final void Function() onTap;
  const WoodenSquareButton({super.key, required this.size, required this.onTap, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: SizedBox.fromSize(
          size: size,
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/svg/woodsqbt.svg",
                height: size.height,
                width: size.width,
                fit: BoxFit.fill,
              ),
              Align(alignment: Alignment.center, child: widget)
            ],
          ),
        ));
  }
}
