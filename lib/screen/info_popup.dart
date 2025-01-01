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
            Text("Game by: Mahesh mesta", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
          ]),
        ),
      ),
    );
  }
}
