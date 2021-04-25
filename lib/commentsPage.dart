import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'Requests.dart';

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
    heightOfCommentBox = 75;
    heightOfTopPart = 60;
    print(comments);
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15, right: 20, left: 30), //more on the left since row is space between for title centering
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    "Comments",
                    style: TextStyle(color: Constants.backgroundWhite, fontSize: 22),
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
                              child: CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(comments[index][2]), //Profile Pic
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
                                      padding: EdgeInsets.only(left: 3, top: 2),
                                      child: Text(
                                        '${comments[index][3]}', // comment
                                        style: TextStyle(
                                          color: Constants.backgroundWhite,
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
                                      color: Constants.backgroundWhite.withOpacity(.3),
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
                          borderRadius: new BorderRadius.all(Radius.circular(100)),
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
                                color: Constants.backgroundWhite.withOpacity(.6),
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
            ),
          ],
        ),
      ),
    );
  }

  String getTimeFromSeconds(String input) {
    //entire function is in seconds no need to go to milliseconds
    if (input == "" || input == " " || input == null) return "";
    //get current time in seconds
    int currTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    print("INPUT: " + input);
    int inputTime = int.tryParse(input);
    if (inputTime == null) return "";
    int differenceTime = currTime - inputTime;
    //Year
    int oneYear = 60 * 60 * 24 * 365;
    if (differenceTime > oneYear) {
      int numYears = (differenceTime / oneYear).round();
      if (numYears == 0) return "ERROR year";
      return numYears.toString() + "y";
    }
    //Month
    int oneMonth = 60 * 60 * 24 * 30;
    if (differenceTime > oneMonth) {
      int numMonths = (differenceTime / oneMonth).round();
      if (numMonths == 0) return "ERROR month";
      return numMonths.toString() + "m";
    }
    //Week
    int oneWeek = 60 * 60 * 24 * 7;
    if (differenceTime > oneWeek) {
      int numWeeks = (differenceTime / oneWeek).round();
      if (numWeeks == 0) return "ERROR week";
      return numWeeks.toString() + "y";
    }
    //Day
    int oneDay = 60 * 60 * 24;
    if (differenceTime > oneDay) {
      int numDays = (differenceTime / oneDay).round();
      if (numDays == 0) return "ERROR day";
      return numDays.toString() + "d";
    }
    //Hour
    int oneHour = 60 * 60;
    if (differenceTime > oneHour) {
      int numHours = (differenceTime / oneHour).round();
      if (numHours == 0) return "ERROR day";
      return numHours.toString() + "h";
    }
    //Minutes
    int oneMinute = 60;
    if (differenceTime > oneMinute) {
      int numMinutes = (differenceTime / oneMinute).round();
      if (numMinutes == 0) return "ERROR min";
      return numMinutes.toString() + " min";
    }
    return "< 1 minute ago";
  }

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
