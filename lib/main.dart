import 'dart:ui';
import './Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UserPage.dart';
import 'login/Login.dart';
import './Constants.dart' as Constants;

void main() {
  runApp(MyApp());
}

//LOOK INTO THIS https://pub.dev/packages/animated_text_kit

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klips',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Constants.purpleColor,
          selectionColor: Constants.purpleColor.withOpacity(.5),
          cursorColor: Constants.purpleColor,
        ),
        scaffoldBackgroundColor: Constants.backgroundBlack,
      ),
      home: Navigation(),
    );
  }
}
