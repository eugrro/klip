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
        RaisedButton(
          onPressed: () {
            print("TRYING TO UPDATE VALUE");
            updateOne(currentUser.uid, "age", "99");
          },
          child: Text("Update Val"),
        ),
      ],
    );
  }
}
