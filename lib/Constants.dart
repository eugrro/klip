import 'package:flutter/material.dart';

///Constants file throughout the app
///widgets will be in global_widgets

Color purpleColor = Color(0xff6E5Ac9);
Color backgroundBlack = Color(0xff191919);
Color backgroundWhite = Color(0xfff8f8f8);
Color hintColor = Color(0xffc0c0c0);
double textChange = 0;
Widget tempAvatar = Image.asset("lib/assets/images/tempAvatar.png");

//const nodeURL = 'http://10.0.2.2:3000/'; //emulator
const nodeURL = 'http://192.168.1.124:3000/'; //troy
//const nodeURL = 'http://192.168.86.28:3000/';  //roseland

TextStyle tStyle({double fontSize = 16}) {
  return TextStyle(color: backgroundWhite, fontSize: fontSize);
}

const double bottomNavBarHeight = 80;
const double animatedBottomSliderHeight = 10;

double statusBarHeight = 0;
const String StripePKey = "pk_test_51IOnY5Hau82X1Y1fc6l4P6QUfpK6euFX8ULZ3PLpCAG0rObkmlwt7g5k20eFCJzmdFUtZl18wF8kFVZYrqsMuYKa002zcUpSaa";
//testing
