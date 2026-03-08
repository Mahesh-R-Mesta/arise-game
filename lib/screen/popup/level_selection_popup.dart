import 'dart:ui';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelSelection extends StatelessWidget {
  final BuildContext context;
  final Function(int) onLevelSelect;
  const LevelSelection({super.key, required this.context, required this.onLevelSelect});

  show() => showDialog(
      context: context,
      builder: (ctx) => LevelSelection(
          context: ctx,
          onLevelSelect: (level) {
            Navigator.of(ctx).pop();
            onLevelSelect.call(level);
          }));

  @override
  Widget build(BuildContext context) {
    final levelCompleted = LocalStorage.instance.maxLevelCompleted;
    final size = MediaQuery.of(context).size;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: size.width * 0.5,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 25.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white10, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "SELECT LEVEL",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.sp,
                      color: Colors.amberAccent,
                      letterSpacing: 2.5,
                    ),
                  ).animate().fadeIn().slideY(begin: -0.3),
                  SizedBox(height: 25.h),
                  _LevelItem(
                    level: 1,
                    label: "LEVEL 1",
                    isLocked: false,
                    onSelect: onLevelSelect,
                    delay: 100,
                  ),
                  SizedBox(height: 12.h),
                  _LevelItem(
                    level: 2,
                    label: "LEVEL 2",
                    isLocked: levelCompleted < 2,
                    onSelect: onLevelSelect,
                    delay: 200,
                  ),
                  SizedBox(height: 12.h),
                  _LevelItem(
                    level: 3,
                    label: "LEVEL 3",
                    isLocked: levelCompleted < 3,
                    onSelect: onLevelSelect,
                    delay: 300,
                  ),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "CLOSE",
                      style: TextStyle(color: Colors.white38, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9));
  }
}

class _LevelItem extends StatelessWidget {
  final int level;
  final String label;
  final bool isLocked;
  final Function(int) onSelect;
  final int delay;

  const _LevelItem({
    required this.level,
    required this.label,
    required this.isLocked,
    required this.onSelect,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.5 : 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          WoodenButton(
            text: label,
            size: Size(180.w, 55.h),
            onTap: isLocked ? () {} : () => onSelect.call(level),
          ),
          if (isLocked)
            Positioned(
              right: 15.w,
              child: Icon(Icons.lock_outline_rounded, color: Colors.white24, size: 20.sp),
            ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1);
  }
}
