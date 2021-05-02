import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/login/AvatarCreation.dart';
import 'package:klip/login/SignIn.dart';
import 'package:klip/login/SignUp.dart';
import 'package:klip/widgets.dart';
import '../Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'loginLogic.dart';
import '../TopNavBar.dart';
import '../TopSection.dart';

// Define a custom Form widget.
class UsernameCreation extends StatefulWidget {
  @override
  _UsernameCreationState createState() => _UsernameCreationState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _UsernameCreationState extends State<UsernameCreation> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  double heightOfButtons = 45;
  bool initialsuffixWidget = true;
  bool isNextVisible = false;
  int currentPage = 1;
  double heightOfContainer = 60;
  double borderThickness = 3;
  double imgThickness = 50;
  bool isUserNameValid = false;
  final validUserNameCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  String validatedUserName;
  final usernameController = TextEditingController();
  int nextAnimationDuration = 250;
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    usernameController.addListener(usernameControllerHandler);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    usernameController.dispose();
    super.dispose();
  }

  usernameControllerHandler() {
    //print("Second text field: ${usernameController.text}");

    if (validUserNameCharacters.hasMatch(usernameController.text) == false ||
        usernameController.value.text != validatedUserName ||
        usernameController.value.text.length < 4)
      setState(() {
        isUserNameValid = false;
      });
  }

  String validateUsername(value) {
    if (initialsuffixWidget == true) initialsuffixWidget = false;
    if (value.isEmpty) {
      isNextVisible = false;
      return "Username cannot be empty";
    }
    if (validUserNameCharacters.hasMatch(value) == false) {
      isNextVisible = false;
      return "Username must only contain alphanumeric values";
    }
    if (value.length < 4) {
      isNextVisible = false;
      return "Username must contain at least 4 values";
    }
    if (usernameController.value.text != validatedUserName) {
      checkUserNameExists();

      return "Checking if Username Exists";
    }
    if (isUserNameValid == false)
      return 'Username already exists';
    else
      return null;
  }

  void checkUserNameExists() async {
    final String userNameValue = usernameController.value.text;
    final bool doesExist = await (doesUsernameExist(userNameValue));
    if (userNameValue != usernameController.value.text) return;
    setState(() {
      validatedUserName = userNameValue;

      isUserNameValid = !doesExist;
      isNextVisible = !doesExist;
    });
  }

  Widget getSuffixWdiget() {
    if (initialsuffixWidget)
      return Container();
    else if (isNextVisible == true) {
      return Icon(
        Icons.check,
        color: Colors.green,
      );
    } else {
      return IconButton(
          icon: Icon(Icons.highlight_off, color: Colors.red),
          onPressed: () {
            usernameController.text = "";
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: Constants.statusBarHeight,
        ),
        child: Scaffold(
            body: Stack(children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.9, 0.4, 0.5, 0.9],
                  colors: [Constants.purpleColor, Constants.purpleColor.withOpacity(.6), Constants.purpleColor.withOpacity(.1), Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.srcIn,
              child: Image.asset(
                "lib/assets/iconsUI/geometricLines3.png",
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height / 2.5,
                fit: BoxFit.fill,
                //color: Colors.grey,
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20)),
                  Text("Welcome!", style: TextStyle(color: Constants.backgroundWhite, fontSize: 48 + Constants.textChange)),
                  Text("Let's get you a username",
                      overflow: TextOverflow.visible, style: TextStyle(color: Constants.hintColor, fontSize: 20 + Constants.textChange)),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5)),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Stack(alignment: AlignmentDirectional.center, children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .8,
                          height: heightOfContainer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                              width: borderThickness,
                              color: Constants.purpleColor.withOpacity(.8),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: heightOfContainer,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 9 / 10,
                                decoration: BoxDecoration(
                                  color: Constants.backgroundBlack,
                                  borderRadius: new BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 10 + imgThickness,
                                    right: 20, //+ imgThickness,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                  top: heightOfContainer * .5 - imgThickness / 2 - borderThickness,
                                ),
                                child: Container(
                                  width: imgThickness,
                                  height: imgThickness,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "lib/assets/iconsUI/personOutline.svg",
                                      color: Constants.backgroundWhite.withOpacity(.9),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                  top: heightOfContainer * .5 - imgThickness / 2 - borderThickness,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: imgThickness,
                                    height: imgThickness,
                                    child: Center(child: getSuffixWdiget()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 0, top: 50),
                            child: SizedBox(
                              height: (heightOfContainer * 2 - imgThickness / 2 - borderThickness),
                              width: 250 - imgThickness,
                              child: TextFormField(
                                controller: usernameController,
                                keyboardType: TextInputType.multiline,
                                obscureText: false,
                                //textAlign: TextAlign.center,
                                cursorColor: Constants.backgroundWhite,
                                cursorWidth: 1.5,
                                validator: validateUsername,
                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: false,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  errorMaxLines: 2,
                                  hintText: "Username",
                                  helperText: ' ',

                                  hintStyle: TextStyle(
                                    color: Constants.backgroundWhite.withOpacity(.6),
                                    fontSize: 20 + Constants.textChange,
                                  ),
                                  //suffixIcon: postText(),
                                ),

                                style: TextStyle(color: Constants.backgroundWhite.withOpacity(.9), fontSize: 20 + Constants.textChange, height: 1),
                              ),
                            )),
                      ])),
                  GestureDetector(
                      onTap: () async {
                        if (isUserNameValid == true) {
                          currentUser.uName = validatedUserName;

                          String updateuname = await updateUsername(currentUser.uid, currentUser.uName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AvatarCreation()),
                          );
                        }
                      },
                      child: AnimatedOpacity(
                        opacity: isNextVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: nextAnimationDuration),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: heightOfContainer - 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Constants.purpleColor, Color(0xffab57a8)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 24 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              )))
        ])),
      ),
    );
  }
}
