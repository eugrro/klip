import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:klip/widgets.dart';
import 'Requests.dart';

class AddNewImage extends StatefulWidget {
  @override
  _AddNewImageState createState() => _AddNewImageState();
}

class _AddNewImageState extends State<AddNewImage> {
  File contentFile;
  Image contentImage;

  @override
  void initState() {
    super.initState();
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
              children: [
                Container(
                  decoration: BoxDecoration(
                    // border:
                    //borderRadius: BorderRadius.circular(8.0),
                    color: Constants.backgroundBlack,
                    boxShadow: [
                      BoxShadow(
                        //color: Constants.backgroundBlack,
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
                                color: Constants.backgroundWhite,
                                size: 20,
                              ),
                              Container(
                                width: 20,
                              ),
                              Text(
                                "Add New Image",
                                style: TextStyle(color: Constants.backgroundWhite, fontSize: 18 + Constants.textChange),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.check,
                            color: Constants.backgroundWhite,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
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
                        onTap: () async {
                          //_showPicker(context);
                          //temporary to remove
                          uploadImage(await getImageFromGallery(), currentUser.uid, "");
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
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 10,
                  ),
                  child: Center(
                    child: Container(
                      color: Constants.purpleColor,
                      height: 2,
                      width: MediaQuery.of(context).size.width * .9,
                    ),
                  ),
                ),
                contentImage != null ? contentImage : Container()
              ],
            ),
          ),
        ),
      ),
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
        contentFile = File(pickedFile.path);
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
      //preferredCameraDevice: CameraDevice.rear,
    )
        .then((value) {
      setState(() {
        if (pickedFile != null) {
          contentFile = File(pickedFile.path);
          contentImage = Image.file(contentFile);
          print('Image selected.');
          //final bytes = await pickedFile.readAsBytes();
          //TODO look into bytes instead of paths
        } else {
          print('No image selected.');
        }
      });
    });
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
                      await getImageGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () async {
                    await getImageCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
