import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

//https://github.com/Lightsnap/flutter_better_camera
class _AddNewKlipState extends State<AddNewKlip> {
  File contentFile;
  String filePath;
  VideoPlayerController videoController;
  PageController pageController;
  int currentPage;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Klip"),
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: PageView(
        controller: pageController,
        children: <Widget>[
          selectFromGallery(),
          //Camera(),
          //Console(),
        ],
        onPageChanged: (page) {
          setState(() {
            currentPage = page;
          });
        },
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Constants.purpleColor.withOpacity(.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.photo_size_select_actual_outlined,
              color: currentPage == 0 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
              size: 25,
            ),
            Icon(
              Icons.circle,
              color: currentPage == 1 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
              size: 25,
            ),
            SvgPicture.asset(
              "lib/assets/iconsUI/consoleIcon.svg",
              semanticsLabel: 'Console Icon',
              width: 25,
              height: 25,
              color: currentPage == 2 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectFromGallery() {
    return FutureBuilder<Directory>(
      future: getApplicationDocumentsDirectory(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          final myDir = new Directory(snapshot.data.toString());
          print(myDir);
          List<FileSystemEntity> _images;
          _images = myDir.listSync(recursive: true, followLinks: false);
          print(_images);
        } else if (snapshot.hasError) {
          print("RAN INTO ERROR ON GETTING FILE DIRECTORY");
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
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
