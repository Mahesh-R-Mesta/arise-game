import 'package:flutter/material.dart';

class InfoPopup extends StatelessWidget {
  final BuildContext context;
  const InfoPopup({super.key, required this.context});

  show() => showDialog(context: context, builder: (ctx) => InfoPopup(context: ctx));
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * 0.7,
        height: size.height * 0.7,
        child: Material(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.black54,
          child: Column(children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close, color: Colors.white, size: 35))),
            Text("Credits", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white)),
            Text("Game by: Mahesh mesta", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
            //Sound Effect by <a href="https://pixabay.com/users/freesound_community-46691455/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=86585">freesound_community</a> from <a href="https://pixabay.com/sound-effects//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=86585">Pixabay</a>
            //Sound Effect by <a href="https://pixabay.com/users/karim-nessim-40448081/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=260274">karim nessim</a> from <a href="https://pixabay.com/sound-effects//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=260274">Pixabay</a>
          ]),
        ),
      ),
    );
  }
}
