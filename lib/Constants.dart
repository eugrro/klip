import 'package:flutter/material.dart';
import './utils.dart';

import 'MyTheme.dart';

///Constants file throughout the app
///widgets will be in global_widgets
var theme = MyTheme();
Color purpleColor = Color(0xff6E5Ac9);
//Color backgroundBlack = Color(0xff282828);
//Color backgroundBlack = Colors.black;
//Color backgroundWhite = Color(0xfff8f8f8);
//Color backgroundWhite = Colors.black;
Color hintColor = Color(0xffa0a0a0);
double textChange = 0;
Widget tempAvatar = Image.asset("lib/assets/images/tempAvatar.png");

const double bottomNavBarHeight = 55;
double statusBarHeight = 0;
const String StripePKey = "pk_test_51IOnY5Hau82X1Y1fc6l4P6QUfpK6euFX8ULZ3PLpCAG0rObkmlwt7g5k20eFCJzmdFUtZl18wF8kFVZYrqsMuYKa002zcUpSaa";
//testing

//String nodeURL = "https://klipweb.com/"; //Hosted Server in the Cloud
//String nodeURL = "http://10.0.2.2:3000/";   //Local Server for emulator
String nodeURL = "http://192.168.1.150:3000/"; //Local Server for physical device (your ip)

//DO NOT MODIFY THIS VARIABLE IN THE CODE
bool checkedProfileImage = false;

int maxBioLength = 100;
