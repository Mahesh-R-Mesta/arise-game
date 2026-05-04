import 'dart:ui';

import 'package:arise_game/game/arise_game.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _TourStep {
  final Rect target;
  final String title;
  final String description;
  final bool circle;
  const _TourStep({
    required this.target,
    required this.title,
    required this.description,
    this.circle = false,
  });
}

class GameTour extends StatefulWidget {
  final AriseGame game;
  const GameTour({required this.game, super.key});

  @override
  State<GameTour> createState() => _GameTourState();
}

class _GameTourState extends State<GameTour> {
  int _index = 0;
  late final List<_TourStep> _steps;

  @override
  void initState() {
    super.initState();
    final isJoystick = LocalStorage.instance.joystickState;
    final size =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize / WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    // Match positions used in GameControls.
    final coinRect = Rect.fromLTWH(16.w, 16.h, 130.w, 44.h);

    final hudRight = 16.w;
    final hudTop = 16.h;
    final hudButton = 50.h;
    final hudGap = 12.w;
    final soundOn = LocalStorage.instance.bgSoundState;
    final hudWidth = soundOn ? (hudButton * 2 + hudGap) : hudButton;
    final hudRect = Rect.fromLTWH(size.width - hudRight - hudWidth, hudTop, hudWidth, hudButton);

    final moveRect = isJoystick
        ? Rect.fromLTWH(30.w, size.height - 30.h - 140.w, 140.w, 140.w)
        : Rect.fromLTWH(30.w, size.height - 30.h - 70.h, 70.h * 2 + 20.w, 70.h);

    final attackSize = 80.h;
    final jumpSize = 70.h;
    final actionsBottom = size.height - 30.h;
    final actionsRight = 30.w;
    final attackRect = Rect.fromLTWH(size.width - actionsRight - attackSize, actionsBottom - attackSize, attackSize, attackSize);

    final steps = <_TourStep>[
      _TourStep(
        target: coinRect,
        title: "Coins",
        description: "Collect coins through your adventure. Your total appears here.",
      ),
      _TourStep(
        target: hudRect,
        title: "Sound & Pause",
        description: "Toggle the music or pause the game any time.",
      ),
      _TourStep(
        target: moveRect,
        title: isJoystick ? "Joystick" : "Move",
        description: isJoystick ? "Drag the joystick left or right to move, drag up to jump." : "Tap and hold to move left or right.",
        circle: isJoystick,
      ),
    ];

    if (!isJoystick) {
      final jumpRect = Rect.fromLTWH(size.width - actionsRight - attackSize - 20.w - jumpSize, actionsBottom - jumpSize, jumpSize, jumpSize);
      steps.add(_TourStep(
        target: jumpRect,
        title: "Jump",
        description: "Tap to jump over obstacles and enemies.",
      ));
    }

    steps.add(_TourStep(
      target: attackRect,
      title: "Attack",
      description: "Tap to swing your weapon and defeat enemies.",
      circle: true,
    ));

    _steps = steps;
  }

  void _next() {
    if (_index < _steps.length - 1) {
      setState(() => _index++);
    } else {
      _finish();
    }
  }

  void _finish() {
    LocalStorage.instance.setTourSeen = true;
    widget.game.overlays.remove("gameTour");
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_index];
    final size = MediaQuery.of(context).size;
    final isTop = step.target.center.dy > size.height / 2;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Dim background with cutout.
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _SpotlightPainter(target: step.target, circle: step.circle),
              ),
            ),
          ),

          // Tap-anywhere advance.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _next,
            ),
          ),

          // Tooltip card with title, description and step controls.
          Positioned(
            left: 24.w,
            right: 24.w,
            top: isTop ? size.height * 0.15 : null,
            bottom: isTop ? null : size.height * 0.32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        step.description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _finish,
                            child: Text(
                              "SKIP",
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(_steps.length, (i) {
                              final active = i == _index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                width: active ? 18.w : 8.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: active ? Colors.amberAccent : Colors.white24,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              );
                            }),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _next,
                            child: Text(
                              _index == _steps.length - 1 ? "GOT IT" : "NEXT",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13.sp,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ).animate(key: ValueKey(_index)).fadeIn(duration: 250.ms).slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect target;
  final bool circle;
  _SpotlightPainter({required this.target, required this.circle});

  @override
  void paint(Canvas canvas, Size size) {
    final fullRect = Offset.zero & size;
    final overlay = Path()..addRect(fullRect);
    final inflated = target.inflate(8);
    final hole = Path();
    if (circle) {
      hole.addOval(inflated);
    } else {
      hole.addRRect(RRect.fromRectAndRadius(inflated, const Radius.circular(18)));
    }
    final cutout = Path.combine(PathOperation.difference, overlay, hole);
    final dim = Paint()..color = Colors.black.withValues(alpha: 0.72);
    canvas.drawPath(cutout, dim);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.amberAccent.withValues(alpha: 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);
    if (circle) {
      canvas.drawOval(inflated, glow);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(inflated, const Radius.circular(18)),
        glow,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) => oldDelegate.target != target || oldDelegate.circle != circle;
}
