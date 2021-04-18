import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:flutter/services.dart';
import 'dart:convert';

Response response;
Dio dio = new Dio();

Future<String> updateOne(String uid, String param, String paramVal) async {
  Response response;
  print("Updating " + param + " to " + paramVal + " in mongo");
  try {
    Map<String, String> params = {
      "uid": uid,
      "param": param,
      "paramVal": paramVal,
    };

    String reqString = Constants.nodeURL + "updateOne";
    print("Sending Request To: " + reqString);
    response = await dio.post(reqString, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! UpdateOne => " + err.toString());
  }
  return "";
}

Future<String> addComment(String pid, String uid, String uname, String avatarLink, String comm, String time) async {
  Response response;
  try {
    Map<String, String> params = {
      "pid": pid,
      "uid": uid,
      "uname": uname,
      "avatarLink": avatarLink,
      "comm": comm,
      "time": time,
    };

    String reqString = Constants.nodeURL + "addComment";
    print("Sending Request To: " + reqString);
    response = await dio.post(reqString, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! addComment => " + err.toString());
  }
  return "";
}

Future<String> reportBug(String uid, String bug) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid": uid,
      "bug": bug,
    };

    String reqString = Constants.nodeURL + "reportBug";
    print("Sending Request To: " + reqString);
    response = await dio.post(reqString, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      return "BugReportedSucessfully";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "BugReportedUnsucessfully";
    }
  } catch (err) {
    print("Ran Into Error! reportBug => " + err.toString());
  }
  return "BugReportedUnsucessfully";
}

// ignore: missing_return
Future<String> testConnection() async {
  Response response;
  try {
    String reqString = Constants.nodeURL;
    print("Sending Request To: " + reqString);
    response = await dio.get(reqString);

    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! TestConnection => " + err.toString());
    return "";
  }
}

// ignore: missing_return
Future<String> uploadImage(String filePath, String uid, String title) async {
  try {
    if (filePath != "") {
      print("FILEPATH: " + filePath);
      String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();
      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'uid': uid,
        "avatar": currentUser.avatarLink,
        "uname": currentUser.uName,
        "title": title,
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          //TODO figure out the actual type of the files
          contentType: MediaType('image', 'jpg'),
        ),
        'record': null
      });

      String uri = Constants.nodeURL + "uploadContent";
      print("Sending post request to: " + uri);
      response = await dio.post(uri, data: formData);

      print(response);
      return "";
    }
  } catch (err) {
    print("Ran Into Error! uploadImage => " + err.toString());
  }
}

// ignore: missing_return
Future<String> uploadKlip(String filePath, String uid, String title) async {
  try {
    if (filePath != "") {
      print("FILEPATH: " + filePath);
      String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();
      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'uid': uid,
        "title": title,
        "avatar": currentUser.avatarLink,
        "uname": currentUser.uName,
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          //TODO figure out the actual type of the files
          contentType: MediaType('video', 'mp4'),
        ),
        'record': null
      });

      String uri = Constants.nodeURL + "uploadKlip";
      print("Sending post request to: " + uri);
      response = await dio.post(uri, data: formData);

      print(response);
      return "";
    }
  } catch (err) {
    print("Ran Into Error! UpdateOne => " + err.toString());
  }
}

// ignore: missing_return
Future<String> updateAvatar(String filePath, String uid) async {
  try {
    if (filePath != "") {
      print("FILEPATH: " + filePath);
      String fileName = uid + "_avatar";

      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'uid': uid,
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          //TODO figure out the actual type of the files
          contentType: MediaType('image', 'jpg'),
        ),
        'record': null
      });

      String uri = Constants.nodeURL + "uploadAvatar";
      print("Sending post request to: " + uri);
      response = await dio.post(uri, data: formData);

      print(response);
      return "";
    }
  } catch (err) {
    print("Ran Into Error! updateAvatar => " + err.toString());
  }
}

// ignore: missing_return
Future<String> getImageFromGallery() async {
  try {
    File contentImage;
    ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (pickedFile != null) {
      contentImage = File(pickedFile.path);
      print("FILE SIZE: " + (await contentImage.length()).toString());
      return pickedFile.path;
      //final bytes = await pickedFile.readAsBytes();
      //TODO look into bytes instead of paths
    } else {
      print('No image selected.');
    }
    return "";
  } catch (err) {
    print("Ran Into Error! getImageFromGallery => " + err.toString());
  }
}

// ignore: missing_return
Future<List<dynamic>> listContentMongo() async {
  Response response;
  try {
    String uri = Constants.nodeURL + "listContentMongo";
    print("Sending Request To: " + uri);
    response = await dio.get(uri);
    if (response.statusCode == 200) {
      print("Returned 200");
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return null;
    }
  } catch (err) {
    print("Ran Into Error! listContentMongo => " + err.toString());
    return null;
  }
}

Future<String> addTextContent(String uid, String title, String body) async {
  Response response;

  String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();

  try {
    Map<String, String> params = {
      "pid": fileName,
      "uid": uid,
      "avatar": currentUser.avatarLink,
      "uname": currentUser.uName,
      "title": title,
      "body": body,
    };
    String uri = Constants.nodeURL + "addTextContent";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! getListOfContent => " + err.toString());
  }
  return "";
}

Future<String> doesObjectExistInS3(String objectName, String bucketName) async {
  Response response;
  try {
    Map<String, String> params = {
      "objectName": objectName,
      "bucketName": bucketName,
    };

    String uri = Constants.nodeURL + "doesObjectExistInS3";
    print("Sending Request To: " + uri);
    response = await dio.get(uri, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);
      if (response.data["status"] == "ObjectFound") return "ObjectFound";
      if (response.data["status"] == "ObjectNotFound") return "ObjectNotFound";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "ERROR";
    }
  } catch (err) {
    print("Ran Into Error! doesObjectExistInS3 => " + err.toString());
    return "ERROR";
  }
  return "ERROR";
}

Future<String> getXboxClips(String gamertag) async {
  Response response;
  try {
    Map<String, String> params = {
      "gamertag": gamertag,
    };
    String uri = Constants.nodeURL + "getXboxClips";
    print("Sending Request To: " + uri);
    response = await dio.get(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! getXboxClips => " + err.toString());
  }
  return "";
}

Future<String> userFollowsUser(String uid1, String uid2) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid1": uid1,
      "uid2": uid2,
    };
    String uri = Constants.nodeURL + "userFollowsUser";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "FollowSucessful")
        return "FollowSucessful";
      else if ((response.data["status"] == "FollowUnsucessful")) return "FollowUnsucessful";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! userFollowsUser => " + err.toString());
  }
  return "";
}

Future<String> userUnfollowsUser(String uid1, String uid2) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid1": uid1,
      "uid2": uid2,
    };

    String uri = Constants.nodeURL + "userUnfollowsUser";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "UnfollowSucessful")
        return "UnfollowSucessful";
      else if ((response.data["status"] == "UnfollowUnsucessful")) return "UnfollowUnsucessful";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! userUnfollowsUser => " + err.toString());
  }
  return "";
}
