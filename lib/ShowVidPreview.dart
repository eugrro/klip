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
  ChewieController chewieController;
  File currVidFile;
  dynamic currVid;
  bool isVideoPlaying = true;

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

  Future<void> downloadXboxAsFile(String url) async {
    print("GETTING DIO DATA");

    try {
      await dio.get(url);
    } catch (e) {
      print("RAN INTO DIO ERROR");
      print(e);
    }
  }

  Future<Uint8List> getThumbImage(AssetEntity temp) async {
    return await temp.thumbDataWithSize(
      300,
      300,
      quality: 70,
    );
  }

  Future<void> initializeVideoPlayer() async {
    if (vid.length != 1) {
      print("INCORRECT INPUT TO SHOW VID PREVIEW PAGE");
      print("List length: " + vid.length.toString());
    } else {
      setState(() {
        currVid = vid[0];
      });
      if (currVid is String) {
        downloadXboxAsFile(currVid);
        videoPlayerController = VideoPlayerController.network(currVid);
        await videoPlayerController.initialize();
        chewieController = klipChewieController(videoPlayerController);
      } else if (currVid is AssetEntity) {
        currVidFile = await currVid.file;

        //Navigator.push(context, MaterialPageRoute(builder: (context) => VideoEditor(input: currVid)));
        videoPlayerController = VideoPlayerController.file(currVidFile);
        await videoPlayerController.initialize();
        chewieController = klipChewieController(videoPlayerController);
      } else {
        print("Invalid parameter video");
        print("Video is: " + currVid.runtimeType.toString());
      }
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.position == videoPlayerController.value.duration) {
          setState(() {
            isVideoPlaying = false;
          });
        }
      });
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
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => VideoEditor(currVid)));
              showError(context, "Video editor needs to be fixed");
            },
            icon: Icon(Icons.edit_outlined),
            color: Constants.purpleColor,
          ),
          IconButton(
            onPressed: () async {
              if (currVidFile is File) {
                print("UPLOADING KLIP");
                uploadKlip(currVidFile.path, currentUser.uid, "").then((pid) async {
                  if (pid == "" || pid == null) {
                    showError(context, "Could not upload klip");
                  } else {
                    await uploadThumbnail(await getThumbImage(currVid), pid);
                    while (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
                  }
                });
              } else {
                print(currVid.runtimeType);
                showError(context, "Uploading Xbox Klips not yet supported\nneed to be downloaded first");
              }
            },
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
        children: [
          Container(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              if (chewieController.videoPlayerController.value.position != chewieController.videoPlayerController.value.duration) {
                print("VIDEO NOT ENDED PAUSING");
                if (chewieController.isPlaying) {
                  print("PAUSING");
                  chewieController.pause();
                  setState(() {
                    isVideoPlaying = false;
                  });
                } else {
                  print("PLAYING");
                  print("PAUSING");
                  chewieController.play();
                  setState(() {
                    isVideoPlaying = true;
                  });
                }
              } else {
                print("VIDEO HAS ENDED RESTARTING");

                chewieController.seekTo(Duration(seconds: 0));
                chewieController.play();
                Future.delayed(Duration(milliseconds: 100), () {
                  setState(() {
                    isVideoPlaying = true;
                  });
                });
              }
            },
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: chewieController != null
                      ? Chewie(
                          controller: chewieController,
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
                AnimatedOpacity(
                  opacity: isVideoPlaying ? 0 : 1,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Constants.backgroundWhite.withOpacity(.6),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Constants.purpleColor,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
