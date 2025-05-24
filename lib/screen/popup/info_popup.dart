// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  show() => showDialog(context: context, builder: (ctx) => InfoPopup(context: ctx));

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 300);
    Widget linkWidget(String text, String img, String link) {
      return InkWell(
        onTap: () => launchUrl(Uri.parse(link)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SvgPicture.asset(img, height: 22.h, width: 22.h),
          SizedBox(width: 8.w),
          Text(text, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue, decoration: TextDecoration.underline))
        ]),
      );
    }

    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * 0.7,
        height: size.height * 0.8,
        child: Material(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(height: 10.h),
                    Text("Credits", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp, color: Colors.white)),
                    SizedBox(height: 10.h),
                    CreditLinkText(texts: [
                      (text: "Free Pixel Artwork by ", link: null),
                      (text: "Brullov, ", link: "https://brullov.itch.io/"),
                      (text: "Anokolisa, ", link: "https://anokolisa.itch.io/"),
                      (text: "Luizmelo, ", link: "https://luizmelo.itch.io/"),
                      (text: "Raphael Hatencia, ", link: "https://ragnapixel.itch.io/"),
                      (text: "from ", link: null),
                      (text: "Itch.io", link: "https://itch.io/game-assets/free")
                    ]),
                    const SizedBox(height: 20),
                    CreditLinkText(texts: [
                      (text: "Free Sound Effects by ", link: null),
                      (
                        text: "freesound_community, ",
                        link:
                            "https://pixabay.com/users/freesound_community-46691455/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=86585"
                      ),
                      (
                        text: "karim nessim, ",
                        link:
                            "https://pixabay.com/users/karim-nessim-40448081/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=260274"
                      ),
                      (
                        text: "Cyberwave Orchestra, ",
                        link:
                            "https://pixabay.com/users/cyberwave-orchestra-23801316/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=241821"
                      ),
                      (
                        text: "Ribhav Agrawal, ",
                        link:
                            "https://pixabay.com/users/ribhavagrawal-39286533/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=230517"
                      ),
                      // Music by <a href=""></a> from <a href="https://pixabay.com/music//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=124008">Pixabay</a>
                      (
                        text: "Music Unlimited",
                        link:
                            "https://pixabay.com/users/music_unlimited-27600023/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=124008"
                      ),
                      (text: " from ", link: null),
                      (
                        text: "Pixabay",
                        link: "https://pixabay.com/music/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=47167"
                      )
                    ]),
                    SizedBox(height: 20.h),
                    Text("Game by: Mahesh R Mesta", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                    SizedBox(height: 10.h),
                    linkWidget("Linked-In", AssetSvg.linkedIn, AccountLink.linkedIn),
                    SizedBox(height: 10.h),
                    linkWidget("Instagram", AssetSvg.instagram, AccountLink.instagram),
                    SizedBox(height: 10.h),
                    Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Made with ", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                      SvgPicture.asset(AssetSvg.flutter, width: 20, height: 20),
                      Text("Flutter ", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                      SvgPicture.asset(AssetSvg.flame, width: 20, height: 20),
                      Text("Flame", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                    ])
                  ]),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close, color: Colors.white, size: 35.sp))),
                ],
              ),
            ),
          ),
        ),
      ).animate().fade(duration: duration, curve: Curves.easeInCubic).scale(duration: duration, curve: Curves.easeInCubic),
    );
  }
}

typedef CreditText = ({String text, String? link});

class CreditLinkText extends StatelessWidget {
  final List<CreditText> texts;
  const CreditLinkText({
    super.key,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> children = texts.map((data) {
      if (data.link != null) {
        return TextSpan(
            text: data.text,
            recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse(data.link!)),
            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.blue, decoration: TextDecoration.underline));
      } else {
        return TextSpan(text: data.text);
      }
    }).toList();

    return Text.rich(TextSpan(children: children),
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white), textAlign: TextAlign.center);
  }
}
