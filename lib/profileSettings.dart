import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klip/UserPage.dart';
import 'package:klip/login/StartPage.dart';
import 'package:klip/login/loginLogic.dart';
import 'package:klip/widgets.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'CropProfilePic.dart';
import 'Requests.dart';
import 'currentUser.dart';

class ProfileSettings extends StatefulWidget {
  ProfileSettings();

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  TextEditingController bioContr;
  TextEditingController bioLinkContr;
  TextEditingController fNameController;
  TextEditingController lNameController;
  TextEditingController xTagController;
  TextEditingController emailController;
  TextEditingController uNameController;
  TextEditingController psswdController;

  var newInfoFocus = new FocusNode();
  var biofcs = new FocusNode();
  bool editingBio = false;
  File contentImage;
  final imgCropKey = GlobalKey<ImgCropState>();
  @override
  void initState() {
    bioContr = TextEditingController(text: currentUser.bio);
    bioLinkContr = TextEditingController();
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    xTagController = TextEditingController();
    emailController = TextEditingController();
    uNameController = TextEditingController();
    psswdController = TextEditingController();
    super.initState();

    bool opened = false;
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        opened = true;
      }
      if (opened && !visible) {
        updateData();
        opened = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        print("Tapped");
      },
      child: Scaffold(
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
                          future: currentUser.userProfileImg, // a previously-obtained Future<String> or null
                          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
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
                              color: Constants.backgroundWhite.withOpacity(.7),
                              fontSize: 13 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              editingBio
                  ? Padding(
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
                    )
                  : Container(
                      height: 30,
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
                      } else if (currentUser.bioLink != null && currentUser.bioLink != "") {
                        bioLinkContr.text = currentUser.bioLink.substring(0, 7) == "http://"
                            ? currentUser.bioLink.substring(7)
                            : currentUser.bioLink.substring(0, 8) == "https://"
                                ? currentUser.bioLink.substring(8)
                                : currentUser.bioLink;
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
                            : currentUser.bioLink != null && currentUser.bioLink != ""
                                ? Text(
                                    "Edit Link",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Constants.backgroundWhite,
                                    ),
                                  )
                                : Text(
                                    "Add A Link",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Constants.backgroundWhite,
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

                    settingsCard(context, "First Name", currentUser.fName, false, true, ctrl: fNameController),
                    settingsCard(context, "Last Name", currentUser.lName, false, true, ctrl: lNameController),
                    settingsCard(context, "Xbox Gamertag", currentUser.xTag, false, true, ctrl: xTagController),
                    settingsCard(context, "Email", currentUser.email, false, true, ctrl: emailController),
                    settingsCard(context, "Username", currentUser.uName, false, true, ctrl: uNameController),
                    settingsCard(context, "Password", "* * * * * * * *", false, false, ctrl: psswdController),

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
                    settingsCard(context, "Theme", "Dark", false, true),
                    settingsCard(context, "Show Username", "username", false, true),
                    settingsCard(context, "Comment Color", "Purple", false, false),
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
                    settingsCard(context, "Report A Bug", "", false, true,
                        txt1Color: Colors.blue[700], customFunction: reportABug, customFunctionParams: newInfoFocus),
                    settingsCard(context, "Sign out", "", false, true, customFunction: signOutUserWidget),
                    settingsCard(context, "Delete Your Account", "", false, false, txt1Color: Colors.redAccent),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: .5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.backgroundWhite.withOpacity(.8), width: 1.5),
                      ),
                      hintText: 'Ex: youtube.com',
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
                        //fix and update formatting of link
                        if (bioLinkContr.text.substring(0, 7) != "http://" && bioLinkContr.text.substring(0, 8) != "https://") {
                          bioLinkContr.text = "http://" + bioLinkContr.text;
                        }
                        updateOne(uid, "bioLink", bioLinkContr.text);
                        currentUser.setFieldInSharedPreferences("bioLink", bioLinkContr.text);
                        Navigator.of(context).pop();
                        currentUser.bioLink = bioLinkContr.text;
                      },
                      child: Center(
                        child: Text(
                          currentUser.bioLink != "" && currentUser.bioLink != null ? "Update" : "Add",
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

  signOutUserWidget(BuildContext ctx, dynamic param) {
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
                        showError(context, "Sign out was unsuccessful please report this bug");
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

  reportABug(BuildContext ctx, dynamic params) {
    FocusNode fcs = params;
    fcs.requestFocus();
    TextEditingController bugController = TextEditingController();
    showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constants.backgroundBlack,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 15),
                          child: Text(
                            "x",
                            style: TextStyle(
                              color: Constants.backgroundWhite,
                              fontSize: 14 + Constants.textChange,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    child: Material(
                      child: TextField(
                        maxLines: 6,
                        controller: bugController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: .5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants.backgroundWhite.withOpacity(.8), width: 1.5),
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
                          padding: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .4 - 15,
                                  height: 30,
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
                                    reportBug(currentUser.uid, bugController.text);
                                    Navigator.of(context).pop();
                                    showSnackbar(context, "Thank you for reporting and improving\nthe app experience");
                                  } else {
                                    Navigator.of(context).pop();
                                    showError(context, "Bug Report must have at least 20 characters");
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .4 - 15,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Constants.backgroundWhite,
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
          ),
        );
      },
    );
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
                          builder: (context) => CropProfilePic(contentImage, imgCropKey),
                        ),
                      ).then(
                        (value) async {
                          if (value) {
                            final crop = imgCropKey.currentState;
                            File newFile = await crop.cropCompleted(contentImage, preferredSize: 600);
                            Image newImg = Image.file(newFile);
                            updateAvatar(newFile.path, currentUser.uid);
                            setState(() {
                              //little bit of a hacky way but this needs to return a future
                              currentUser.userProfileImg = Future.delayed(Duration(seconds: 0), () {
                                return newImg;
                              });
                            });
                            Navigator.of(context).pop();
                          }
                        },
                      );

                      // show you croppedFile ……
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
                        MaterialPageRoute(builder: (context) => CropProfilePic(contentImage, imgCropKey)),
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

  Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  void updateData() {
    print("RAN FUNCTION");

    if (currentUser.fName != fNameController.text) {
      currentUser.fName = fNameController.text;
      updateOne(uid, "fName", fNameController.text);
      setFieldInSharedPreferences("fName", fNameController.text);
    } else if (currentUser.lName != lNameController.text) {
      currentUser.lName = lNameController.text;
      updateOne(uid, "lName", lNameController.text);
      setFieldInSharedPreferences("lName", lNameController.text);
    } else if (currentUser.xTag != xTagController.text) {
      currentUser.xTag = xTagController.text;
      updateOne(uid, "xTag", xTagController.text);
      setFieldInSharedPreferences("xTag", xTagController.text);
    } else if (currentUser.email != emailController.text) {
      currentUser.email = emailController.text;
      updateOne(uid, "email", emailController.text);
      setFieldInSharedPreferences("email", emailController.text);
    } else if (currentUser.uName != uNameController.text) {
      currentUser.uName = uNameController.text;
      updateOne(uid, "uName", uNameController.text);
      setFieldInSharedPreferences("uName", uNameController.text);
    }
  }

  Widget settingsCard(BuildContext context, String txt1, String txt2, bool showTopLine, bool showBottomLine,
      {Color txt1Color, TextEditingController ctrl, Function customFunction, dynamic customFunctionParams}) {
    if (ctrl != null) {
      ctrl.text = txt2;
      ctrl.addListener(() {
        if (ctrl.text.length != ctrl.text.trim().length) {
          ctrl.text = ctrl.text.trim();
        }
        ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
      });
    }
    if (customFunction != null) {}
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (customFunction != null) {
          customFunction(context, customFunctionParams);
        }
      },
      child: Column(
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
                ctrl == null
                    ? Text(
                        txt2,
                        style: TextStyle(
                          color: txt1Color ?? Constants.backgroundWhite,
                          fontSize: 14 + Constants.textChange,
                        ),
                      )
                    : txt2 != ""
                        ? Container(
                            width: 200,
                            child: TextField(
                              style: TextStyle(color: Constants.backgroundWhite, fontSize: 14 + Constants.textChange),
                              controller: ctrl,
                              autocorrect: false,
                              scrollPadding: EdgeInsets.zero,
                              textAlign: TextAlign.end,
                              /* onTap: () {
                              if (isFirstOpen) {
                                settingsParamController.text = settingsParamController.text.substring(1) + settingsParamController.text[0];
                                settingsParamController.selection = TextSelection.fromPosition(TextPosition(offset: settingsParamController.text.length));
                                isFirstOpen = false;
                              }
                            },*/
                              onChanged: (val) {
                                print("Controller Value: " + ctrl.text);
                                ctrl.selection = TextSelection.fromPosition(TextPosition(offset: ctrl.text.length));
                              },
                              onEditingComplete: () {
                                updateData();
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        : Container(),
              ],
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
