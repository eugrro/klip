import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:klip/ContentWidget.dart';
import 'package:klip/Requests.dart';
import 'package:klip/UserPage.dart';
import 'package:klip/commentsPage.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/widgets.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert' as convert;
import './Constants.dart' as Constants;
import 'package:async/async.dart';
import 'package:chewie/chewie.dart';
import 'package:vibration/vibration.dart';

import 'currentUser.dart';

//import 'Vid.dart';

class HomeTab extends StatefulWidget {
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final AsyncMemoizer memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: memoizer.runOnce(() => getListOfContent()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Build the widget with data.
                print("Home Page Displayed");
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.bottomNavBarHeight,
                    ),
                    child: buildContent(snapshot.data),
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildContent(String jsonInput) {
    try {
      var obj = json.decode(jsonInput);
      print(obj);
      return Container(
        width: MediaQuery.of(context).size.width,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            if (position < obj.length) {
              return ContentWidget(obj[position]);
            } else {
              return Center(
                child: Text(
                  "No More Content",
                  style: TextStyle(
                    color: Constants.backgroundWhite,
                    fontSize: 20 + Constants.textChange,
                  ),
                ),
              );
            }
          },
        ),
      );
    } catch (e) {
      throw "Error on parsing content data: " + e.toString();
    }
  }
}
