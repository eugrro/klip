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

  Widget _buildGrid() {
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
                        content: const Text('Multiple selection posting feature not yet implemented '),
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
          _buildGrid(),

          //selectFromGallery(),
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
}
