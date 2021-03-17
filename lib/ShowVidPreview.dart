import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'Constants.dart' as Constants;
import 'package:klip/widgets.dart';

import 'Requests.dart';

class ShowVidPreview extends StatefulWidget {
  @override
  _ShowVidPreviewState createState() => _ShowVidPreviewState();
}

class _ShowVidPreviewState extends State<ShowVidPreview> {
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> loadXboxClips(String gamertag) async {
    String getVids = await getXboxClips(gamertag);
    if (getVids == null) {}
    var xboxData = jsonDecode(getVids);
    //print(servRet);
    for (var clip in xboxData) {
      print(clip["thumbnails"]);
      print(clip["gameClipUris"]);
    }
    return xboxData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Klip"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check),
            color: Constants.purpleColor,
          ),
        ],
        centerTitle: true,
        brightness: Brightness.dark,
        //shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
