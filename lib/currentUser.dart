import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Requests.dart';

String uid = "testUID";
String uName = "testUserName";
String fName = "testFirstName";
String lName = "testLastName";
String email = "testEmail@gmail.com";
String numViews = "0";
String numKredits = "0";
String gamertag = "eugro";
String bio = "Sample bio text for the current user";
String bioLink = "";
String avatarLink = getAWSLink(uid);
Future<Widget> userProfileImg = getProfileImage(uid + "_avatar.jpg", avatarLink);
List<dynamic> currentUserFollowing = [];
List<dynamic> currentUserFollowers = [];
List<dynamic> currentUserSubscribing = [];
List<dynamic> currentUserSubscribers = [];
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
  print("Storing user to shared preferences");
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('numViews', numViews);
  prefs.setString('numKredits', numKredits);

  prefs.setString("uid", uid);
  print("SETTING UID TO: " + uid);
  prefs.setString("uName", uName);
  prefs.setString("bioLink", bioLink);
  prefs.setString("fName", fName);
  prefs.setString("lName", lName);
  prefs.setString("email", email);
  prefs.setString("gamertag", gamertag);
  prefs.setString("bio", bio);
  prefs.setString("avatarLink", avatarLink);
  prefs.setStringList("currentUserFollowing", currentUserFollowing.cast<String>());
  prefs.setStringList("currentUserFollowers", currentUserFollowers.cast<String>());
  prefs.setStringList("currentUserSubscribing", currentUserSubscribing.cast<String>());
  prefs.setStringList("currentUserSubscribers", currentUserSubscribers.cast<String>());
}

Future<String> setFieldInSharedPreferences(String key, dynamic value) async {
  final prefs = await SharedPreferences.getInstance();
  print("Setting " + key + " to " + value.toString() + " in shared preferences");
  if (value is int) {
    prefs.setInt(key, value);
    return "SetSucessful";
  } else if (value is String) {
    prefs.setString(key, value);
    return "SetSucessful";
  } else if (value is List) {
    prefs.setStringList(key, value.cast<String>());
    return "SetSucessful";
  } else {
    return "InvalidValueType";
  }
}

void pullUserFromSharedPreferences() async {
  print("Pulling user from shared preferences");
  final prefs = await SharedPreferences.getInstance();
  numViews = await pullFieldFromSharedPreferences("numViews", prefs);
  print(numViews);
  numKredits = await pullFieldFromSharedPreferences("numKredits", prefs);
  uid = await pullFieldFromSharedPreferences("uid", prefs);
  print(uid);
  uName = await pullFieldFromSharedPreferences("uName", prefs);
  fName = await pullFieldFromSharedPreferences("fName", prefs);
  lName = await pullFieldFromSharedPreferences("lName", prefs);
  email = await pullFieldFromSharedPreferences("email", prefs);
  print(email);
  gamertag = await pullFieldFromSharedPreferences("gamertag", prefs);
  bio = await pullFieldFromSharedPreferences("bio", prefs);
  bioLink = await pullFieldFromSharedPreferences("bioLink", prefs);
  avatarLink = await pullFieldFromSharedPreferences("avatarLink", prefs);
  try {
    currentUserFollowing = (await pullFieldFromSharedPreferences("currentUserFollowing", prefs)).toList();
    currentUserFollowers = (await pullFieldFromSharedPreferences("currentUserFollowers", prefs)).toList();
    currentUserSubscribing = (await pullFieldFromSharedPreferences("currentUserSubscribing", prefs)).toList();
    currentUserSubscribers = (await pullFieldFromSharedPreferences("currentUserSubscribers", prefs)).toList();
  } catch (err) {
    print("Ran Into Error! pullUserFromSharedPreferences => " + err.toString());
  }
}

dynamic pullFieldFromSharedPreferences(String field, SharedPreferences prefs) async {
  if (prefs.containsKey(field)) {
    return prefs.get(field);
  } else {
    return "FieldNotFound";
  }
}

void clearSharedPreferences() async {
  print("Clearing Shared Preferences");
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
