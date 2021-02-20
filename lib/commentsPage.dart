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
    heightOfTopPart = 50;
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
                      Row(
                        children: [
                          GestureDetector(
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
                          Text(
                            "Comments",
                            style: TextStyle(
                              color: Constants.backgroundWhite,
                              fontSize: 20 + Constants.textChange,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * .5,
                        color: Constants.backgroundWhite,
                      ),
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
                          bottom: 15,
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                            ),
                            child: Text(
                              '${comments[index]}',
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 16 + Constants.textChange,
                              ),
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
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * .5,
                      color: Constants.backgroundWhite,
                    ),
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
                                  comments.add(commentController.text);

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                                addComment(currentUser.uid, pid,
                                    commentController.text);
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
