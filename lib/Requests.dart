import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

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

    String reqString = Constants.nodeURL + "user/updateOne";
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

Future<String> addComment(String pid, String comm, String time) async {
  Response response;
  try {
    Map<String, String> params = {
      "pid": pid,
      "uid": currentUser.uid,
      "uName": currentUser.uName,
      "avatarLink": currentUser.avatarLink,
      "comm": comm,
      "time": time,
    };

    String reqString = Constants.nodeURL + "content/addComment";
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

    String reqString = Constants.nodeURL + "misc/reportBug";
    print("Sending Request To: " + reqString);
    response = await dio.post(reqString, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      return "BugReportedSuccessfully";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "BugReportedUnsuccessfully";
    }
  } catch (err) {
    print("Ran Into Error! reportBug => " + err.toString());
  }
  return "BugReportedUnsuccessfully";
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
Future<String> uploadImage(String filePath, String uid, dynamic tags, String title) async {
  try {
    if (filePath != "") {
      print("FILEPATH: " + filePath);
      String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();
      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'uid': uid,
        'pid': fileName,
        "avatar": currentUser.avatarLink,
        "uName": currentUser.uName,
        "title": title,
        "tags": tags,
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          //TODO figure out the actual type of the files
          contentType: MediaType('image', 'jpg'),
        ),
        'record': null
      });

      String uri = Constants.nodeURL + "content/uploadImage";
      print("Sending post request to: " + uri);
      response = await dio.post(uri, data: formData);

      return fileName;
    }
  } catch (err) {
    print("Ran Into Error! uploadImage => " + err.toString());
    return "";
  }
}

// ignore: missing_return
Future<String> uploadThumbnail(Uint8List thumbnailData, String pid) async {
  try {
    if (thumbnailData != null) {
      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'pid': pid,
        "file": MultipartFile.fromBytes(
          thumbnailData,
          filename: pid,
          //TODO figure out the actual type of the files
          contentType: MediaType('image', 'jpg'),
        ),
        'record': null
      });

      String uri = Constants.nodeURL + "content/uploadThumbnail";
      print("Sending post request to: " + uri);
      response = await dio.post(uri, data: formData);

      print(response);
      return "";
    }
  } catch (err) {
    print("Ran Into Error! uploadThumbnail => " + err.toString());
  }
}

// ignore: missing_return
Future<String> uploadKlip(String filePath, String uid, String title, dynamic tags, Uint8List thumbnailData) async {
  try {
    if (filePath != "") {
      if (filePath.substring(0, 8) == "file:///") filePath = filePath.substring(7);
      print("FILEPATH: " + filePath);
      String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();
      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'uid': uid,
        'pid': fileName,
        "title": title,
        "avatar": currentUser.avatarLink,
        "uName": currentUser.uName,
        "tags": tags,
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          //TODO figure out the actual type of the files
          contentType: MediaType('video', 'mp4'),
        ),
        'record': null
      });

      String uri = Constants.nodeURL + "content/uploadKlip";
      print("Sending post request to: " + uri);
      response = await dio.post(uri, data: formData);

      await uploadThumbnail(thumbnailData, fileName);
      return fileName;
    }
  } catch (err) {
    print("Ran Into Error! uploadKlip => " + err.toString());
    return "";
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

      String uri = Constants.nodeURL + "user/uploadAvatar";
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
    String uri = Constants.nodeURL + "content/listContentMongo";
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
    if (response != null) {
      print(response.data);
    }
    return null;
  }
}

// ignore: missing_return
Future<dynamic> search(String uid, String val) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid": uid,
      "val": val,
    };

    String uri = Constants.nodeURL + "misc/search";
    print("Sending Request To: " + uri);
    response = await dio.get(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return null;
    }
  } catch (err) {
    print("Ran Into Error! search => " + err.toString());
    if (response != null) {
      print(response.data);
    }
    return null;
  }
}

Future<dynamic> addTextContent(String uid, String title, String body) async {
  Response response;

  String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();

  try {
    Map<String, String> params = {
      "pid": fileName,
      "uid": uid,
      "avatar": currentUser.avatarLink,
      "uName": currentUser.uName,
      "title": title,
      "body": body,
    };
    String uri = Constants.nodeURL + "content/addTextContent";
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
    print("Ran Into Error! addTextContent => " + err.toString());
  }
  return "";
}

Future<dynamic> addPollContent(String uid, String title, List<dynamic> options) async {
  Response response;

  String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();

  try {
    Map<String, dynamic> params = {
      "pid": fileName,
      "uid": uid,
      "avatar": currentUser.avatarLink,
      "uName": currentUser.uName,
      "title": title,
      "options": options,
    };
    String uri = Constants.nodeURL + "content/addPollContent";
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
    print("Ran Into Error! addTextContent => " + err.toString());
  }
  return "";
}

Future<dynamic> voteOnPoll(String uid, String pid, int valVoted) async {
  Response response;
  //add confirmation that vote did not go through multiple times
  try {
    Map<String, dynamic> params = {
      "pid": pid,
      "uid": uid,
      "valVoted": valVoted,
    };
    String uri = Constants.nodeURL + "content/voteOnPoll";
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
    print("Ran Into Error! voteOnPoll => " + err.toString());
  }
  return "";
}

Future<dynamic> getNotifications(String uid) async {
  Response response;
  try {
    Map<String, dynamic> params = {"uid": uid};
    String uri = Constants.nodeURL + "notif/getNotifications";
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
    print("Ran Into Error! getNotifications => " + err.toString());
  }
  return "";
}

Future<dynamic> addNotification(String uid, String newText, bool sentVal) async {
  Response response;
  try {
    Map<String, dynamic> params = {"uid": uid, "newText": newText, "sentVal": sentVal};
    String uri = Constants.nodeURL + "notif/addNotification";
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
    print("Ran Into Error! getNotifications => " + err.toString());
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

Future<List<dynamic>> getXboxClips(String gamertag) async {
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
      if (response.data.runtimeType.toString() == "List<dynamic>") return response.data;
      if (response.data.runtimeType == String && response.data.length > 10) return jsonDecode(response.data);
      print("Returned unknown value: " + response.data.toString());
      print("\n" + response.data.runtimeType.toString());
    } else {
      print("Returned error " + response.statusCode.toString());
      return [];
    }
  } catch (err) {
    print("Ran Into Error! getXboxClips => " + err.toString());
  }
  return [];
}

Future<String> userFollowsUser(String uid1, String uid2) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid1": uid1,
      "uid2": uid2,
    };
    String uri = Constants.nodeURL + "user/userFollowsUser";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "FollowSuccessful")
        return "FollowSuccessful";
      else if ((response.data["status"] == "FollowUnsuccessful")) return "FollowUnsuccessful";
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

    String uri = Constants.nodeURL + "user/userUnfollowsUser";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "UnfollowSuccessful")
        return "UnfollowSuccessful";
      else if ((response.data["status"] == "UnfollowUnsuccessful")) return "UnfollowUnsuccessful";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! userUnfollowsUser => " + err.toString());
  }
  return "";
}

Future<String> likeContent(String pid, String uid) async {
  Response response;
  try {
    Map<String, String> params = {
      "pid": pid,
      "uid": uid,
    };
    String uri = Constants.nodeURL + "content/likeContent";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "LikeSuccessful")
        return "LikeSuccessful";
      else if (response.data["status"] == "LikeUnsuccessful") return "LikeUnsuccessful";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! likeContent => " + err.toString());
  }
  return "";
}

Future<String> unlikeContent(String pid, String uid) async {
  Response response;
  try {
    Map<String, String> params = {
      "pid": pid,
      "uid": uid,
    };
    String uri = Constants.nodeURL + "content/unlikeContent";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "UnlikeSuccessful")
        return "UnlikeSuccessful";
      else if (response.data["status"] == "UnlikeUnsuccessful") return "UnlikeUnsuccessful";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! unlikeContent => " + err.toString());
  }
  return "";
}

Future<String> postViewed(String pid) async {
  Response response;
  try {
    Map<String, String> params = {
      "pid": pid,
    };
    String uri = Constants.nodeURL + "content/postViewed";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "ViewAdded")
        return "ViewAdded";
      else if (response.data["status"] == "ViewNotAdded") return "ViewNotAdded";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! unlikeContent => " + err.toString());
  }
  return "";
}

Future<dynamic> getUserContent(String uid) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid": uid,
    };

    String uri = Constants.nodeURL + "content/getUserContent";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data == null) return "";
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! getUserContent => " + err.toString());
  }
  return "";
}

Future<dynamic> deleteContent(String pid, String thumb) async {
  Response response;
  try {
    Map<String, String> params = {
      "pid": pid,
      "thumb": thumb,
      //thumb value is not important
      //must be not null or empty string and it will attempt to delete the thumbnail
    };

    String uri = Constants.nodeURL + "content/deleteContent";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.data["status"] == "DeleteSuccessful")
        return "DeleteSuccessful";
      else if (response.data["status"] == "DeleteUnsuccessful") return "DeleteUnsuccessful";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! deleteContent => " + err.toString());
  }
  return "";
}
