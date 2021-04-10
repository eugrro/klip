import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Requests.dart';

String uid = "testUID";
String uName = "testUserName";
String fName = "testFirstName";
String lName = "testLastName";
String email = "testEmail@gmail.com";
int numViews = 0;
int numKredits = 0;
String gamertag = "eugro";
String bio = "Sample bio text for the current user";
String avatarLink = "https://avatars-klip.s3.amazonaws.com/" + uid + "_avatar.jpg";
Future<Widget> userProfileImg = setProfileImage();
List<String> currentUserFollowing = [];
List<String> currentUserSubscribing = [];

void displayCurrentUser() {
  try {
    print("========================");
    print("uid: " + uid);
    print("Username: " + uName);
    print("Name: " + fName + " " + lName);
    print("email: " + email);
    print("========================");
  } catch (e) {
    print("Ran into error displaying current user: " + e.toString());
  }
}

Future<Widget> setProfileImage() async {
  if (await doesObjectExistInS3(uid + "_avatar.jpg", "avatars-klip") == "ObjectFound") {
    return Image.network(avatarLink);
  } else {
    return Image.asset("lib/assets/images/tempAvatar.png");
  }
}
