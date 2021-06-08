import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'Navigation.dart';
import 'Requests.dart';

//Add dynamic textfield widget here
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    // border:
                    //borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        //color: Theme.of(context).scaffoldBackgroundColor,
                        blurRadius: 1.0,
                        spreadRadius: 0.0,
                        offset: Offset(2.0, 2.0), // shadow direction: bottom right
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
                                color: Theme.of(context).textTheme.bodyText1.color,
                                size: 20,
                              ),
                              Container(
                                width: 20,
                              ),
                              Text(
                                "Add New Text",
                                style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 18 + Constants.textChange),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.check,
                            color: Theme.of(context).textTheme.bodyText1.color,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 150),
                    child: TextFormField(
                      maxLength: 150,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: titleController,
                      maxLines: null,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Theme.of(context).textSelectionTheme.cursorColor, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Theme.of(context).textSelectionTheme.cursorColor, width: 2),
                          ),
                          hintText: "An Interesting title",
                          hintStyle: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: TextFormField(
                      controller: bodyController,
                      minLines: 5,
                      maxLines: null,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Theme.of(context).textSelectionTheme.cursorColor, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Theme.of(context).textSelectionTheme.cursorColor, width: 2),
                          ),
                          hintText: "Your text post",
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
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
                        ).then((value) {
                          while (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          color: Theme.of(context).textSelectionTheme.cursorColor,
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color,
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
