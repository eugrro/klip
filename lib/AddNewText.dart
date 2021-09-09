import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'AddTagWidget.dart';
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

  String title = "";
  int titleMaxLength = 80;
  bool isPostingText = false;

  ValueNotifier<List<String>> tags = ValueNotifier([]);
  ScrollController antScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    bodyController = TextEditingController();
    tags.addListener(() {
      if (tags.value.length == 1) {
        antScrollController.animateTo(
          antScrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
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
        backgroundColor: Constants.theme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: antScrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: MediaQuery.of(context).size.width / 30,
                    right: MediaQuery.of(context).size.width / 30,
                    bottom: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Constants.theme.foreground,
                          size: 25,
                        ),
                      ),
                      Text(
                        "Add New Text",
                        style: TextStyle(color: Constants.theme.foreground, fontSize: 18 + Constants.textChange),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          addTextContent(currentUser.uid, titleController.text, bodyController.text, tags.value).then((value) {});
                        },
                        child: isPostingText
                            ? CircularProgressIndicator()
                            : Icon(
                                Icons.check,
                                color: Constants.theme.foreground,
                                size: 25,
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width * .95,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 150),
                    child: TextFormField(
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      onChanged: (String value) {
                        if (value.length > titleMaxLength) {
                          value = value.substring(0, titleMaxLength);
                          titleController.text = value;
                          //move cursor to end
                          titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));
                        }
                        setState(() {
                          title = value;
                        });
                      },
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: titleController,
                      maxLines: null,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "An Interesting Title", hintStyle: TextStyle(fontSize: 17)),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Constants.hintColor,
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      title.length.toString() + "/" + titleMaxLength.toString(),
                      style: TextStyle(
                        color: title.length >= 55
                            ? Colors.red
                            : title.length >= 40
                                ? Colors.yellow
                                : Constants.hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .95,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: TextFormField(
                      controller: bodyController,
                      minLines: 5,
                      maxLines: null,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Your Text Body", hintStyle: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                AddTagWidget(tags),
                Container(
                  height: 10,
                ),
                tags.value.length > 0
                    ? Text(
                        "Tap on a tag to remove it",
                        style: TextStyle(color: Constants.hintColor, fontSize: 12 + Constants.textChange),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
