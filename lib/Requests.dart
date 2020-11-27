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
      if (response.body is String) return "Hello";
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
      if (response.body is String) return "Hello";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
    return "";
  }
}

Future<String> uploadImage(String filePath) async {
  if (filePath != "") {
    print("FILEPATH: " + filePath);
    String fileName = currentUser.uid +
        "_" +
        ((DateTime.now().millisecondsSinceEpoch / 1000).round()).toString();
    FormData formData = new FormData.fromMap({
      'name': fileName,
      'path': '/uploads',
      'uuid': currentUser.uid,
      "file": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        //TODO figure out the actual type of the files
        contentType: MediaType('image', 'jpg'),
      ),
      'record': null
    });
    print("Sending post request to: " + Constants.nodeURL + "upload");
    response = await dio.post(Constants.nodeURL + "upload", data: formData);
    print(response);
    return "";
  }
}

Future<String> getImageFromGallery() async {
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
}
