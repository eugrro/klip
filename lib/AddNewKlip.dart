import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import './Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:video_player/video_player.dart';

import 'Requests.dart';

class AddNewKlip extends StatefulWidget {
  @override
  _AddNewKlipState createState() => _AddNewKlipState();
}

class _AddNewKlipState extends State<AddNewKlip> {
  File contentFile;
  String filePath;
  VideoPlayerController videoController;

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
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
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
                                "Add New Klip",
                                style: TextStyle(
                                    color: Constants.backgroundWhite,
                                    fontSize: 18 + Constants.textChange),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              uploadKlip(filePath, currentUser.uid);
                            },
                            child: Icon(
                              Icons.check,
                              color: Constants.backgroundWhite,
                              size: 25,
                            ),
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
                          //uploadImage(
                          //    await getImageFromGallery(), currentUser.uid);
                          getKlipGallery();
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
                if (contentFile != null)
                  videoController.value.initialized
                      ? AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        )
                      : Container()
                else
                  RaisedButton(
                    onPressed: () {
                      getKlipGallery();
                    },
                    child: Text("Pick Video From Gallery"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  Future getKlipCamera() async {
    final pickedFile = await picker.getVideo(
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

  Future getKlipGallery() async {
    picker
        .getVideo(
      source: ImageSource.gallery,
      //preferredCameraDevice: CameraDevice.rear,
    )
        .then((pickedFile) async {
      if (pickedFile != null) {
        print("PATH: " + pickedFile.path);
        print("FILENAME: " + pickedFile.path.split('/').last);

        print('Type of File: ' + (pickedFile.path.split('.').last));

        setState(() {
          filePath = pickedFile.path;
          contentFile = File(pickedFile.path);
          videoController = VideoPlayerController.file(contentFile)
            ..initialize().then((_) {
              setState(() {});
              videoController.play();
            });
          print('Klip selected.');

          //final bytes = await pickedFile.readAsBytes();
          //TODO look into bytes instead of paths
        });
        print("Klip File Size: " + (await contentFile.length()).toString());
      } else {
        print('No Klip selected.');
      }
    });
  }
}
