import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:chewie/chewie.dart';

class ShowVidPreview extends StatefulWidget {
  List<dynamic> vid;
  ShowVidPreview(this.vid);
  @override
  _ShowVidPreviewState createState() => _ShowVidPreviewState(vid);
}

class _ShowVidPreviewState extends State<ShowVidPreview> {
  List<dynamic> vid;
  _ShowVidPreviewState(this.vid);

  var videoPlayerController;
  var chewieController;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  Future<void> initializeVideoPlayer() async {
    if (vid.length != 1) {
      print("INCORRECT INPUT TO SHOW VID PREVIEW PAGE");
      print("List length: " + vid.length.toString());
    } else {
      var currVid = vid[0];
      if (currVid is String) {
        videoPlayerController = VideoPlayerController.network(currVid);
        await videoPlayerController.initialize();
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: false,
          looping: false,
        );
      } else if (currVid is AssetEntity) {
        currVid = await currVid.file;
        videoPlayerController = VideoPlayerController.file(currVid);
        await videoPlayerController.initialize();
        chewieController = klipChewieController(videoPlayerController);
      } else {
        print("Invalid parameter video");
        print("Video is: " + currVid.runtimeType.toString());
      }
      setState(() {});
    }
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
      body: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: chewieController != null
            ? Chewie(
                controller: chewieController,
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
