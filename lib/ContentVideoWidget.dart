import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';
import './Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:klip/currentUser.dart' as currentUser;

import 'Requests.dart';

// ignore: must_be_immutable
class ContentVideoWidget extends StatefulWidget {
  dynamic obj;
  ContentVideoWidget(this.obj);
  @override
  _ContentVideoWidgetState createState() => _ContentVideoWidgetState(obj);
}

class _ContentVideoWidgetState extends State<ContentVideoWidget> {
  dynamic obj;
  _ContentVideoWidgetState(this.obj);
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;
  ValueNotifier<bool> isVideoPlaying = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    isVideoPlaying.value = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<ChewieController> setUpVideoController(dynamic obj) async {
    String uri = obj["link"];
    if (uri == "file") {
      ///This class can be used to display videos all over the app
      ///Here it checks if the video passed in is a file. If it is then it will play a local videp
      ///otherwise it will get the uri from the object(usually grabbed from mongoDB) and play from network
      videoPlayerController = VideoPlayerController.file(obj["file"]);
    } else {
      videoPlayerController = VideoPlayerController.network(uri);
    }
    print("Video URL: " + uri);
    await videoPlayerController.initialize();
    chewieController = klipChewieController(videoPlayerController);
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.position == videoPlayerController.value.duration) {
        isVideoPlaying.value = false;
      }
    });
    return chewieController;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(obj['pid']),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100 && obj["uid"] != currentUser.uid) {
          postViewed(obj['pid']);
        }
        if (visiblePercentage != 100 && chewieController != null) {
          isVideoPlaying.value = false;
          chewieController.pause();
        }
        if (visiblePercentage == 100 && chewieController != null) {
          isVideoPlaying.value = true;
          chewieController.play();
        }
      },
      child: GestureDetector(
        onTap: () {
          if (chewieController.videoPlayerController.value.position != chewieController.videoPlayerController.value.duration) {
            print("VIDEO NOT ENDED PAUSING");
            if (chewieController.isPlaying) {
              print("PAUSING");

              isVideoPlaying.value = false;

              chewieController.pause();
            } else {
              print("PLAYING");

              isVideoPlaying.value = true;

              chewieController.play();
            }
          } else {
            print("VIDEO HAS ENDED RESTARTING");

            chewieController.seekTo(Duration(seconds: 0)).then((value) {
              isVideoPlaying.value = true;
            });
            chewieController.play();
          }
        },
        child: Stack(
          children: [
            FutureBuilder<ChewieController>(
              future: setUpVideoController(obj),
              builder: (BuildContext context, AsyncSnapshot<ChewieController> snapshot) {
                if (snapshot.hasData) {
                  snapshot.data.pause();
                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: chewieController != null
                          ? Chewie(
                              controller: snapshot.data,
                            )
                          : Center(child: CircularProgressIndicator()),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            ValueListenableBuilder(
              valueListenable: isVideoPlaying,
              builder: (context, value, widget) {
                return AnimatedOpacity(
                  opacity: value == true ? 0 : 1,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
