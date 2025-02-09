import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage extends StatelessWidget {
  final String message;
  final ToastGravity gravity;
  const ToastMessage({super.key, required this.message, this.gravity = ToastGravity.BOTTOM});

  show() {
    final fToast = FToast();
    fToast.showToast(child: ToastMessage(message: message), gravity: gravity, fadeDuration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 10.r),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
    );
  }
}
