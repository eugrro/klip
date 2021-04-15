import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
String avatarLink = getAWSLink(uid);
Future<Widget> userProfileImg = getProfileImage(uid + "_avatar.jpg", avatarLink);
List<String> currentUserFollowing = [];
List<String> currentUserFollowers = [];
List<String> currentUserSubscribing = [];
List<String> currentUserSubscribers = [];
String getAWSLink(uid) {
  return "https://avatars-klip.s3.amazonaws.com/" + uid + "_avatar.jpg";
}

bool signedInWithGoogle = false;

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

//avatarURI is just the uid+_avatar.jpg avatarLink is the full AWS Link
Future<Widget> getProfileImage(String avatarURI, String avatarLink) async {
  if (await doesObjectExistInS3(avatarURI, "avatars-klip") == "ObjectFound") {
    return Image.network(avatarLink);
  } else {
    return Image.asset("lib/assets/images/tempAvatar.png");
  }
}

void storeUserToSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setInt('numViews', numViews);
  prefs.setInt('numKredits', numKredits);

  prefs.setString("uid", uid);
  prefs.setString("uName", uName);
  prefs.setString("fName", fName);
  prefs.setString("lName", lName);
  prefs.setString("email", email);
  prefs.setString("gamertag", gamertag);
  prefs.setString("bio", bio);
  prefs.setString("avatarLink", avatarLink);
  prefs.setString("avatarLink", avatarLink);
  prefs.setStringList("currentUserFollowing", currentUserFollowing);
  prefs.setStringList("currentUserFollowers", currentUserFollowers);
  prefs.setStringList("currentUserSubscribing", currentUserSubscribing);
  prefs.setStringList("currentUserSubscribers", currentUserSubscribers);
}

void pullUserFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numKredits = pullFieldFromSharedPreferences("numKredits", prefs);
  uid = pullFieldFromSharedPreferences("uid", prefs);
  uName = pullFieldFromSharedPreferences("uName", prefs);
  fName = pullFieldFromSharedPreferences("fName", prefs);
  lName = pullFieldFromSharedPreferences("lName", prefs);
  email = pullFieldFromSharedPreferences("email", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);
  numViews = pullFieldFromSharedPreferences("numViews", prefs);

}

dynamic pullFieldFromSharedPreferences(String field, SharedPreferences prefs) async {
  return prefs.get(field);
}
