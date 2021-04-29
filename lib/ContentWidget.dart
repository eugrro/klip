import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:klip/Requests.dart';
import 'package:klip/currentUser.dart';
import 'Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class ContentWidget extends StatefulWidget {
  dynamic obj;
  Function(int) callback;
  ContentWidget(this.obj, this.callback);

  @override
  _ContentWidgetState createState() => _ContentWidgetState(obj, callback);
}

class _ContentWidgetState extends State<ContentWidget> {
  Map<String, dynamic> obj;
  Function(int) callback;
  _ContentWidgetState(this.obj, this.callback);

  String type;
  bool showComments = false;
  var isVideoPlaying = ValueNotifier<bool>(true);
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;
  Widget content;
  double spaceBetweenBottomContent = 3;
  bool likedPost = false;

  @override
  void initState() {
    super.initState();
    type = obj["type"];
    setUpContent(obj);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: missing_return
  Future<Widget> setUpVideoController(dynamic obj) async {
    videoPlayerController = VideoPlayerController.network(obj["link"]);
    print("Video URL: " + obj["link"]);
    await videoPlayerController.initialize();
    chewieController = klipChewieController(videoPlayerController);
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.position == videoPlayerController.value.duration) {
        print("Setting Value");
        isVideoPlaying.value = false;
      }
    });
  }

  void setUpContent(obj) async {
    if (type == "txt") {
      setState(() {
        content = txtWidget(obj["title"], obj["body"]);
      });
    } else if (type == "img") {
      setState(() {
        content = imgWidget(obj["link"]);
      });
    } else if (type == "vid") {
      setUpVideoController(obj).then((value) {
        setState(() {
          content = vidWidget();
        });
      });
    } else {
      print("ERROR Invalid content type");
      throw ErrorDescription("Invalid content type");
    }
  }

  Widget commentsWidget() {
    return Container(
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.1,
        maxChildSize: 0.8,
        builder: (BuildContext context, myscrollController) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.tealAccent[200],
            child: ListView.builder(
              controller: myscrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text(
                  'Dish $index',
                  style: TextStyle(color: Colors.black54),
                ));
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        obj["title"] != null
            ? Text(
                obj["title"] ?? "",
                style: TextStyle(
                  color: Constants.backgroundWhite,
                  fontSize: 17 + Constants.textChange,
                ),
              )
            : Container(),
        Container(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: ClipOval(
                    child: FutureBuilder<Widget>(
                      future: getProfileImage(obj["uid"] + "_avatar.jpg", getAWSLink(obj["uid"])),
                      // a previously-obtained Future<String> or null
                      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                        double sizeofImage = 25;
                        if (snapshot.hasData) {
                          return Container(
                            height: sizeofImage,
                            width: sizeofImage,
                            child: snapshot.data,
                          );
                        } else {
                          return Container(
                            height: sizeofImage,
                            width: sizeofImage,
                            child: Constants.tempAvatar,
                          );
                        }
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    callback(2);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(obj["uid"])));
                  },
                  child: Text(
                    obj["uName"] ?? "usernameError",
                    style: TextStyle(
                      color: Constants.backgroundWhite.withOpacity(.7),
                      fontSize: 14 + Constants.textChange,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 6,
                    right: 6,
                    top: 2,
                  ),
                  child: Icon(
                    Icons.circle,
                    color: Constants.backgroundWhite,
                    size: 5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.more_vert,
                color: Constants.backgroundWhite,
                size: 25,
              ),
            ),
          ],
        ),

        //===============================================================
        content ?? Container(),
        //===============================================================

        Padding(
          padding: EdgeInsets.only(
            top: 5,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (likedPost) {
                    unlikeContent(
                      obj["pid"],
                      currentUser.uid,
                    );
                    obj["numLikes"] -= 1;
                  } else {
                    likeContent(
                      obj["pid"],
                      currentUser.uid,
                    );
                    obj["numLikes"] += 1;
                  }
                  setState(() {
                    likedPost = !likedPost;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      color: likedPost ? Constants.purpleColor : Constants.hintColor,
                      size: 24,
                    ),
                    Container(
                      width: spaceBetweenBottomContent,
                    ),
                    Text(
                      obj["numLikes"].toString() ?? "error",
                      style: TextStyle(
                        color: likedPost ? Constants.purpleColor : Constants.hintColor,
                        fontSize: 14 + Constants.textChange,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  callback(0).then((value) {
                    print("RETURNED TO USER PAGE");
                    setState(() {});
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mode_comment_outlined,
                      color: Constants.hintColor,
                      size: 24,
                    ),
                    Container(
                      width: spaceBetweenBottomContent,
                    ),
                    Text(
                      obj["comm"].length.toString() ?? "error",
                      style: TextStyle(
                        color: Constants.hintColor,
                        fontSize: 14 + Constants.textChange,
                      ),
                    ),
                  ],
                ),
              ),
              VisibilityDetector(
                key: Key(obj['pid']),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  if (visiblePercentage == 100 && obj["uid"] != currentUser.uid) {
                    postViewed(obj['pid']);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: Constants.hintColor,
                      size: 24,
                    ),
                    Container(
                      width: spaceBetweenBottomContent,
                    ),
                    Text(
                      obj["numViews"].toString() ?? "error",
                      style: TextStyle(
                        color: Constants.hintColor,
                        fontSize: 14 + Constants.textChange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        /*Container(
          height: .8,
          width: MediaQuery.of(context).size.width * .90,
          color: Constants.purpleColor.withOpacity(.4),
        ),*/
        Container(
          height: 5,
        ),
        showComments ? commentsWidget() : Container(),
      ],
    );
  }

  Widget imgWidget(String link) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.network(
        link,
      ),
    );
  }

  Widget txtWidget(String title, String body) {
    return Row(
      children: [
        Container(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          child: Text(
            title,
            style: TextStyle(color: Constants.backgroundWhite, fontSize: 30 + Constants.textChange),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 40),
          child: Text(
            body,
            style: TextStyle(color: Constants.backgroundWhite, fontSize: 16 + Constants.textChange),
          ),
        ),
        Container(
          height: 10,
        ),
      ],
    );
  }

  Widget vidWidget() {
    return GestureDetector(
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
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: chewieController != null
                  ? Chewie(
                      controller: chewieController,
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
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
    );
  }
}
