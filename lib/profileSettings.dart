import 'dart:io';
import "./currentUser.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "Themes.dart" as Themes;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klip/UserPage.dart';
import 'package:klip/login/StartPage.dart';
import 'package:klip/login/loginLogic.dart';
import 'package:klip/widgets.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:theme_provider/theme_provider.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

import 'CropProfilePic.dart';
import 'Requests.dart';
import 'currentUser.dart';
import 'utils.dart';

class ProfileSettings extends StatefulWidget {
  ProfileSettings();

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings>
    with SingleTickerProviderStateMixin {
  TextEditingController newInfoContr;
  TextEditingController bioContr;
  TextEditingController bioLinkContr;
  var newInfoFocus = new FocusNode();
  var biofcs = new FocusNode();
  bool editingBio = false;
  File contentImage;
  final imgCropKey = GlobalKey<ImgCropState>();
  /*bool darkTheme = true;
  String currentThemeID = "dark";
  void toggleTheme(BuildContext context, List<dynamic> newThemes) {
  When using to change themes, only pass in a list of ThemeData objects
  and use first object (perhaps modify settingsCard in order to achieve this)
    setState(() {
      if (darkTheme) {
        this.darkTheme = false;
        currentThemeID = "light";
        print("Dark Theme: " + darkTheme.toString() + ' ' + currentThemeID);
      } else {
        this.darkTheme = true;
        currentThemeID = "dark";
        print("Dark Theme: " + darkTheme.toString() + ' ' + currentThemeID);
      }
      currentUser.themePreference = currentThemeID;
      //Fine if not awaited
      //need to store user's preferences at this point
      setFieldInSharedPreferences("themePreference", currentThemeID);
      currentUser.saveOnePreferenceToMongo("themePreference", currentThemeID);
    });

    //set theme here
    print(currentThemeID);
    ThemeProvider.controllerOf(context).setTheme(currentThemeID);
  }*/
  AnimationController _animationController;
  Animation _animation;
  @override
  void initState() {
    newInfoContr = TextEditingController();
    bioContr = TextEditingController(text: currentUser.bio);
    bioLinkContr = TextEditingController();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    //TODO: Change end value to keyboard height
    _animation = Tween(begin: 0.0, end: 250.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                top: Constants.statusBarHeight + 10,
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
                          Navigator.of(context).pop();
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
                  child: Container(
                    width: 150,
                    child: ClipOval(
                      child: FutureBuilder<Widget>(
                        future: currentUser
                            .userProfileImg, // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data;
                          } else {
                            return Constants.tempAvatar;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.transparent,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Text(
                          "Click to change\nprofile picture",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(.7),
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
              padding: EdgeInsets.only(
                bottom: 5,
                top: 5,
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
                    height: 35,
                    width: MediaQuery.of(context).size.width * .28,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Constants.purpleColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: editingBio
                          ? Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red[400],
                              ),
                            )
                          : Text(
                              "Edit Background",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Constants.backgroundWhite,
                              ),
                            ),
                    ),
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
                      updateOne(currentUser.uid, "bio", bioContr.text);
                    }
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * .28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      //boxShadow: kElevationToShadow[3],
                      color: Colors.transparent,
                      border: Border.all(
                        color: Constants.purpleColor,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: editingBio
                          ? Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green[400],
                              ),
                            )
                          : Text(
                              "Edit Bio",
                              style: TextStyle(
                                fontSize: 13,
                                color: Constants.backgroundWhite,
                              ),
                            ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (editingBio) {
                      showError(context, "Not yet implemented");
                    } else if (currentUser.bioLink != null &&
                        currentUser.bioLink != "") {
                      bioLinkContr.text = currentUser.bioLink;
                      editBioLink(context);
                    } else {
                      editBioLink(context);
                    }
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * .28,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Constants.purpleColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: editingBio
                          ? Text(
                              "Another Option",
                              style: TextStyle(
                                fontSize: 12,
                                color: Constants.backgroundWhite,
                              ),
                            )
                          : currentUser.bioLink != null &&
                                  currentUser.bioLink != ""
                              ? Text(
                                  "Edit Link",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                  ),
                                )
                              : Text(
                                  "Add A Link",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Container(
                height: 1.5,
                width: MediaQuery.of(context).size.width,
                color: Constants.hintColor,
              ),
            ),
            Center(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
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

                  settingsCard(
                      context,
                      "First Name",
                      currentUser.fName,
                      "Change your first name",
                      false,
                      true,
                      _animationController,
                      _animation,
                      mongoParamName: "fName"),
                  settingsCard(
                      context,
                      "Last Name",
                      currentUser.lName,
                      "Change your last name",
                      false,
                      true,
                      _animationController,
                      _animation,
                      mongoParamName: "lName"),
                  settingsCard(
                      context,
                      "Xbox Gamertag",
                      currentUser.xTag,
                      "Request to update your password",
                      false,
                      true,
                      _animationController,
                      _animation,
                      mongoParamName: "xTag",
                      customfunction: notYetImplemented),
                  settingsCard(
                      context,
                      "Email",
                      currentUser.email,
                      "Change your email",
                      false,
                      true,
                      _animationController,
                      _animation,
                      mongoParamName: "email",
                      customfunction: notYetImplemented),
                  settingsCard(
                      context,
                      "Username",
                      currentUser.uName,
                      "Change your username",
                      false,
                      true,
                      _animationController,
                      _animation,
                      mongoParamName: "uName"),
                  settingsCard(
                    context, "Password", "* * * * * * * *",
                    "Request to update your password", false, false,
                    _animationController, _animation,
                    mongoParamName: "pass",
                    //input box which sends request upon completion
                  ),

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
                  settingsCard(
                      context,
                      "Theme",
                      capitalize("Dark"),
                      "Update your theme preference",
                      false,
                      true,
                      _animationController,
                      _animation,
                      customfunction: notYetImplemented),
                  // customfunction: toggleTheme,
                  // customFunctionParams: [Themes.darkTheme]),

                  settingsCard(
                      context,
                      "Show Username",
                      "Show First + Fast Name",
                      "Change how you will be displayed on the app",
                      false,
                      true,
                      _animationController,
                      _animation,
                      customfunction: notYetImplemented),
                  settingsCard(
                      context,
                      "Comment Color",
                      "Purple",
                      "Change your prefered comment color",
                      false,
                      false,
                      _animationController,
                      _animation,
                      customfunction: notYetImplemented),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        "Danger Zone",
                        style: TextStyle(
                          color: Colors.red.withOpacity(.8),
                          fontSize: 17 + Constants.textChange,
                        ),
                      ),
                    ),
                  ),
                  settingsCard(context, "Report A Bug", "", "Report a bug",
                      false, true, _animationController, _animation,
                      txt1Color: Colors.blue[700],
                      customfunction: reportABug,
                      customFunctionParams: [newInfoFocus]),
                  settingsCard(context, "Sign out", "", "Sign out", false, true,
                      _animationController, _animation,
                      customfunction: signOutUserWidget),
                  settingsCard(
                    context,
                    "Delete Your Account",
                    "",
                    "Delete your account",
                    false,
                    false,
                    _animationController,
                    _animation,
                    txt1Color: Colors.redAccent,
                    customfunction: deleteUserWidget,
                  ),
                  //TODO implement delete account and sign out
                  Container(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  notYetImplemented(BuildContext ctx, List<dynamic> params) {
    showError(ctx, "Feature is in development\nShould be out by beta :)");
  }

  editBioLink(BuildContext ctx) {
    showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 34,
          scrollable: true,
          backgroundColor: Constants.backgroundBlack,
          title: Center(child: Text('Add a Link')),
          content: Container(
            width: MediaQuery.of(context).size.width * .8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  child: TextField(
                    maxLines: 1,
                    controller: bioLinkContr,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: .5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(.8),
                            width: 1.5),
                      ),
                      hintText: 'http://',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                      fillColor: Colors.grey[850],
                      focusColor: Colors.red,
                      filled: true,
                      isCollapsed: true,
                    ),
                    //expands: true,
                    keyboardType: TextInputType.multiline,
                    //maxLines: null,
                  ),
                ),
                Container(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 14 + Constants.textChange,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 1,
                      color: Constants.backgroundWhite,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        updateOne(uid, "bioLink", bioLinkContr.text);
                        currentUser.setFieldInSharedPreferences(
                            "bioLink", bioLinkContr.text);
                        Navigator.of(context).pop();
                        currentUser.bioLink = bioLinkContr.text;
                      },
                      child: Center(
                        child: Text(
                          currentUser.bioLink != "" &&
                                  currentUser.bioLink != null
                              ? "Update"
                              : "Add",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 14 + Constants.textChange,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  signOutUserWidget(BuildContext ctx, List<dynamic> params) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.black,
      isScrollControlled: true,
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Are you sure you want to sign out?",
                style: TextStyle(
                  color: Constants.backgroundWhite,
                  //TODO: Adjust color scheme of this widget with context
                  fontSize: 18 + Constants.textChange,
                  decoration: TextDecoration.none,
                ),
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: kElevationToShadow[3],
                        color: Constants.purpleColor,
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(
                            fontSize: 13,
                            color: Constants.backgroundWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      clearSharedPreferences();
                      String ret = await signOutUser();
                      if (ret == "SignOutSuccessful") {
                        print(ret);
                        while (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => StartPage()),
                        );
                      } else {
                        Navigator.of(context).pop();
                        showError(context,
                            "Sign out was unsuccessful please report this bug");
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: kElevationToShadow[3],
                        color: Constants.purpleColor,
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            fontSize: 13,
                            color: Constants.backgroundWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  reportABug(BuildContext ctx, List<dynamic> params) {
    FocusNode fcs = params[0];
    fcs.requestFocus();
    TextEditingController bugController = TextEditingController();
    showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constants.backgroundBlack,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 5),
                    child: Text(
                      "Report A Bug",
                      style: TextStyle(
                        color: Constants.backgroundWhite,
                        fontSize: 18 + Constants.textChange,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Material(
                    child: TextField(
                      maxLines: 12,
                      controller: bugController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: .5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .color
                                  .withOpacity(.8),
                              width: 1.5),
                        ),
                        hintText: 'Report the bug here',
                        fillColor: Colors.grey[850],
                        focusColor: Colors.red,
                        filled: true,
                        isCollapsed: true,
                      ),
                      //expands: true,
                      keyboardType: TextInputType.multiline,
                      //maxLines: null,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 15, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * .4 - 15,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: 14 + Constants.textChange,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              color: Constants.backgroundWhite,
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (bugController.text.length > 20) {
                                  reportBug(
                                      currentUser.uid, bugController.text);
                                  Navigator.of(context).pop();
                                  showSnackbar(context,
                                      "Thank you for reporting and improving\nthe app experience");
                                } else {
                                  showError(context,
                                      "Bug Report must have at least 20 characters");
                                }
                              },
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * .4 - 15,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: 14 + Constants.textChange,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  inputNewInfo(
    BuildContext ctx,
    TextEditingController contr,
    String suppText,
    String hint,
    FocusNode fcs,
    AnimationController animationController,
    Animation animation, {
    String mongoParamName = "",
  }) {
    fcs.requestFocus();
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: ctx,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: 20, right: 15, bottom: 15),
                            child: Container(
                              width:
                                  MediaQuery.of(context).size.width / 100 * 55,
                              child: LoginTextField(
                                context,
                                45,
                                3,
                                10,
                                hint,
                                contr,
                                Container(),
                                focusNode: fcs,
                                isAutoFocus: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6, right: 5),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 40,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .cursorColor
                                        .withOpacity(.5),
                                    boxShadow: kElevationToShadow[12],
                                  ),
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6, left: 5),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (mongoParamName != "pass" &&
                                      mongoParamName != "") {
                                    updateOne(currentUser.uid, mongoParamName,
                                        contr.text);

                                    setFieldInSharedPreferences(
                                        mongoParamName, contr.text);
                                    if (mongoParamName == "fName")
                                      currentUser.fName = contr.text;
                                    if (mongoParamName == "lName")
                                      currentUser.lName = contr.text;
                                    if (mongoParamName == "bio")
                                      currentUser.bio = contr.text;
                                    if (mongoParamName == "email")
                                      currentUser.email = contr.text;
                                    if (mongoParamName == "uName")
                                      currentUser.uName = contr.text;

                                    //TODO any other settings feature needs to be added to mongo if necessary
                                    setState(() {});
                                  } else if (mongoParamName == "") {
                                    print(
                                        "App preferance change no need to update mongo");
                                  } else if (mongoParamName == "pass") {
                                    changePassword(contr.text);
                                    //TODO: Possibly manage response to change in user password
                                  } else {
                                    showError(context,
                                        "Update password feature not yet implemented");
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 40,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .cursorColor
                                        .withOpacity(.5),
                                    boxShadow: kElevationToShadow[12],
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      suppText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Constants.backgroundWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: animation.value),
          ],
        );
      },
    );
  }

  String getKlipParamNameFromMongoParamName(BuildContext ctx, String mParam) {
    if (mParam == "fName") {
      return "fName";
    } else if (mParam == "lName") {
      return "lName";
    } else if (mParam == "bio") {
      return "bio";
    } else if (mParam == "fName") {
      return "fName";
    } else if (mParam == "email") {
      return "email";
    } else if (mParam == "uName") {
      return "uName";
    } else {
      showError(ctx, "mongoParamName was not set yet please update");
      return "";
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () {
                    getImageGallery().then((value) async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CropProfilePic(contentImage, imgCropKey),
                        ),
                      ).then(
                        (value) async {
                          if (value) {
                            final crop = imgCropKey.currentState;
                            File newFile = await crop.cropCompleted(
                                contentImage,
                                preferredSize: 600);
                            Image newImg = Image.file(newFile);
                            updateAvatar(newFile.path, currentUser.uid);
                            setState(() {
                              //little bit of a hacky way but this needs to return a future
                              currentUser.userProfileImg =
                                  Future.delayed(Duration(seconds: 0), () {
                                return newImg;
                              });
                            });
                            Navigator.of(context).pop();
                          }
                        },
                      );

                      // show you croppedFile â€¦â€¦
                      //showImage(context, croppedFile);
                    });
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    getImageGallery().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CropProfilePic(contentImage, imgCropKey)),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );

    setState(() {
      if (pickedFile != null) {
        contentImage = File(pickedFile.path);
        //final bytes = await pickedFile.readAsBytes();
        //TODO look into bytes instead of paths
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );

    setState(() {
      if (pickedFile != null) {
        contentImage = File(pickedFile.path);
        //final bytes = await pickedFile.readAsBytes();
        //TODO look into bytes instead of paths
      } else {
        print('No image selected.');
      }
    });
  }

  Widget settingsCard(
      BuildContext context,
      String txt1,
      String txt2,
      String description,
      bool showTopLine,
      bool showBottomLine,
      AnimationController animationController,
      Animation animation,
      {String mongoParamName = "",
      Function customfunction,
      Color txt1Color,
      List<dynamic> customFunctionParams}) {
    newInfoFocus.addListener(() {
      if (newInfoFocus.hasFocus) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (customfunction == null) {
          newInfoContr.selection = TextSelection(
            baseOffset: 0,
            extentOffset: newInfoContr.text.length,
          );
          newInfoContr.text = txt2;
          inputNewInfo(context, newInfoContr, description, txt1, newInfoFocus,
              animationController, animation,
              mongoParamName: mongoParamName);
        } else {
          customfunction(context, customFunctionParams);
        }
      },
      child: Column(
        children: [
          showTopLine
              ? Container(
                  height: 1,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .color
                      .withOpacity(.3),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                )
              : Container(),
          Padding(
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
                    color: txt1Color ?? Constants.backgroundWhite,
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
          showBottomLine
              ? Container(
                  height: 1,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .color
                      .withOpacity(.3),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                )
              : Container(),
        ],
      ),
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

deleteUserWidget(BuildContext ctx, List<dynamic> params) {
  return showModalBottomSheet<void>(
    backgroundColor: Colors.black,
    isScrollControlled: true,
    context: ctx,
    builder: (BuildContext context) {
      return Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Are you sure you delete your account?",
              style: TextStyle(
                color: Constants.backgroundWhite,
                //TO DO: Adjust color scheme of this widget
                fontSize: 18 + Constants.textChange,
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: kElevationToShadow[3],
                      color: Constants.purpleColor,
                    ),
                    child: Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: 13,
                          color: Constants.backgroundWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    clearSharedPreferences();
                    String ret = await deleteUser();
                    if (ret == "AccountDeletionSuccessful") {
                      print("SUCCESS: $ret");
                      while (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => StartPage()),
                      );
                    } else {
                      Navigator.of(context).pop();
                      showError(context, "Account deletion was unsuccessful.");
                    }
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: kElevationToShadow[3],
                      color: Constants.purpleColor,
                    ),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 13,
                          color: Constants.backgroundWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> changePassword(String newPassword) async {
  //TODO: Show error if password fails to update
  //TODO: May want to use double authentication by sending email to user first
  try {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.currentUser
        .updatePassword(newPassword)
        .catchError((e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw ErrorDescription("The password provided is too weak.");
      } else {
        print("OTHER ERROR: " + e.toString());
        throw ErrorDescription(e.code);
      }
    });
    //issue alert confirming password change
    print("Password updated successfully.");
  } catch (err) {
    print("Failed to change password: $err");
  }
}
