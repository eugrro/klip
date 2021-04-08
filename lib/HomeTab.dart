import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:klip/Requests.dart';
import 'package:klip/commentsPage.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/widgets.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert' as convert;
import './Constants.dart' as Constants;
import 'package:async/async.dart';
import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:vibration/vibration.dart';

//import 'Vid.dart';

class HomeTab extends StatefulWidget {
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final AsyncMemoizer memoizer = AsyncMemoizer();

  bool showComments = false;
  BetterPlayerController _betterPlayerController;
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //chewieController.dispose();
    //videoPlayerController.dispose();
    //_betterPlayerController.dispose();
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
                return SizedBox.shrink(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget imgWidget(String link) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.network(link),
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
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Chewie(
        controller: chewieController,
      ),
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
              
              if (obj[position]["type"] == "txt") {
                return buildHomeWidget(obj, position, txtWidget(obj[position]["title"], obj[position]["body"]));
              } else if (obj[position]["type"] == "img") {
                return buildHomeWidget(obj, position, imgWidget(obj[position]["link"]));
              } else if (obj[position]["type"] == "vid") {
                return FutureBuilder(
                  future: setUpVideoController(obj[position]["link"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: buildHomeWidget(obj, position, obj[position]["type"]),
                      );
                    } else {
                      return SizedBox.shrink(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return Container(
                  child: Text(
                    "ERROR",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
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

  Widget buildHomeWidget(dynamic obj, int position, Widget content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(obj[position]["avatar"]),
                  ),
                ),
                Text(
                  obj[position]["uname"],
                  style: TextStyle(
                    color: Constants.backgroundWhite.withOpacity(.7),
                    fontSize: 12 + Constants.textChange,
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
                Text(
                  "Follow",
                  style: TextStyle(
                    color: Constants.purpleColor,
                  ),
                )
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
        Container(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              obj[position]["title"],
              style: TextStyle(
                color: Constants.backgroundWhite,
                fontSize: 16 + Constants.textChange,
              ),
            ),
          ),
        ),
        content,
        Container(
          height: 10,
        ),
        Container(
          height: .8,
          width: MediaQuery.of(context).size.width * .90,
          color: Constants.purpleColor.withOpacity(.4),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 13,
            bottom: 13,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "lib/assets/iconsUI/+1Icon.svg",
                    semanticsLabel: '+1 Icon',
                    width: 20,
                    height: 20,
                  ),
                  Container(
                    width: 5,
                  ),
                  Text(
                    "1, 345",
                    style: TextStyle(
                      color: Constants.backgroundWhite,
                      fontSize: 14 + Constants.textChange,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, SlideInRoute(page: CommentsPage(obj[position]["pid"], obj[position]["comm"]), direction: 2)).then((value) {
                    print("RETURNED TO USER PAGE");
                    setState(() {});
                  });
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "lib/assets/iconsUI/commentIcon.svg",
                      semanticsLabel: 'commentIcon',
                      width: 20,
                      height: 20,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      "2",
                      style: TextStyle(
                        color: Constants.backgroundWhite,
                        fontSize: 14 + Constants.textChange,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "lib/assets/iconsUI/kreditIcon.svg",
                    semanticsLabel: '+1 Icon',
                    width: 20,
                    height: 20,
                  ),
                  Container(
                    width: 5,
                  ),
                  Text(
                    "120",
                    style: TextStyle(
                      color: Constants.backgroundWhite,
                      fontSize: 14 + Constants.textChange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: .8,
          width: MediaQuery.of(context).size.width * .90,
          color: Constants.purpleColor.withOpacity(.4),
        ),
        Container(
          height: 5,
        ),
        showComments ? commentsWidget() : Container(),
      ],
    );
  }

  // ignore: missing_return
  Future<String> setUpVideoController(String vUrl) async {
    videoPlayerController = VideoPlayerController.network(vUrl);
    print("Video URL: " + vUrl);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    if (videoPlayerController.value.initialized) {
      return "DONE";
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
}
