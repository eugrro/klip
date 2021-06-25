import 'package:flutter/material.dart';
import "./Constants.dart";
import "./utils.dart";

ThemeData darkTheme = ThemeData(
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: backgroundWhite,
      fontSize: 16 + textChange,
    ),
    bodyText2: TextStyle(
      color: hintColor,
      fontSize: 16 + textChange,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: purpleColor,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: backgroundBlack,
);

ThemeData lightTheme = ThemeData(
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: invertColor(backgroundWhite),
      fontSize: 16 + textChange,
    ),
    bodyText2: TextStyle(
      color: invertColor(hintColor),
      fontSize: 16 + textChange,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: invertColor(purpleColor),
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: invertColor(backgroundBlack),
);
