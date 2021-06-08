import 'dart:io';
import 'package:flutter/material.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/Requests.dart';
import '../Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:image_picker/image_picker.dart';
import '../CropProfilePic.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AvatarCreation extends StatefulWidget {
  @override
  _AvatarCreationState createState() => _AvatarCreationState();
}

class _AvatarCreationState extends State<AvatarCreation> {
  File contentImage;
  File tmpAvatar3;
  int currentFileIndex = 0;
  bool hasImageFiles = false;
  final tmpAvatar = File('lib/assets/images/tempAvatar.png');
  File tmpAvatar2 = File('lib/assets/images/personOutline.png');
  List<File> imageFiles = [];

  final imgCropKey = GlobalKey<ImgCropState>();
  @override
  void initState() {
    initFiles();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('lib/assets/images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future initFiles() async {
    imageFiles.add(await (getImageFileFromAssets('tempAvatar.png')));
    imageFiles.add(await (getImageFileFromAssets('personOutline.png')));
    setState(() {
      hasImageFiles = true;
    });
    print(imageFiles.length);
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
                      colors: [
                        Theme.of(context).textSelectionTheme.cursorColor,
                        Theme.of(context).textSelectionTheme.cursorColor.withOpacity(.6),
                        Theme.of(context).textSelectionTheme.cursorColor.withOpacity(.1),
                        Colors.transparent
                      ],
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
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20)),
                    Text("Choose A Avatar",
                        overflow: TextOverflow.visible, style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 32 + Constants.textChange)),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 80)),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async => {
                        _showPicker(context),
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .8,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Theme.of(context).textSelectionTheme.cursorColor, Color(0xffab57a8)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Select your own",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 24 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: .3,
                          width: MediaQuery.of(context).size.width * .3,
                          color: Theme.of(context).textSelectionTheme.cursorColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "or",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 16 + Constants.textChange,
                            ),
                          ),
                        ),
                        Container(
                          height: .3,
                          width: MediaQuery.of(context).size.width * .3,
                          color: Theme.of(context).textSelectionTheme.cursorColor,
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 40)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        //alignment: Alignment.center,
                        children: [
                          Container(
                              child: IconButton(
                            onPressed: () {
                              setState(() {
                                currentFileIndex = (currentFileIndex + 1) % imageFiles.length;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_left_outlined,
                              color: Theme.of(context).textSelectionTheme.cursorColor,
                            ),
                            iconSize: MediaQuery.of(context).size.width / 5,
                          )),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async => {
                                    _showPicker(context),
                                  },
                              child: Stack(children: [
                                CircleAvatar(
                                    radius: (MediaQuery.of(context).size.width / 4),
                                    child: Stack(children: [
                                      ClipOval(
                                          child: Align(
                                              child: Stack(children: <Widget>[
                                        Opacity(
                                          opacity: 1,
                                          child: hasImageFiles ? Container(child: Image.file(imageFiles[currentFileIndex])) : null,
                                        ),
                                      ]))),
                                    ])),
                              ])),
                          Container(
                              child: IconButton(
                            onPressed: () {
                              setState(() {
                                currentFileIndex = (currentFileIndex - 1) % imageFiles.length;
                              });
                            },
                            icon: Icon(Icons.arrow_right_outlined, color: Theme.of(context).textSelectionTheme.cursorColor),
                            iconSize: MediaQuery.of(context).size.width / 5,
                          )),
                          // Align(
                          //alignment: Alignment.bottomRight,
                          //
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
                    ),
                    GestureDetector(
                      onTap: () async {
                        updateAvatar(imageFiles[currentFileIndex].path, currentUser.uid);
                        Image newImg = Image.file(imageFiles[currentFileIndex]);
                        setState(() {
                          currentUser.userProfileImg = Future.delayed(Duration(seconds: 0), () {
                            return newImg;
                          });
                          ;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Theme.of(context).textSelectionTheme.cursorColor, Color(0xffab57a8)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 24 + Constants.textChange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])))
            ]))));
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
                      if (contentImage == null)
                        Navigator.of(context).pop();
                      else {
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
                              //updateAvatar(newFile.path, currentUser.uid);
                              setState(() {
                                imageFiles.add(newFile);
                                currentFileIndex = imageFiles.length - 1;
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      }

                      // show you croppedFile ……
                      //showImage(context, croppedFile);
                    });
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    getImageCamera().then((value) async {
                      if (contentImage == null)
                        Navigator.of(context).pop();
                      else {
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
                              //updateAvatar(newFile.path, currentUser.uid);
                              setState(() {
                                imageFiles.add(newFile);
                                currentFileIndex = imageFiles.length - 1;
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      }

                      // show you croppedFile ……
                      //showImage(context, croppedFile);
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
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        contentImage = File(pickedFile.path);
        //final bytes = await pickedFile.readAsBytes();
        //TODO look into bytes instead of paths
      } else {
        contentImage = null;
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
        contentImage = null;
        print('No image selected.');
      }
    });
  }
}
