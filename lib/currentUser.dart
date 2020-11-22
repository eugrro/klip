import 'package:flutter/material.dart';

String uid = "testUID";
String uName = "testUserName";
String fName = "testFirstName";
String lName = "testLastName";
String email = "testEmail@gmail.com";
int numViews = 0;
int numKredits = 0;
String bio = "Sample bio text for the current user";
Image userProfileImg = Image.asset("lib/assets/images/personOutline.png");

String getFullName() {
  return fName + " " + lName;
}
