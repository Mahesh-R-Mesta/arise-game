import 'dart:ui';
import 'package:arise_game/util/constant/account_link.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPopup extends StatelessWidget {
  final BuildContext context;
  const InfoPopup({super.key, required this.context});

  show() => showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (ctx) => InfoPopup(context: ctx),
      );

  @override
  Widget build(BuildContext context) {
    final duration = 400.ms;
    final delayStep = 100.ms;

    return Center(
      child: Container(
        width: 320.w,
        constraints: BoxConstraints(maxHeight: 500.h),
        margin: EdgeInsets.all(20.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.black.withValues(alpha: 0.7),
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
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                        child: Column(
                          children: [
                            _SectionHeader(title: "ARTWORK", delay: delayStep),
                            _buildArtworkCredits(delayStep * 2),
                            SizedBox(height: 24.h),
                            _SectionHeader(title: "SOUND & MUSIC", delay: delayStep * 3),
                            _buildSoundCredits(delayStep * 4),
                            SizedBox(height: 24.h),
                            _SectionHeader(title: "DEVELOPER", delay: delayStep * 5),
                            _buildDeveloperSection(delayStep * 6),
                            SizedBox(height: 32.h),
                            _buildFooter(delayStep * 7),
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
          SizedBox(width: 40.w), // Spacer for balance
          Text(
            'CREDITS',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
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

  Widget _buildArtworkCredits(Duration delay) {
    return CreditLinkText(
      delay: delay,
      texts: [
        (text: "Free Pixel Artwork by ", link: null),
        (text: "Brullov, ", link: "https://brullov.itch.io/"),
        (text: "Anokolisa, ", link: "https://anokolisa.itch.io/"),
        (text: "Luizmelo, ", link: "https://luizmelo.itch.io/"),
        (text: "Raphael Hatencia, ", link: "https://ragnapixel.itch.io/"),
        (text: "from ", link: null),
        (text: "Itch.io", link: "https://itch.io/game-assets/free")
      ],
    );
  }

  Widget _buildSoundCredits(Duration delay) {
    return CreditLinkText(
      delay: delay,
      texts: [
        (text: "Sound Effects by ", link: null),
        (text: "freesound_community, ", link: "https://pixabay.com/users/freesound_community-46691455/"),
        (text: "karim nessim, ", link: "https://pixabay.com/users/karim-nessim-40448081/"),
        (text: "Cyberwave Orchestra, ", link: "https://pixabay.com/users/cyberwave-orchestra-23801316/"),
        (text: "Ribhav Agrawal, ", link: "https://pixabay.com/users/ribhavagrawal-39286533/"),
        (text: "Music Unlimited ", link: "https://pixabay.com/users/music_unlimited-27600023/"),
        (text: "from ", link: null),
        (text: "Pixabay", link: "https://pixabay.com/music/")
      ],
    );
  }

  Widget _buildDeveloperSection(Duration delay) {
    return Column(
      children: [
        Text(
          "Mahesh R Mesta",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialLink(
              img: AssetSvg.linkedIn,
              link: AccountLink.linkedIn,
              color: const Color(0xFF0077B5),
            ),
            SizedBox(width: 20.w),
            _SocialLink(
              img: AssetSvg.instagram,
              link: AccountLink.instagram,
              color: const Color(0xFFE4405F),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: delay).slideY(begin: 0.1);
  }

  Widget _buildFooter(Duration delay) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Made with  ",
            style: TextStyle(fontSize: 12.sp, color: Colors.white54, fontWeight: FontWeight.w500),
          ),
          _TechIcon(asset: AssetSvg.flutter, label: "Flutter"),
          SizedBox(width: 12.w),
          _TechIcon(asset: AssetSvg.flame, label: "Flame"),
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
            fontSize: 14.sp,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(delay: delay).slideY(begin: 0.2),
        Container(
          height: 1.h,
          width: 30.w,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          color: Colors.amberAccent.withValues(alpha: 0.3),
        ).animate().fadeIn(delay: delay + 50.ms).scaleX(begin: 0),
      ],
    );
  }
}

class _SocialLink extends StatelessWidget {
  final String img;
  final String link;
  final Color color;
  const _SocialLink({required this.img, required this.link, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(link)),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: SvgPicture.asset(img, height: 24.h, width: 24.h, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
      ),
    );
  }
}

class _TechIcon extends StatelessWidget {
  final String asset;
  final String label;
  const _TechIcon({required this.asset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(asset, width: 16.h, height: 16.h),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.white70, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

typedef CreditText = ({String text, String? link});

class CreditLinkText extends StatelessWidget {
  final List<CreditText> texts;
  final Duration delay;
  const CreditLinkText({
    super.key,
    required this.texts,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> children = texts.map((data) {
      if (data.link != null) {
        return TextSpan(
          text: data.text,
          recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse(data.link!)),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent.shade100,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blueAccent.withValues(alpha: 0.4),
          ),
        );
      } else {
        return TextSpan(text: data.text);
      }
    }).toList();

    return Text.rich(
      TextSpan(children: children),
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: Colors.white70,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: delay).slideY(begin: 0.1);
  }
}
