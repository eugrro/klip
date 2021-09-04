import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class MyTheme extends ChangeNotifier {
  //Color darkColor = Color(0xff282828);
  //Color lightColor = Color(0xfff8f8f8);
  Color darkColor = Colors.black;
  Color lightColor = Colors.white;
  Color greyColor = Color(0xffa0a0a0);
  Color purpleColor = Color(0xff6E5Ac9);

  String currentTheme;
  Color _background;
  Color get background => _background;
  Color _foreground;
  Color get foreground => _foreground;
  Color _hintColor;
  Color get hintColor => _hintColor;

  void changeToLightMode({bool changeTheme = true}) {
    _background = lightColor;
    _foreground = darkColor;
    _hintColor = greyColor;
    if (changeTheme) currentTheme = "Light";
    setStatusBarLight();
    notifyListeners();
  }

  void changeToDarkMode({bool changeTheme = true}) {
    _background = darkColor;
    _foreground = lightColor;
    _hintColor = greyColor;
    if (changeTheme) currentTheme = "Dark";
    setStatusBarDark();
    notifyListeners();
  }

  void changeToSystemMode() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    currentTheme = "System";
    if (brightness == Brightness.light)
      changeToLightMode(changeTheme: false);
    else
      changeToDarkMode(changeTheme: false);
  }

  void setStatusBarDark() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green,
        systemNavigationBarColor: darkColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void setStatusBarLight() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green,
        systemNavigationBarColor: lightColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}
