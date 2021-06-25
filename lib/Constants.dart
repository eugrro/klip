import 'package:flutter/material.dart';
import './utils.dart';
import 'package:theme_provider/theme_provider.dart';
import "./themes.dart";

///Constants file throughout the app
///widgets will be in global_widgets

Color purpleColor = Color(0xff6E5Ac9);
Color backgroundBlack = Color(0xff282828);
Color backgroundWhite = Color(0xfff8f8f8);
Color hintColor = Color(0xffc0c0c0);
double textChange = 0;
Widget tempAvatar = Image.asset("lib/assets/images/tempAvatar.png");

//All themes
List<AppTheme> allThemes = [
  //Dark Theme
  AppTheme(
      id: "dark",
      data: darkTheme,
      description: "The Default Dark Theme"),
  //LightTheme
  AppTheme(
      id: "light",
      data: lightTheme,
      description: "The Default Dark Inverted"),
];

const double bottomNavBarHeight = 55;
double statusBarHeight = 0;
const String StripePKey =
    "pk_test_51IOnY5Hau82X1Y1fc6l4P6QUfpK6euFX8ULZ3PLpCAG0rObkmlwt7g5k20eFCJzmdFUtZl18wF8kFVZYrqsMuYKa002zcUpSaa";
//testing

String nodeURL = "https://klipweb.com/"; //Hosted Server in the Cloud
//String nodeURL = "http://10.0.2.2:3000/";   //Local Server for emulator
// String nodeURL = "http://192.168.50.13:3000/"; //Local Server for physical device (your ip)
//DO NOT MODIFY THIS VARIABLE IN THE CODE
bool checkedProfileImage = false;
