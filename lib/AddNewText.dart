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

  String title = "";
  int titleMaxLength = 80;

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
                      Icon(
                        Icons.arrow_back,
                        color: Constants.backgroundWhite,
                        size: 25,
                      ),
                      Text(
                        "Add New Text",
                        style: TextStyle(color: Constants.backgroundWhite, fontSize: 18 + Constants.textChange),
                      ),
                      Icon(
                        Icons.check,
                        color: Constants.backgroundWhite,
                        size: 25,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
