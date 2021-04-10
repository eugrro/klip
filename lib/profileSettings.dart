import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klip/UserPage.dart';
import 'package:klip/login/loginLogic.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

import 'CropProfilePic.dart';
import 'Requests.dart';

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
  File contentImage;
  final imgCropKey = GlobalKey<ImgCropState>();
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
                          Navigator.pop(context, SlideDownRoute(page: UserPage(currentUser.uid)));
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
                    width: 130,
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
                    radius: 65,
                    backgroundColor: Colors.transparent,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60),
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
                    child: Center(child: editingBio ? Text("Cancel", style: Constants.tStyle()) : Text("Edit Background", style: Constants.tStyle())),
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
                    child: Center(child: editingBio ? Text("Save", style: Constants.tStyle()) : Text("Edit Bio", style: Constants.tStyle())),
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

                  settingsCard(context, "First Name", currentUser.fName, "Change your first name", false, true),
                  settingsCard(context, "Last Name", currentUser.lName, "Change your last name", false, true),
                  settingsCard(context, "Email", currentUser.email, "Change your email", false, true),
                  settingsCard(context, "Username", currentUser.uName, "Change your first name", false, true),
                  settingsCard(context, "Password", "* * * * * * * *", "Request to update your password", false, false),
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
                  settingsCard(context, "Theme", "Dark", "Update your theme preference", false, true),
                  settingsCard(context, "Show Username", "Show First + Fast Name", "Change how you will be displayed on the app", false, true),
                  settingsCard(context, "Comment Color", "Purple", "Change your prefered comment color", false, true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildCropImage() {
    return Container(
      color: Colors.black,
      child: ImgCrop(
        key: imgCropKey,
        chipRadius: 150, // crop area radius
        chipShape: ChipShape.circle, // crop type "circle" or "rect"
        image: FileImage(imageFile), // you selected image file
      ),
    );
  }*/

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
                            padding: EdgeInsets.only(top: 20, right: 15, bottom: 15),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 100 * 55,
                              child: LoginTextField(
                                context,
                                50,
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
                              child: Container(
                                height: 40,
                                width: 55,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.4),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  color: Constants.purpleColor.withOpacity(.5),
                                  boxShadow: kElevationToShadow[12],
                                ),
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 30,
                                  color: Constants.backgroundWhite.withOpacity(.7),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6, left: 5),
                            child: Center(
                              child: Container(
                                height: 40,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  color: Constants.purpleColor.withOpacity(.5),
                                  boxShadow: kElevationToShadow[12],
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: Constants.backgroundWhite.withOpacity(.7),
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
                      style: Constants.tStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                              ;
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

  Widget settingsCard(BuildContext context, String txt1, String txt2, String description, bool showTopLine, bool showBottomLine) {
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
            inputNewInfo(context, newInfoContr, description, txt1, newInfoFocus);
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
