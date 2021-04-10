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
Future<Widget> userProfileImg = getProfileImage(uid + "_avatar.jpg");
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

Future<Widget> getProfileImage(String avatarLink) async {
  if (await doesObjectExistInS3(avatarLink, "avatars-klip") == "ObjectFound") {
    return Image.network(avatarLink);
  } else {
    return Image.asset("lib/assets/images/tempAvatar.png");
  }
}
