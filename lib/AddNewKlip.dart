import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:async/async.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import './Constants.dart' as Constants;
import 'package:intl/intl.dart';

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
  List<AssetEntity> assetList = [];

  int gridLength = 0;
  int numSelected;
  final AsyncMemoizer memoizer = AsyncMemoizer();
  List<bool> tapped = List.filled(999, false, growable: false);
  List<AsyncMemoizer> memList = List.generate(999, (index) => AsyncMemoizer());
  //TODO figure out how to set these lists dynamically

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    currentPage = 0;
    numSelected = 0;
    loadImageList();
  }

  Future<void> loadImageList() async {
    //allImageTemp = await FlutterGallaryPlugin.getAllImages;
    List<AssetPathEntity> assetPathlist = await PhotoManager.getAssetPathList(type: RequestType.video);

    for (AssetPathEntity path in assetPathlist) {
      for (AssetEntity item in await path.getAssetListRange(start: 0, end: 999)) {
        assetList.add(item);
      }
    }
    print("FOUND " + assetList.length.toString() + " videos!");
    setState(() {
      gridLength = assetList.length;
    });
  }

  Widget selectFromGallery() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      addAutomaticKeepAlives: true,
      crossAxisSpacing: 2,
      shrinkWrap: true,
      children: List.generate(
        gridLength,
        (int index) => GestureDetector(
          onTap: () {
            setState(() {
              if (tapped[index]) {
                numSelected--;
                tapped[index] = false;
              } else {
                numSelected++;
                tapped[index] = true;
              }
            });
            print("Number selected: $numSelected");
          },
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: tapped[index] ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6), width: tapped[index] ? 2 : 1),
            ),
            child: FutureBuilder(
              future: Future.wait([
                memoizer.runOnce(() => getImageAsFile(index)),
                memList[index].runOnce(() => getThumbImage(index)),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.memory(
                        snapshot.data[1],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3 - 20,
                      ),
                      /*Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3 - 20,
                        color: Colors.lightBlue,
                      ),*/
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM d').format(
                                assetList[index].modifiedDateTime,
                              ),
                              style: TextStyle(color: Constants.backgroundWhite, fontSize: 10),
                            ),
                            Text(
                              sizeOfFile(snapshot.data[0]),
                              style: TextStyle(color: Constants.backgroundWhite, fontSize: 10),
                            ),
                            Text(
                              vidTime(assetList[index]),
                              style: TextStyle(color: Constants.backgroundWhite, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.transparent,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<File> getImageAsFile(int index) async {
    return await assetList[index].file;
  }

  Future<Uint8List> getThumbImage(int index) async {
    return await assetList[index].thumbDataWithSize(
      MediaQuery.of(context).size.width ~/ 3,
      MediaQuery.of(context).size.width ~/ 3 - 20,
    );
  }

  String sizeOfFile(File f) {
    return (f.lengthSync() / 1000).round().toString() + " kB";
  }

  String vidTime(AssetEntity entity) {
    return entity.videoDuration.inMinutes.toString() + ":" + entity.videoDuration.inSeconds.toString();
  }

  Widget selectFromConsole() {
    return Column(
      children: [
        Container(
          height: 50,
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Constants.backgroundWhite.withOpacity(.9),
              content: const Text('Xbox feature not yet implemented'),
              duration: const Duration(seconds: 2),
            ));
          },
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width * .9,
            decoration: BoxDecoration(
              border: Border.all(color: Constants.backgroundWhite),
              boxShadow: kElevationToShadow[4],
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "lib/assets/iconsUI/xboxIcon.png",
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          "Xbox",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 18 + Constants.textChange,
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Constants.backgroundWhite,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 25,
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Constants.backgroundWhite.withOpacity(.9),
              content: const Text('Playstation feature not yet implemented'),
              duration: const Duration(seconds: 2),
            ));
          },
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width * .9,
            decoration: BoxDecoration(
              border: Border.all(color: Constants.backgroundWhite),
              boxShadow: kElevationToShadow[4],
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "lib/assets/iconsUI/psnIcon.png",
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                          color: Color(0xff003087),
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          "PlayStation",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 18 + Constants.textChange,
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Constants.backgroundWhite,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 25,
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Constants.backgroundWhite.withOpacity(.9),
              content: const Text('Nintendo feature not yet implemented'),
              duration: const Duration(seconds: 2),
            ));
          },
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width * .9,
            decoration: BoxDecoration(
              border: Border.all(color: Constants.backgroundWhite),
              boxShadow: kElevationToShadow[4],
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "lib/assets/iconsUI/nintendoIcon.png",
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                          color: Color(0xffC00012),
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          "Switch",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 18 + Constants.textChange,
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Constants.backgroundWhite,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Klip"),
        actions: [
          numSelected >= 1
              ? IconButton(
                  onPressed: () {
                    if (numSelected == 1) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Constants.backgroundWhite.withOpacity(.9),
                        content: const Text('Multiple selection posting feature not yet implemented'),
                        duration: const Duration(seconds: 2),
                      ));
                    }
                  },
                  icon: Icon(Icons.check),
                  color: Constants.purpleColor,
                )
              : Container(),
        ],
        centerTitle: true,
        brightness: Brightness.dark,
        //shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: PageView(
        controller: pageController,
        children: <Widget>[
          selectFromGallery(),
          //Camera(),
          selectFromConsole(),
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
            GestureDetector(
              onTap: () {
                pageController.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.linear);
              },
              child: Icon(
                Icons.photo_size_select_actual_outlined,
                color: currentPage == 0 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
                size: 25,
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Camera feature not yet implemented'),
                  duration: const Duration(seconds: 2),
                ));
                //pageController.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.linear);
                //TODO implement camera feature
              },
              child: Icon(
                Icons.circle,
                color: currentPage == 1 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
                size: 25,
              ),
            ),
            GestureDetector(
              onTap: () {
                pageController.animateToPage(1, duration: Duration(milliseconds: 250), curve: Curves.linear);
              },
              child: SvgPicture.asset(
                "lib/assets/iconsUI/consoleIcon.svg",
                semanticsLabel: 'Console Icon',
                width: 25,
                height: 25,
                color: currentPage == 2 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
