import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klip/widgets.dart';

import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

class AddNewContent extends StatefulWidget {
  AddNewContent();

  @override
  _AddNewContentState createState() => _AddNewContentState();
}

class _AddNewContentState extends State<AddNewContent> {
  double contentTypeHeight = 90;

  double smallText = 13 + Constants.textChange;
  double largeText = 18 + Constants.textChange;
  double smallIcon = 20;
  double largeIcon = 40;
  double smallCircle = 15;
  double largeCircle = 25;

  int contentTypeSelected = 2;
  double circleThickness = 2;

  File contentImage;

  TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Constants.backgroundBlack,
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                ),
                Container(
                  height: 20,
                  decoration: BoxDecoration(),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "X",
                            style: TextStyle(
                              color: Colors.red[200],
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 4),
                        child: Text(
                          "Add New Content",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 16 + Constants.textChange,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 6 * 5,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 25,
                              color: Constants.purpleColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    color: Constants.purpleColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      //0000000000000000000000000000000000000000000000000000000000
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            contentTypeSelected = 0;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5 - 4,
                          height: contentTypeHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Constants.hintColor,
                                  radius: contentTypeSelected == 0
                                      ? largeCircle
                                      : smallCircle,
                                  child: CircleAvatar(
                                    backgroundColor: Constants.backgroundBlack,
                                    radius: contentTypeSelected == 0
                                        ? largeCircle - circleThickness
                                        : smallCircle - circleThickness,
                                    child: Icon(
                                      Icons.all_inclusive,
                                      color: Constants.purpleColor,
                                      size: contentTypeSelected == 0
                                          ? largeIcon
                                          : smallIcon,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "gif",
                                  style: TextStyle(
                                    fontSize: contentTypeSelected == 0
                                        ? largeText
                                        : smallText,
                                    color: Constants.backgroundWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //1111111111111111111111111111111111111111111111111111111111
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            contentTypeSelected = 1;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5 - 4,
                          height: contentTypeHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Constants.hintColor,
                                  radius: contentTypeSelected == 1
                                      ? largeCircle
                                      : smallCircle,
                                  child: CircleAvatar(
                                    backgroundColor: Constants.backgroundBlack,
                                    radius: contentTypeSelected == 1
                                        ? largeCircle - circleThickness
                                        : smallCircle - circleThickness,
                                    child: Icon(
                                      Icons.public,
                                      color: Constants.purpleColor,
                                      size: contentTypeSelected == 1
                                          ? largeIcon
                                          : smallIcon,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Image",
                                  style: TextStyle(
                                    fontSize: contentTypeSelected == 1
                                        ? largeText
                                        : smallText,
                                    color: Constants.backgroundWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //2222222222222222222222222222222222222222222222222222222222
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            contentTypeSelected = 2;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5 - 4,
                          height: contentTypeHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Constants.hintColor,
                                  radius: contentTypeSelected == 2
                                      ? largeCircle
                                      : smallCircle,
                                  child: CircleAvatar(
                                    backgroundColor: Constants.backgroundBlack,
                                    radius: contentTypeSelected == 2
                                        ? largeCircle - circleThickness
                                        : smallCircle - circleThickness,
                                    child: Icon(
                                      Icons.videogame_asset,
                                      color: Constants.purpleColor,
                                      size: contentTypeSelected == 2
                                          ? largeIcon
                                          : smallIcon,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "klip",
                                  style: TextStyle(
                                    fontSize: contentTypeSelected == 2
                                        ? largeText
                                        : smallText,
                                    color: Constants.backgroundWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //3333333333333333333333333333333333333333333333333333333333
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            contentTypeSelected = 3;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5 - 4,
                          height: contentTypeHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Constants.hintColor,
                                  radius: contentTypeSelected == 3
                                      ? largeCircle
                                      : smallCircle,
                                  child: CircleAvatar(
                                    backgroundColor: Constants.backgroundBlack,
                                    radius: contentTypeSelected == 3
                                        ? largeCircle - circleThickness
                                        : smallCircle - circleThickness,
                                    child: Icon(
                                      Icons.short_text,
                                      color: Constants.purpleColor,
                                      size: contentTypeSelected == 3
                                          ? largeIcon
                                          : smallIcon,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Text",
                                  style: TextStyle(
                                    fontSize: contentTypeSelected == 3
                                        ? largeText
                                        : smallText,
                                    color: Constants.backgroundWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //4444444444444444444444444444444444444444444444444444444444
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            contentTypeSelected = 5;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5 - 4,
                          height: contentTypeHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Constants.hintColor,
                                  radius: contentTypeSelected == 5
                                      ? largeCircle
                                      : smallCircle,
                                  child: CircleAvatar(
                                    backgroundColor: Constants.backgroundBlack,
                                    radius: contentTypeSelected == 5
                                        ? largeCircle - circleThickness
                                        : smallCircle - circleThickness,
                                    child: Icon(
                                      Icons.poll,
                                      color: Constants.purpleColor,
                                      size: contentTypeSelected == 5
                                          ? largeIcon
                                          : smallIcon,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Poll",
                                  style: TextStyle(
                                    fontSize: contentTypeSelected == 5
                                        ? largeText
                                        : smallText,
                                    color: Constants.backgroundWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    height: .5,
                    color: Constants.hintColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 10,
                    bottom: 20,
                  ),
                  child: Text(
                    "Upload Your Klip",
                    style: TextStyle(
                        fontSize: 14 + Constants.textChange,
                        color: Constants.backgroundWhite),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        print("TAPPED RECORD");
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.phone_iphone,
                            color: Constants.backgroundWhite,
                            size: 50,
                          ),
                          Text(
                            "Record",
                            style: TextStyle(
                              fontSize: 14 + Constants.textChange,
                              color: Constants.backgroundWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        print("TAPPED CONSOLE");
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.tv,
                            color: Constants.backgroundWhite,
                            size: 50,
                          ),
                          Text(
                            "Console",
                            style: TextStyle(
                              fontSize: 14 + Constants.textChange,
                              color: Constants.backgroundWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.collections,
                            color: Constants.backgroundWhite,
                            size: 50,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(
                              fontSize: 14 + Constants.textChange,
                              color: Constants.backgroundWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                /*Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .6,
                      height: 200,
                      color: Colors.grey,
                      child: Center(child: Text("PREVIEW OF CONTENT")),
                    ),
                  ),*/
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: .5,
                      color: Constants.hintColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    bottom: 20,
                  ),
                  child: Text(
                    "Title",
                    style: TextStyle(
                        fontSize: 14 + Constants.textChange,
                        color: Constants.backgroundWhite),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .1,
                  ),
                  child: klipTextField(
                    100,
                    MediaQuery.of(context).size.width * .8,
                    titleController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: .5,
                      color: Constants.hintColor,
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
                      onTap: () async {
                        await getImageCamera();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await getImageGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
    var pickedFile;
    pickedFile = await picker
        .getImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    )
        .then((value) {
      setState(() {
        if (pickedFile != null) {
          contentImage = File(pickedFile.path);
          //final bytes = await pickedFile.readAsBytes();
          //TODO look into bytes instead of paths
        } else {
          print('No image selected.');
        }
      });
    });
  }
}
