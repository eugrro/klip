import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/Requests.dart';
import 'package:klip/currentUser.dart' as currentUser;
import './Constants.dart' as Constants;
import 'package:klip/widgets.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  Color receiveColor = Colors.black.withOpacity(.5);
  Color sendColor = Constants.purpleColor;
  //true is sent
  //false is recieved
  List<List<dynamic>> notificationResponse;
  TextEditingController sendMessageController = TextEditingController();
  List<Widget> notificationChildren = [];
  AsyncMemoizer memoizer = AsyncMemoizer();
  bool setUpNotifsFromServer = false;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder(
                  future: memoizer.runOnce(() => getNotifications(currentUser.uid)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (!setUpNotifsFromServer) {
                        for (List<dynamic> notifVal in snapshot.data["notifs"]) {
                          notificationChildren.add(getTextBoxFromText(notifVal[0], notifVal[1]));
                        }
                        setUpNotifsFromServer = true;
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: notificationChildren,
                        ),
                      );
                    } else {
                      return Center(
                          child: Container(
                        child: CircularProgressIndicator(),
                        height: 50,
                        width: 50,
                      ));
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 15, top: 7, bottom: 7),
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.bodyText2.color.withOpacity(.4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ExpandingTextField(
                        maxHeightPx: 150, // px value after which textbox won't expand
                        width: MediaQuery.of(context).size.width * 7 / 10, // width of your textfield
                        child: TextField(
                          controller: sendMessageController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1, // number of lines your textfield start with
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Theme.of(context).textTheme.bodyText1.color,
                          cursorWidth: 1.5,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Send a Message",
                            hintStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.7),
                              fontSize: 13 + Constants.textChange,
                            ),
                          ),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.9),
                            fontSize: 13 + Constants.textChange,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (sendMessageController.text != null && sendMessageController.text != "") {
                          addNotification(currentUser.uid, sendMessageController.text, true);
                          setState(() {
                            notificationChildren.add(getTextBoxFromText(sendMessageController.text, true));
                          });
                          //To remove later needs to actually have server response
                          addNotification(currentUser.uid, "I'm sorry, I'm not smart enough to know how to handle that.", false);
                          setState(() {
                            notificationChildren.add(getTextBoxFromText("I'm sorry, I'm not smart enough to know how to handle that.", false));
                          });
                          FocusScope.of(context).unfocus();
                          sendMessageController.text = "";
                        }
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).textTheme.bodyText2.color,
                        child: Icon(
                          Icons.send_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: showBottomNavBar.value ? 55 : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///text is the text to be displayed in the text box
  ///
  ///direction is who sent or recieved True: sent | False: received
  Widget getTextBoxFromText(String text, bool direction) {
    return Align(
      alignment: direction == true ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: direction == true ? sendColor : receiveColor,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(15),
          child: Text(text),
        ),
      ),
    );
  }
}
