import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:klip/widgets.dart';
import 'Requests.dart';

class AddNewText extends StatefulWidget {
  @override
  _AddNewTextState createState() => _AddNewTextState();
}

class _AddNewTextState extends State<AddNewText> {
  TextEditingController titleController;
  TextEditingController bodyController;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    bodyController = TextEditingController();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // border:
                    //borderRadius: BorderRadius.circular(8.0),
                    color: Constants.backgroundBlack,
                    boxShadow: [
                      BoxShadow(
                        //color: Constants.backgroundBlack,
                        blurRadius: 1.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: MediaQuery.of(context).size.width / 30,
                      right: MediaQuery.of(context).size.width / 30,
                      bottom: 15,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Constants.backgroundWhite,
                                size: 20,
                              ),
                              Container(
                                width: 20,
                              ),
                              Text(
                                "Add New Text",
                                style: TextStyle(
                                    color: Constants.backgroundWhite,
                                    fontSize: 18 + Constants.textChange),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.check,
                            color: Constants.backgroundWhite,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Title",
                    style: TextStyle(
                      color: Constants.backgroundWhite,
                      fontSize: 18 + Constants.textChange,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .05),
                  child: klipTextField(
                    100,
                    MediaQuery.of(context).size.width * .9,
                    titleController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Body",
                    style: TextStyle(
                      color: Constants.backgroundWhite,
                      fontSize: 18 + Constants.textChange,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .05),
                  child: klipTextField(
                    300,
                    MediaQuery.of(context).size.width * .9,
                    bodyController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        addTextContent(
                          currentUser.uid,
                          titleController.text,
                          bodyController.text,
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          color: Constants.purpleColor,
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Constants.backgroundWhite,
                              fontSize: 14 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
