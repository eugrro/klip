import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:klip/widgets.dart';
import 'Requests.dart';

// ignore: must_be_immutable
class CommentsPage extends StatefulWidget {
  String pid;
  List<dynamic> comments;
  CommentsPage(this.pid, this.comments);

  @override
  _CommentsPageState createState() => _CommentsPageState(pid, comments);
}

class _CommentsPageState extends State<CommentsPage> {
  String pid;
  List<dynamic> comments;
  _CommentsPageState(this.pid, this.comments);

  TextEditingController commentController = TextEditingController();
  double heightOfCommentBox;
  double heightOfTopPart;

  @override
  void initState() {
    super.initState();
    heightOfCommentBox = 75;
    heightOfTopPart = 60;
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
        backgroundColor: Constants.backgroundBlack,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: heightOfTopPart,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 30),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Constants.backgroundWhite,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Comments",
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 20 + Constants.textChange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom -
                    MediaQuery.of(context).padding.top -
                    heightOfTopPart -
                    heightOfCommentBox,
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
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
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                        comments[index][2]), //Profile Pic
                                  ),
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
                                            color: Constants.backgroundWhite,
                                            fontSize: 14 + Constants.textChange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 3, top: 2),
                                          child: Text(
                                            '${comments[index][3]}', // comment
                                            style: TextStyle(
                                              color: Constants.backgroundWhite,
                                              fontSize:
                                                  12 + Constants.textChange,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Text(
                                        '${comments[index][4]}', //time posted
                                        style: TextStyle(
                                          color: Constants.backgroundWhite
                                              .withOpacity(.3),
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
              ),
              Container(
                height: heightOfCommentBox,
                width: MediaQuery.of(context).size.width,
                color: Constants.purpleColor.withOpacity(.1),
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        height: heightOfCommentBox * .7,
                        width: MediaQuery.of(context).size.width * 9 / 10,
                        decoration: BoxDecoration(
                          color: Constants.backgroundBlack,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 52, //16 * 2 + 20
                            right: 15,
                          ),
                          child: TextField(
                            controller: commentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: Constants.backgroundWhite,
                            cursorWidth: 1.5,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Add a Comment...",
                              hintStyle: TextStyle(
                                color:
                                    Constants.backgroundWhite.withOpacity(.6),
                                fontSize: 13 + Constants.textChange,
                              ),
                              suffixIcon: postText(),
                            ),
                            style: TextStyle(
                              color: Constants.backgroundWhite.withOpacity(.9),
                              fontSize: 13 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          top: heightOfCommentBox * .35 - 16,
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            currentUser.avatarLink,
                          ), //Profile Pic
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postText() {
    return GestureDetector(
      onTap: () {
        print("Post ID: ");
        print(pid);
        if (commentController.text.isNotEmpty) {
          setState(() {
            comments.add([
              currentUser.uid,
              currentUser.uName,
              currentUser.avatarLink,
              commentController.text,
              "2h"
            ]);

            FocusScope.of(context).requestFocus(new FocusNode());
          });
          addComment(pid, currentUser.uid, currentUser.uName,
              currentUser.avatarLink, commentController.text, "2h");
          commentController.text = "";
        } else {
          print("No Text Gathered");
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: heightOfCommentBox * .35 - 13 - Constants.textChange,
          left: 15,
        ), //perfectly even is -14
        child: Text(
          "Post",
          style: TextStyle(
            color: Constants.backgroundWhite,
            fontSize: 14 + Constants.textChange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
