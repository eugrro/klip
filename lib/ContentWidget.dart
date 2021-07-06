import 'package:flutter/material.dart';
import 'package:klip/InspectContent.dart';
import 'package:klip/Requests.dart';
import 'package:klip/currentUser.dart';
import 'package:klip/widgets.dart';
import 'Constants.dart' as Constants;
import 'ContentVideoWidget.dart';

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

  Widget content;
  double spaceBetweenBottomContent = 3;
  bool likedPost = false;

  int largestVote;

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
      setState(() {
        content = ContentVideoWidget(obj);
      });
    } else if (type == "poll") {
      setState(() {
        content = pollWidget(obj["options"], obj["optionsCount"], obj["pid"]);
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
        //===============================================================

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => InspectContent(content ?? Container())));
          },
          child: content ?? Container(),
        ),

        //===============================================================

        Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 8,
            left: 20,
            right: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  Container(
                    width: 20,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
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
                ],
              ),
              Row(
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
                  Container(
                    width: 20,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showContentOptions(context);
                    },
                    child: Text(
                      "!",
                      style: TextStyle(
                        color: Constants.hintColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            callback(2);
          },
          behavior: HitTestBehavior.translucent,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: ClipOval(
                  child: FutureBuilder<Widget>(
                    future: getProfileImage(obj["uid"] + "_avatar.jpg", getAWSLink(obj["uid"])),
                    // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      double sizeofImage = 40;
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    children: [
                      Text(
                        obj["uName"] ?? "usernameError",
                        style: TextStyle(
                          color: Constants.hintColor,
                          fontSize: 14 + Constants.textChange,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 2,
                        ),
                        child: Icon(
                          Icons.circle,
                          color: Constants.hintColor,
                          size: 5,
                        ),
                      ),
                      Text(
                        getTimeFromSeconds(obj["pid"].split("_")[1]),
                        style: TextStyle(
                          color: Constants.hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        Container(
          height: 5,
        ),
        showComments ? commentsWidget() : Container(),
      ],
    );
  }

  Widget imgWidget(String link) {
    return VisibilityDetector(
      key: Key(obj['pid']),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100 && obj["uid"] != currentUser.uid) {
          postViewed(obj['pid']);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Image.network(
          link,
          height: 400,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget txtWidget(String title, String body) {
    return VisibilityDetector(
      key: Key(obj['pid']),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100 && obj["uid"] != currentUser.uid) {
          postViewed(obj['pid']);
        }
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: 25,
            bottom: 25,
          ),
          child: Text(
            body,
            style: TextStyle(color: Constants.backgroundWhite, fontSize: 16 + Constants.textChange),
          ),
        ),
      ),
    );
  }

  ValueNotifier<int> pollValueSelected = ValueNotifier(-1);
  ValueNotifier<bool> isShowingResultForPoll = ValueNotifier(false);
  Widget pollWidget(dynamic options, dynamic optionsCount, String pid) {
    double heightOfPollItem = 50;
    return VisibilityDetector(
      key: Key(obj['pid']),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100 && obj["uid"] != currentUser.uid) {
          postViewed(obj['pid']);
        }
      },
      child: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20),
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ValueListenableBuilder(
                valueListenable: isShowingResultForPoll,
                builder: (BuildContext context, bool showResults, Widget child) {
                  if (!showResults) {
                    //USER IS STILL SELECTING A RESULT
                    return Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 16,
                        right: MediaQuery.of(context).size.width / 16,
                      ),
                      child: InkWell(
                        onTap: () {
                          pollValueSelected.value = index;
                        },
                        child: Container(
                          height: heightOfPollItem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: pollValueSelected,
                                  builder: (BuildContext context, int pollVal, Widget child) {
                                    return Icon(
                                      pollVal == index ? Icons.radio_button_on : Icons.radio_button_off,
                                      size: 15,
                                      color: Constants.purpleColor,
                                    );
                                  }),
                              Container(
                                width: 20,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  options[index],
                                  style: TextStyle(
                                    color: Constants.backgroundWhite,
                                    fontSize: 16 + Constants.textChange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    //SHOWING RESULTS
                    int currentVote = obj["optionsCount"][index];
                    double ratio = currentVote / largestVote;
                    return Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 16,
                        right: MediaQuery.of(context).size.width / 16,
                      ),
                      child: Container(
                        height: heightOfPollItem,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: heightOfPollItem,
                                width: MediaQuery.of(context).size.width / 8 * 7 * ratio + 30,
                                color: Colors.grey.withOpacity(.5),
                                //im not sure whether to go index/largest or index/total. I chose the former
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 15,
                                ),
                                child: Text(
                                  currentVote.toString(),
                                  style: TextStyle(
                                    color: Constants.backgroundWhite,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  options[index],
                                  style: TextStyle(
                                    color: Constants.backgroundWhite,
                                    fontSize: 16 + Constants.textChange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: isShowingResultForPoll,
            builder: (BuildContext context, bool showResults, Widget child) {
              if (!showResults) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (pollValueSelected.value != -1) {
                        voteOnPoll(currentUser.uid, pid, pollValueSelected.value);
                        obj["optionsCount"][pollValueSelected.value]++;
                        largestVote = getLargestVoteCount(obj["optionsCount"]);
                        isShowingResultForPoll.value = !isShowingResultForPoll.value;
                      }
                    },
                    child: Container(
                      width: 200,
                      height: heightOfPollItem,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: Constants.purpleColor,
                      ),
                      child: Center(
                        child: Text(
                          "Vote",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 18 + Constants.textChange,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 20,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  int getLargestVoteCount(List<dynamic> obj) {
    print("PRINTING OBJ IN FUNCT: " + obj.toString());
    if (obj == null) return 1;
    int largest = 0;
    for (int i = 0; i < obj.length; i++) {
      if (obj[i] > largest) {
        largest = obj[i];
      }
    }
    return largest;
  }

  Widget delimeter(double width) {
    return Container(
      height: .5,
      width: width,
      color: Constants.hintColor,
    );
  }

  showContentOptions(BuildContext ctx) {
    showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(ctx).size.width * .7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Constants.backgroundBlack,
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                delimeter(MediaQuery.of(ctx).size.width * .9),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      showSnackbar(context, "Post has been reported successfully");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Report"),
                          Icon(Icons.arrow_right_alt),
                        ],
                      ),
                    ),
                  ),
                ),
                delimeter(MediaQuery.of(ctx).size.width * .9),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({Key key, this.onChildSize, this.child}) : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChildSize(context.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
