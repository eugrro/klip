import 'package:flutter/material.dart';
import 'package:klip/UserPage.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:auto_size_text/auto_size_text.dart';
import 'HomeTabs.dart';
import 'TopNavBar.dart';
import 'TopSection.dart';

class ProfileSettings extends StatefulWidget {
  ProfileSettings();

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  TextEditingController newInfoContr;
  TextEditingController bioContr;
  var newInfoFocus = new FocusNode();
  var biofcs = new FocusNode();
  bool editingBio = false;
  @override
  void initState() {
    newInfoContr = TextEditingController();
    bioContr = TextEditingController(text: currentUser.bio);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        currentUser.uName,
                        style: TextStyle(
                          fontSize: 24 + Constants.textChange,
                          color: Constants.backgroundWhite,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context, SlideDownRoute(page: UserPage()));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 30,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Constants.backgroundWhite,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Stack(
                children: [
                  Opacity(
                    opacity: .4,
                    child: CircleAvatar(
                      radius: 65,
                      child: Image.asset("lib/assets/images/personOutline.png"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("LOAD NEW PROFILE PIC");
                    },
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.transparent,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            "Click to change\nprofile picture",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Constants.hintColor,
                              fontSize: 13 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: AbsorbPointer(
                  absorbing: !editingBio,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    //enabled: editingBio,
                    onTap: () {
                      if (!editingBio) {
                        biofcs.unfocus();
                      }
                    },
                    focusNode: biofcs,
                    cursorColor: Constants.purpleColor,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      //errorBorder: InputBorder.none,
                      //disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                        bottom: 0,
                        top: 0,
                        right: 15,
                      ),
                    ),
                    controller: bioContr,
                    style: TextStyle(
                      color: Constants.backgroundWhite,
                      fontSize: 16 + Constants.textChange,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (editingBio) {
                        setState(() {
                          editingBio = false;
                          biofcs.unfocus();
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: kElevationToShadow[3],
                        color: Constants.purpleColor,
                      ),
                      child: Center(
                          child: editingBio
                              ? Text("Cancel", style: Constants.tStyle())
                              : Text("Edit Background",
                                  style: Constants.tStyle())),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!editingBio) {
                        setState(() {
                          editingBio = true;

                          biofcs.requestFocus();
                        });
                      } else if (editingBio) {
                        setState(() {
                          editingBio = false;
                          currentUser.bio = bioContr.text;
                          biofcs.unfocus();
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: kElevationToShadow[3],
                        color: Constants.purpleColor,
                      ),
                      child: Center(
                          child: editingBio
                              ? Text("Save", style: Constants.tStyle())
                              : Text("Edit Bio", style: Constants.tStyle())),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Constants.purpleColor,
                ),
              ),
              Center(
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      child: Center(
                        child: Text(
                          "Your Information",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 17 + Constants.textChange,
                          ),
                        ),
                      ),
                    ),
                    /*Container(
                      height: 2,
                      color: Constants.purpleColor,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 4),
                    ),*/

                    settingsCard(context, "First Name", currentUser.fName,
                        "Change your first name", false, true),
                    settingsCard(context, "Last Name", currentUser.lName,
                        "Change your last name", false, true),
                    settingsCard(context, "Email", currentUser.email,
                        "Change your email", false, true),
                    settingsCard(context, "Username", currentUser.uName,
                        "Change your first name", false, true),
                    settingsCard(context, "Password", "* * * * * * * *",
                        "Request to update your password", false, false),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: Text(
                          "Preferences",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 17 + Constants.textChange,
                          ),
                        ),
                      ),
                    ),
                    settingsCard(context, "Theme", "Dark",
                        "Update your theme preference", false, true),
                    settingsCard(
                        context,
                        "Show Username",
                        "Show First + Fast Name",
                        "Change how you will be displayed on the app",
                        false,
                        true),
                    settingsCard(context, "Comment Color", "Purple",
                        "Change your prefered comment color", false, true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  inputNewInfo(
    BuildContext ctx,
    TextEditingController contr,
    String suppText,
    String hint,
    FocusNode fcs,
  ) {
    fcs.requestFocus();
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: ctx,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //TODO
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: kElevationToShadow[3],
                          color: Constants.purpleColor,
                        ),
                        child: Center(
                          child: Text(
                            "X",
                            style: TextStyle(
                              color: Constants.backgroundWhite,
                              fontSize: 30 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          //TODO
                        });
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: kElevationToShadow[3],
                          color: Constants.purpleColor,
                        ),
                        child: Center(
                            child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 35,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //height: 200,
                decoration: BoxDecoration(
                  color: Constants.backgroundBlack,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: MediaQuery.of(context).size.width / 6),
                      child: TextFormField(
                        autofocus: true,
                        focusNode: fcs,
                        cursorColor: Constants.purpleColor,
                        decoration: new InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Constants.purpleColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Constants.purpleColor,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Constants.purpleColor,
                              width: 1,
                            ),
                          ),
                          //errorBorder: InputBorder.none,
                          //disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 15,
                            bottom: 0,
                            top: 0,
                            right: 15,
                          ),

                          labelText: hint,
                          labelStyle: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 16 + Constants.textChange,
                            height: 1.5,
                          ),
                        ),
                        controller: contr,
                        style: TextStyle(
                          color: Constants.backgroundWhite,
                          fontSize: 20 + Constants.textChange,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text(
                        suppText,
                        style: Constants.tStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //color: Colors.redAccent,
        );
      },
    );
  }

  Widget settingsCard(BuildContext context, String txt1, String txt2,
      String description, bool showTopLine, bool showBottomLine) {
    return Column(
      children: [
        showTopLine
            ? Container(
                height: 1,
                color: Constants.hintColor.withOpacity(.3),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              )
            : Container(),
        GestureDetector(
          onTap: () {
            newInfoContr.selection = TextSelection(
              baseOffset: 0,
              extentOffset: newInfoContr.text.length,
            );
            newInfoContr.text = txt2;
            inputNewInfo(
                context, newInfoContr, description, txt1, newInfoFocus);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  txt1,
                  style: TextStyle(
                    color: Constants.backgroundWhite,
                    fontSize: 14 + Constants.textChange,
                  ),
                ),
                Text(
                  txt2,
                  style: TextStyle(
                    color: Constants.hintColor,
                    fontSize: 14 + Constants.textChange,
                  ),
                ),
              ],
            ),
          ),
        ),
        showBottomLine
            ? Container(
                height: 1,
                color: Constants.hintColor.withOpacity(.3),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              )
            : Container(),
      ],
    );
  }
}

class SlideDownRoute extends PageRouteBuilder {
  final Widget page;
  SlideDownRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}