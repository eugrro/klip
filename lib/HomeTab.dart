import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:klip/Requests.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'dart:convert' as convert;
import './Constants.dart' as Constants;

//import 'Vid.dart';

class HomeTab extends StatefulWidget {
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0, color: Constants.backgroundBlack),
              color: Constants.backgroundBlack,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: () {
                print("TRYING TO TEST NODE CONNECTION");
                testConnection();
              },
              child: Text("Test Connection"),
            ),
            RaisedButton(
              onPressed: () async {
                print("TRYING TO UPLOAD PHOTO");
                uploadImage(await getImageFromGallery());
              },
              child: Text("Upload Image"),
            ),
          ],
        ),
      ],
    );
  }
}
