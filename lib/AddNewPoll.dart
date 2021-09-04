import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'Navigation.dart';
import 'Requests.dart';

//Add dynamic textfield widget here
class AddNewPoll extends StatefulWidget {
  @override
  _AddNewPollState createState() => _AddNewPollState();
}

class _AddNewPollState extends State<AddNewPoll> {
  TextEditingController titleController;
  TextEditingController bodyController;

  List<dynamic> pollOptions = ["", ""];

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
        backgroundColor: Constants.theme.background,
        appBar: AppBar(
          title: Text("Add New Poll"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                            borderSide: BorderSide(color: Constants.purpleColor, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Constants.purpleColor, width: 2),
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
                    child: Text(
                  "Poll Options",
                  style: TextStyle(color: Constants.theme.foreground, fontSize: 18 + Constants.textChange),
                )),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10),
                  itemCount: pollOptions.length,
                  itemBuilder: (context, index) {
                    return pollOption(index);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (pollOptions.length > 2) {
                            setState(() {
                              pollOptions.removeLast();
                            });
                          } else {
                            showError(context, "Poll must have at least 2 items");
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Constants.purpleColor,
                          ),
                          child: Center(
                            child: Text(
                              "Remove Poll Option",
                              style: TextStyle(
                                color: Constants.theme.foreground,
                                fontSize: 14 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (pollOptions.length < 5) {
                            setState(() {
                              pollOptions.add("");
                            });
                          } else {
                            showError(context, "Cannot have more than 5 poll items");
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Constants.purpleColor,
                          ),
                          child: Center(
                            child: Text(
                              "Add Poll Option",
                              style: TextStyle(
                                color: Constants.theme.foreground,
                                fontSize: 14 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 70, bottom: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        addPollContent(
                          currentUser.uid,
                          titleController.text,
                          pollOptions,
                        ).then((value) {
                          while (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 * 3,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          color: Constants.purpleColor,
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Constants.theme.foreground,
                              fontSize: 20 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pollOption(int textIndex) {
    TextEditingController pollOptionController = TextEditingController(text: pollOptions[textIndex]);
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 16,
        right: MediaQuery.of(context).size.width / 16,
        bottom: 0,
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: Constants.purpleColor,
            size: 20,
          ),
          Container(
            width: 20,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 125),
                child: TextFormField(
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  onChanged: (String value) {
                    pollOptions[textIndex] = value;
                  },
                  maxLength: 60,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: pollOptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Constants.purpleColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Constants.purpleColor, width: 2),
                      ),
                      hintText: "A poll option",
                      hintStyle: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
