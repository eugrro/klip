import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'Navigation.dart';

class MyTheme extends ChangeNotifier {
  Color darkColor = Color(0xff282828);
  Color lightColor = Color(0xfff8f8f8);
  //Color darkColor = Colors.black;
  //Color lightColor = Colors.white;
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
    updateBottomNavBarColor();
    notifyListeners();
  }

  void changeToDarkMode({bool changeTheme = true}) {
    _background = darkColor;
    _foreground = lightColor;
    _hintColor = greyColor;
    if (changeTheme) currentTheme = "Dark";
    setStatusBarDark();
    updateBottomNavBarColor();
    notifyListeners();
  }

  void changeToSystemMode() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    currentTheme = "System";
    updateBottomNavBarColor();
    if (brightness == Brightness.light)
      changeToLightMode(changeTheme: false);
    else
      changeToDarkMode(changeTheme: false);
  }

  void setStatusBarDark() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: _background,
        systemNavigationBarColor: darkColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void updateBottomNavBarColor() {
    //think this has to do something with the value listenable builder
    showBottomNavBar.value = !showBottomNavBar.value;
    showBottomNavBar.value = !showBottomNavBar.value;
  }

  void setStatusBarLight() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: _background,
        systemNavigationBarColor: lightColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
