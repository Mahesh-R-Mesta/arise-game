import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage extends StatelessWidget {
  final String message;
  const ToastMessage({super.key, required this.message});

  show() {
    final fToast = FToast();
    fToast.showToast(child: ToastMessage(message: message), gravity: ToastGravity.BOTTOM, fadeDuration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }
}
