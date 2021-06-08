import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:chewie/chewie.dart';

import 'Requests.dart';

//import 'CropVideo.dart';

// ignore: must_be_immutable
class ShowImgPreview extends StatefulWidget {
  List<dynamic> listParam;
  ShowImgPreview(this.listParam);
  @override
  _ShowImgPreviewState createState() => _ShowImgPreviewState(listParam);
}

class _ShowImgPreviewState extends State<ShowImgPreview> {
  List<dynamic> listParam;
  _ShowImgPreviewState(this.listParam);

  File currImgFile;

  @override
  void initState() {
    super.initState();
  }

  Future<File> setUpImg() async {
    currImgFile = await listParam[0].file;
    return currImgFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Image"),
        actions: [
          IconButton(
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => VideoEditor(currVid)));
              showError(context, "Video editor needs to be fixed");
            },
            icon: Icon(Icons.edit_outlined),
            color: Theme.of(context).textSelectionTheme.cursorColor,
          ),
          IconButton(
            onPressed: () async {
              uploadImage(currImgFile.path, currentUser.uid, "").then((pid) async {
                if (pid == "" || pid == null) {
                  showError(context, "Could not upload image");
                } else {
                  while (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
                }
              });
            },
            icon: Icon(Icons.check),
            color: Theme.of(context).textSelectionTheme.cursorColor,
          ),
        ],
        centerTitle: true,
        brightness: Brightness.dark,
        //shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: 10,
          ),
          FutureBuilder<File>(
            future: setUpImg(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: currImgFile == null ? Center(child: CircularProgressIndicator()) : Image.file(currImgFile),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
