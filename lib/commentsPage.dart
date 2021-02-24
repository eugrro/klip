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
    heightOfCommentBox = 90;
    heightOfTopPart = 60;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
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
                                    Row(
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
                //color: Colors.lightBlue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width * 3 / 4,
                            child: klipTextField(
                              45,
                              MediaQuery.of(context).size.width * 3 / 4,
                              commentController,
                              labelText: "Add A Comment",
                            ),
                          ),
                          GestureDetector(
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

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                                addComment(
                                    pid,
                                    currentUser.uid,
                                    currentUser.uName,
                                    currentUser.avatarLink,
                                    commentController.text,
                                    "2h");
                                commentController.text = "";
                              }
                            },
                            child: Text(
                              "Post",
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 17 + Constants.textChange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
