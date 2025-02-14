import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WoodenButton extends StatelessWidget {
  final Size size;
  final String? text;
  final Widget? widget;
  final void Function() onTap;
  const WoodenButton({super.key, required this.size, this.text, required this.onTap, this.widget}) : assert(widget != null || text != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: SizedBox.fromSize(
          size: size,
          child: Stack(
            children: [
              Image.asset(
                AppAsset.woodButton,
                height: size.height,
                width: size.width,
                fit: BoxFit.fill,
              ),
              Align(
                  alignment: Alignment.center,
                  child: text != null
                      ? Text(
                          text!,
                          style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w500, color: Colors.white),
                        )
                      : widget)
            ],
          ),
        ));
  }
}
