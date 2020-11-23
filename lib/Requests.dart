import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

Future<String> updateOne(String uid, String param, String paramVal) async {
  var response;
  try {
    Map<String, String> params = {
      "uid": uid,
      param: paramVal,
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
