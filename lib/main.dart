import 'dart:convert';
import 'dart:ui';
import 'package:klip/login/StartPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Constants.dart' as Constants;

void main() {
  runApp(MyApp());
}

//LOOK INTO THIS https://pub.dev/packages/animated_text_kit

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool darkTheme = false;
  void toggleTheme() {
    darkTheme = darkTheme ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Constants.purpleColor.withOpacity(0),
        //statusBarIconBrightness: Brightness.light,
        //statusBarBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      home: StartPage(),
      theme: darkTheme ? Constants.darkTheme : Constants.lightTheme,
    );
  }
}

Map<String, Widget Function(BuildContext)> klipRoutes = {
  '/': (context) => StartPage(),
  //'/second': (context) => SecondScreen(),
};

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
