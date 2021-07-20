import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Requests.dart';
import './Constants.dart' as Constants;

String uid = "testUID";
String uName = "testUserName";
String fName = "testFirstName";
String lName = "testLastName";
String email = "testEmail@gmail.com";
String numViews = "0";
String numKredits = "0";
String xTag = "";
String bio = "Sample bio text for the current user";
String bioLink = "";
String themePreference = "";
String avatarLink = getAWSLink(uid);
Future<Widget> userProfileImg = getProfileImage(uid + "_avatar.jpg", avatarLink, false);
List<dynamic> currentUserFollowing = [];
List<dynamic> currentUserFollowers = [];
List<dynamic> currentUserSubscribing = [];
List<dynamic> currentUserSubscribers = [];
String getAWSLink(uid) {
  return "https://klip-user-avatars.s3.amazonaws.com/" + uid + "_avatar.jpg";
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

String getParamValue(String val) {
  if (val == uid)
    return uid;
  else if (val == uName)
    return uName;
  else if (val == fName)
    return fName;
  else if (val == lName)
    return lName;
  else if (val == email)
    return email;
  else if (val == numViews)
    return numViews;
  else if (val == numKredits)
    return numKredits;
  else if (val == xTag)
    return xTag;
  else if (val == bio)
    return bio;
  else
    return "";
}

//avatarURI is just the uid+_avatar.jpg avatarLink is the full AWS Link
Future<Widget> getProfileImage(String avatarURI, String avatarLink, bool isFading) async {
  if (avatarLink == null || avatarLink == "") {
    return Image.asset("lib/assets/images/tempAvatar.png");
  } else if (await doesObjectExistInS3(avatarURI, "klip-user-avatars") == "ObjectFound") {
    //doing this may cause issues if the profile image gets changed needs further testing
    print("Sending request to: " + avatarLink);
    if (isFading) {
      return new FadeInImage.memoryNetwork(
        image: avatarLink,
        placeholder: (await rootBundle.load("lib/assets/images/tempAvatar.png")).buffer.asUint8List(),
        imageErrorBuilder: (ctx, o, s) {
          return Image.asset("lib/assets/images/tempAvatar.png");
        },
      );
    } else {
      return Image.network(
        avatarLink,
        errorBuilder: (ctx, o, s) {
          return Image.asset("lib/assets/images/tempAvatar.png");
        },
      );
    }
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
  prefs.setString("xTag", xTag);
  prefs.setString("bio", bio);
  prefs.setString("avatarLink", avatarLink);
  prefs.setString("themePreference", themePreference);
  print("TP: $themePreference");
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
    return "SetSuccessful";
  } else if (value is String) {
    prefs.setString(key, value);
    return "SetSuccessful";
  } else if (value is List) {
    prefs.setStringList(key, value.cast<String>());
    return "SetSuccessful";
  } else {
    return "InvalidValueType";
  }
}

Future<void> pullUserFromSharedPreferences() async {
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
  xTag = await pullFieldFromSharedPreferences("xTag", prefs);
  bio = await pullFieldFromSharedPreferences("bio", prefs);
  bioLink = await pullFieldFromSharedPreferences("bioLink", prefs);
  avatarLink = await pullFieldFromSharedPreferences("avatarLink", prefs);
  themePreference = await pullFieldFromSharedPreferences("themePreference", prefs);
  try {
    dynamic temp;
    temp = (await pullFieldFromSharedPreferences("currentUserFollowing", prefs));
    currentUserFollowing = temp.runtimeType == String ? [] : temp.toList();
    temp = (await pullFieldFromSharedPreferences("currentUserFollowers", prefs));
    currentUserFollowers = temp.runtimeType == String ? [] : temp.toList();
    temp = (await pullFieldFromSharedPreferences("currentUserSubscribing", prefs));
    currentUserSubscribing = temp.runtimeType == String ? [] : temp.toList();
    temp = (await pullFieldFromSharedPreferences("currentUserSubscribers", prefs));
    currentUserSubscribers = temp.runtimeType == String ? [] : temp.toList();
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

Map<String, dynamic> getCurrentUser() {
  Map<String, dynamic> ret = {
    "uid": uid,
    "uName": uName,
    "fName": fName,
    "lName": lName,
    "email": email,
    "numViews": numViews,
    "numKredits": numKredits,
    "xTag": xTag,
    "bio": bio,
    "bioLink": bioLink,
    "themePreference": themePreference,
    "avatarLink": avatarLink,
    "userProfileImg": uid + "_avatar.jpg",
    "currentUserFollowing": currentUserFollowing,
    "currentUserFollowers": currentUserFollowers,
    "currentUserSubscribing": currentUserSubscribing,
    "currentUserSubscribers": currentUserSubscribers,
  };
  return ret;
}

Future<void> saveOnePreferenceToMongo(String param, String paramVal) async {
  Map<String, dynamic> newPreferences = {"uid": uid, param: paramVal};
  await savePreferences(uid, newPreferences);
}
