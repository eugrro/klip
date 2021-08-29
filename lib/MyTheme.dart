import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MyTheme extends ChangeNotifier {
  String currentTheme;
  Color _background;
  Color get background => _background;
  Color _foreground;
  Color get foreground => _foreground;
  Color _hintColor;
  Color get hintColor => _hintColor;

  void changeToLightMode({bool changeTheme = true}) {
    _background = Color(0xfff8f8f8);
    _foreground = Color(0xff282828);
    _hintColor = Color(0xffa0a0a0);
    if (changeTheme) currentTheme = "Light";
    notifyListeners();
  }

  void changeToDarkMode({bool changeTheme = true}) {
    _background = Color(0xff282828);
    _foreground = Color(0xfff8f8f8);
    _hintColor = Color(0xffa0a0a0);
    if (changeTheme) currentTheme = "Dark";
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
}
