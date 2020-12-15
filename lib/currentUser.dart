import 'package:flutter/material.dart';

String uid = "testUID";
String uName = "testUserName";
String fName = "testFirstName";
String lName = "testLastName";
String email = "testEmail@gmail.com";
int numViews = 0;
int numKredits = 0;
String bio = "Sample bio text for the current user";
String avatarLink =
    "https://klip-avatars.s3.amazonaws.com/" + uid + "_avatar.jpg";
Image userProfileImg = Image.network(avatarLink);

String getFullName() {
  return fName + " " + lName;
}
