import 'dart:ui';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        padding: EdgeInsets.only(top: 20.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Material(
            color: Color(0xfffbedea),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                constraints: BoxConstraints(maxWidth: 400.w, minWidth: 250.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48.h,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColor.darkOrange, width: 2),
                        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.amberAccent,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (doText != null) ...[
                      SizedBox(width: 14.w),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              doText!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }
}
