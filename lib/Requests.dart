import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

Response response;
Dio dio = new Dio();

Future<String> updateOne(String uid, String param, String paramVal) async {
  var response;
  try {
    Map<String, String> params = {
      "uid": uid,
      "param": param,
      "paramVal": paramVal,
    };
    String reqString = Constants.nodeURL + "updateOne";
    print("Sending Request To: " + reqString);

    response = await http.post(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);
      if (response.body is String) return response.body;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
  }
  return "";
}

Future<String> addComment(String pid, String uid, String uname, String avatarLink, String comm, String time) async {
  var response;
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

    response = await http.post(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);
      if (response.body is String) return response.body;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
  }
  return "";
}

// ignore: missing_return
Future<String> testConnection() async {
  var response;
  try {
    String reqString = Constants.nodeURL;
    print("Sending Request To: " + reqString);

    response = await http.get(reqString);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);
      if (response.body is String) return response.body;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
    return "";
  }
}

// ignore: missing_return
Future<String> uploadImage(String filePath, String uid) async {
  try {
    if (filePath != "") {
      print("FILEPATH: " + filePath);
      String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();
      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'uid': uid,
        "avatar": currentUser.avatarLink,
        "uname": currentUser.uName,
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
  } catch (e) {
    print("ERROR on Uploading Image: " + e.toString());
  }
}

// ignore: missing_return
Future<String> uploadKlip(String filePath, String uid) async {
  try {
    if (filePath != "") {
      print("FILEPATH: " + filePath);
      String fileName = uid + "_" + ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();
      FormData formData = new FormData.fromMap({
        'path': '/uploads',
        'uid': uid,
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
  } catch (e) {
    print("ERROR on Uploading Image: " + e.toString());
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
  } catch (e) {
    print("ERROR on Uploading Image: " + e.toString());
  }
}

// ignore: missing_return
Future<String> getImageFromGallery() async {
  try {
    File contentImage;
    ImagePicker ip = ImagePicker();
    final pickedFile = await ip.getImage(
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
  } catch (e) {
    print("ERROR on Uploading Image: " + e.toString());
  }
}

// ignore: missing_return
Future<String> getListOfContent() async {
  var response;
  try {
    String reqString = Constants.nodeURL + "listContentMongo";
    print("Sending Request To: " + reqString);

    response = await http.get(reqString);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);
      if (response.body is String) return response.body;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
    return "";
  }
}

Future<String> addTextContent(String uid, String title, String body) async {
  var response;

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
    String reqString = Constants.nodeURL + "addTextContent";
    print("Sending Request To: " + reqString);

    response = await http.post(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);
      if (response.body is String) return response.body;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
  }
  return "";
}

Future<String> doesObjectExistInS3(String objectName, String bucketName) async {
  var response;
  try {
    Map<String, String> params = {
      "objectName": objectName,
      "bucketName": bucketName,
    };
    String reqString = Constants.nodeURL + "doesObjectExistInS3";
    print("Sending Request To: " + reqString);

    response = await http.get(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);
      if (response.body == "ObjectFound") return "ObjectFound";
      if (response.body == "ObjectNotFound") return "ObjectNotFound";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "ERROR";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
  }
  return "ERROR";
}

Future<String> getXboxClips(String gamertag) async {
  var response;
  try {
    Map<String, String> params = {
      "gamertag": gamertag,
    };
    String reqString = Constants.nodeURL + "getXboxClips";
    print("Sending Request To: " + reqString);

    response = await http.get(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      if (response.body is String) return response.body;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
  }
  return "";
}
