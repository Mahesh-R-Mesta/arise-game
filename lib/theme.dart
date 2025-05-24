import 'package:flutter/material.dart';

ThemeData theme() => ThemeData(
    fontFamily: 'VCR',
    textTheme: TextTheme(),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.white)))),
    elevatedButtonTheme: ElevatedButtonThemeData());
