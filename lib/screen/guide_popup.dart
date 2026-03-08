import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuidePopup extends StatelessWidget {
  final BuildContext context;
  const GuidePopup({required this.context, super.key});

  show() async => await showDialog(
        barrierColor: Colors.black87.withValues(alpha: 0.7),
        useSafeArea: true,
        context: context,
        builder: (ctx) => GuidePopup(context: ctx),
      );

  @override
  Widget build(BuildContext context) {
    final duration = 400.ms;
    final delayStep = 100.ms;

    return Center(
      child: Container(
        width: 340.w,
        constraints: BoxConstraints(maxHeight: 520.h),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.black.withValues(alpha: 0.8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    _buildHeader(context),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                        child: Column(
                          children: [
                            _SectionHeader(title: "MOVEMENT", delay: delayStep),
                            _buildMovementGrid(delayStep * 2),
                            SizedBox(height: 24.h),
                            _SectionHeader(title: "ACTIONS", delay: delayStep * 3),
                            _buildActionGrid(delayStep * 4),
                            SizedBox(height: 24.h),
                            _SectionHeader(title: "JOYSTICK MODE", delay: delayStep * 5),
                            _buildJoystickInfo(delayStep * 6),
                            SizedBox(height: 32.h),
                            _buildObjectiveSection(delayStep * 7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: duration).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutCubic),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 40.w),
          Text(
            'HOW TO PLAY',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Colors.white70, size: 28.sp),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildMovementGrid(Duration delay) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      children: [
        _ControlCard(
          asset: GameAssets.characterBlue,
          icon: RotatedBox(quarterTurns: 2, child: Image.asset(GameAssets.arrowLeft, width: 22.h, height: 22.h)),
          text: "Move Left",
          flipX: true,
          delay: delay,
          animationData: SpriteAnimationData.sequenced(
            texturePosition: Vector2(0, 56 * 2),
            amount: 8,
            amountPerRow: 8,
            stepTime: 0.1,
            textureSize: Vector2(56, 56),
          ),
        ),
        _ControlCard(
          asset: GameAssets.characterBlue,
          icon: Image.asset(GameAssets.arrowLeft, width: 22.h, height: 22.h),
          text: "Move Right",
          delay: delay + 50.ms,
          animationData: SpriteAnimationData.sequenced(
            texturePosition: Vector2(0, 56 * 2),
            amount: 8,
            amountPerRow: 8,
            stepTime: 0.1,
            textureSize: Vector2(56, 56),
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(Duration delay) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      children: [
        _ControlCard(
          asset: GameAssets.characterBlue,
          icon: Image.asset(GameAssets.arrowUp, width: 22.h, height: 22.h),
          text: "Jump",
          delay: delay,
          animationData: SpriteAnimationData.sequenced(
            texturePosition: Vector2(0, 56 * 3),
            amount: 16,
            amountPerRow: 8,
            stepTime: 0.06,
            textureSize: Vector2(56, 56),
          ),
        ),
        _ControlCard(
          asset: GameAssets.characterBlue,
          icon: Image.asset(GameAssets.attack, width: 22.h, height: 22.h),
          text: "Attack",
          delay: delay + 50.ms,
          animationData: SpriteAnimationData.sequenced(
            texturePosition: Vector2(0, 56),
            amount: 8,
            amountPerRow: 8,
            stepTime: 0.1,
            textureSize: Vector2(56, 56),
          ),
        ),
      ],
    );
  }

  Widget _buildJoystickInfo(Duration delay) {
    return Column(
      children: [
        Text(
          "Enable Joystick in Settings for precise movement",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white60,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 100.h,
          width: 100.h,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12),
          ),
          child: Joystick(
            base: JoystickBase(
              size: 80,
              decoration: JoystickBaseDecoration(color: Colors.white.withValues(alpha: 0.1)),
              arrowsDecoration: JoystickArrowsDecoration(color: Colors.white24),
            ),
            listener: (_) {},
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay).slideY(begin: 0.1);
  }

  Widget _buildObjectiveSection(Duration delay) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.05), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stars_rounded, color: Colors.amberAccent, size: 24.sp),
          SizedBox(width: 12.w),
          Flexible(
            child: Text(
              "Collect coins & kill monsters to win!",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideY(begin: 0.1);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Duration delay;
  const _SectionHeader({required this.title, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.amberAccent.withValues(alpha: 0.8),
            fontWeight: FontWeight.w900,
            fontSize: 13.sp,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(delay: delay).slideY(begin: 0.2),
        Container(
          height: 1.h,
          width: 40.w,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.amberAccent.withValues(alpha: 0.4), Colors.transparent],
            ),
          ),
        ).animate().fadeIn(delay: delay + 50.ms).scaleX(begin: 0),
        SizedBox(height: 4.h),
      ],
    );
  }
}

class _ControlCard extends StatelessWidget {
  final String asset;
  final Widget icon;
  final String text;
  final SpriteAnimationData animationData;
  final bool flipX;
  final Duration delay;

  const _ControlCard({
    required this.asset,
    required this.icon,
    required this.text,
    required this.animationData,
    this.flipX = false,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: 0.8,
                  child: SizedBox(
                    width: 65.h,
                    height: 65.h,
                    child: Transform.flip(
                      flipX: flipX,
                      child: SpriteAnimationWidget.asset(path: asset, data: animationData),
                    ),
                  ),
                ),
              )),
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                SizedBox(height: 2.h),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).scale(begin: const Offset(0.95, 0.95));
  }
}
