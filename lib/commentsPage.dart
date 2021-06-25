import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'Requests.dart';
import 'currentUser.dart';
import 'widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'Navigation.dart';

// ignore: must_be_immutable
class CommentsPage extends StatefulWidget {
  String pid;
  List<dynamic> comments;
  Function(int) callback;
  CommentsPage(this.pid, this.comments, this.callback);

  @override
  _CommentsPageState createState() => _CommentsPageState(pid, comments, callback);
}

class _CommentsPageState extends State<CommentsPage> {
  String pid;
  List<dynamic> comments;
  Function(int) callback;
  _CommentsPageState(this.pid, this.comments, this.callback);

  TextEditingController commentController = TextEditingController();
  double heightOfCommentBox;
  double heightOfTopPart;

  @override
  void initState() {
    super.initState();
    heightOfCommentBox = 60;
    heightOfTopPart = 60;

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      if (visible)
        showBottomNavBar.value = false;
      else
        showBottomNavBar.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15, right: 20, left: 30), //more on the left since
              //row is space between for title centering
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    "Comments",
                    style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 22),
                  ),
                  GestureDetector(
                    onTap: () {
                      callback(1);
                    },
                    child: Icon(
                      Icons.arrow_right_alt_outlined,
                      size: 26,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 10,
                              ),
                              child: FutureBuilder<Widget>(
                                future: getProfileImage(comments[index][2], getAWSLink(comments[index][0])),
                                // a previously-obtained Future<String> or null
                                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                  double imageRadius = 16;
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      radius: imageRadius,
                                      child: ClipOval(child: snapshot.data ?? Container()),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      radius: imageRadius,
                                      child: ClipOval(child: Constants.tempAvatar ?? Container()),
                                    );
                                  }
                                },
                              ), //Profile Pic
                            ),
                            //COMMENT GENERATION NEEDS TO BE A FUNCTION
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      '${comments[index][1]}', //Uname
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyText1.color,
                                        fontSize: 14 + Constants.textChange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3, top: 2),
                                      child: Text(
                                        '${comments[index][3]}', // comment
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyText1.color,
                                          fontSize: 12 + Constants.textChange,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Text(
                                    getTimeFromSeconds(comments[index][4]), //time posted
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.3),
                                      fontSize: 14 + Constants.textChange,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                //height: heightOfCommentBox,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).textSelectionTheme.cursorColor.withOpacity(.1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder<Widget>(
                        future: getProfileImage(currentUser.uid + "_avatar.jpg", getAWSLink(currentUser.uid)),
                        // a previously-obtained Future<String> or null
                        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                          double imageRadius = 16;
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              radius: imageRadius,
                              child: ClipOval(child: snapshot.data ?? Container()),
                            );
                          } else {
                            return CircleAvatar(
                              radius: imageRadius,
                              child: ClipOval(child: Constants.tempAvatar ?? Container()),
                            );
                          }
                        },
                      ), //Profile Pic

                      Container(
                        width: MediaQuery.of(context).size.width * 8 / 10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: new BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 20,
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              ExpandingTextField(
                                maxHeightPx: 150, // px value after which textbox won't expand
                                width: MediaQuery.of(context).size.width * 6.5 / 10, // width of your textfield
                                child: TextField(
                                  controller: commentController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1, // number of lines your textfield start with
                                  maxLines: null,
                                  textAlignVertical: TextAlignVertical.center,
                                  cursorColor: Theme.of(context).textTheme.bodyText1.color,
                                  cursorWidth: 1.5,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: "Add a Comment...",
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.6),
                                      fontSize: 13 + Constants.textChange,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.9),
                                    fontSize: 13 + Constants.textChange,
                                  ),
                                ),
                              ),
                              postText(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Function validates that user inputted in some text then adds it to the page and mongo
  //Is the post comment widget at the bottom of the screen
  Widget postText() {
    return GestureDetector(
      onTap: () {
        if (commentController.text.isNotEmpty) {
          String currTime = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

          setState(() {
            comments.add([currentUser.uid, currentUser.uName, currentUser.avatarLink, commentController.text, currTime]);
            FocusScope.of(context).requestFocus(new FocusNode());
          });

          addComment(pid, commentController.text, currTime);
          commentController.text = "";
        } else {
          print("No Text Gathered");
        }
      },
      child: Icon(Icons.send),
    );
  }
}
