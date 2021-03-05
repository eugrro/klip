import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klip/widgets.dart';

import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

import 'Requests.dart';

class AddNewContent extends StatefulWidget {
  AddNewContent();

  @override
  _AddNewContentState createState() => _AddNewContentState();
}

class _AddNewContentState extends State<AddNewContent> {
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
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
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
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    color: Constants.purpleColor,
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
                    style: TextStyle(fontSize: 14 + Constants.textChange, color: Constants.backgroundWhite),
                  ),
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
                    style: TextStyle(fontSize: 14 + Constants.textChange, color: Constants.backgroundWhite),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        print("TRYING TO TEST NODE CONNECTION");
                        testConnection();
                      },
                      child: Text("Test Connection"),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        print("TRYING TO UPLOAD PHOTO");
                        uploadImage(
                          await getImageFromGallery(),
                          currentUser.uid,
                        );
                      },
                      child: Text("Upload Image"),
                    ),
                  ],
                ),
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
