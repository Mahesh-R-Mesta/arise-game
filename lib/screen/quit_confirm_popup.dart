import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuitConfirmation extends StatelessWidget {
  final BuildContext context;
  const QuitConfirmation({super.key, required this.context});

  show() => showDialog(context: context, builder: (ctx) => QuitConfirmation(context: ctx));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
        child: SizedBox(
      width: size.width * 0.4,
      height: 150,
      child: Material(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Are you sure want to exit?", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                IconButton(
                  onPressed: () => SystemNavigator.pop(animated: true),
                  icon: Icon(Icons.check, color: Colors.red, size: 40),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.green, size: 40),
                ),
              ])
            ],
          )),
    ));
  }
}
