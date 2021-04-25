import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:klip/showVidPreview.dart';
import 'package:klip/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:async/async.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import './Constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:klip/currentUser.dart' as currentUser;

import 'Requests.dart';

class AddNewKlip extends StatefulWidget {
  @override
  _AddNewKlipState createState() => _AddNewKlipState();
}

//https://github.com/Lightsnap/flutter_better_camera
class _AddNewKlipState extends State<AddNewKlip> with TickerProviderStateMixin {
  File contentFile;
  String filePath;
  VideoPlayerController videoController;
  PageController pageController;
  int currentPage;
  List<AssetEntity> assetList = [];
  var xboxData;
  List<String> xboxThumbs = [];
  List<String> xboxVids = [];
  List<dynamic> currentlySelectedVideos = [];

  bool selectedXbox = false;
  bool selectedPs = false;
  bool selectedSwitch = false;

  Duration animationDuration = Duration(milliseconds: 500);
  AnimationController xboxExpandController;
  Animation<double> xboxAnimation;
  AnimationController psExpandController;
  Animation<double> psAnimation;
  AnimationController switchExpandController;
  Animation<double> switchAnimation;

  int gridLength = 0;
  int numSelected;
  final AsyncMemoizer memoizer = AsyncMemoizer();
  List<bool> tappedGallery = List.filled(999, false, growable: false);
  List<bool> tappedXbox = [];
  List<AsyncMemoizer> memList = List.generate(999, (index) => AsyncMemoizer());
  //TODO figure out how to set these lists dynamically

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    currentPage = 0;
    numSelected = 0;
    loadImageList();
    prepareAnimations();
  }

  void prepareAnimations() {
    xboxExpandController = AnimationController(vsync: this, duration: animationDuration);
    xboxAnimation = CurvedAnimation(
      parent: xboxExpandController,
      curve: Curves.fastOutSlowIn,
    );
    psExpandController = AnimationController(vsync: this, duration: animationDuration);
    psAnimation = CurvedAnimation(
      parent: psExpandController,
      curve: Curves.fastOutSlowIn,
    );
    switchExpandController = AnimationController(vsync: this, duration: animationDuration);
    switchAnimation = CurvedAnimation(
      parent: switchExpandController,
      curve: Curves.fastOutSlowIn,
    );
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
      //mainAxisSpacing: 2,
      addAutomaticKeepAlives: true,
      //crossAxisSpacing: 2,
      shrinkWrap: true,
      children: List.generate(
        gridLength,
        (int index) => GestureDetector(
          onTap: () {
            setState(() {
              if (tappedGallery[index]) {
                numSelected--;
                tappedGallery[index] = false;
                currentlySelectedVideos.remove(assetList[index]);
              } else {
                numSelected++;
                tappedGallery[index] = true;
                currentlySelectedVideos.add(assetList[index]);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: tappedGallery[index] ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
                  width: tappedGallery[index] ? 3 : 1),
            ),
            child: FutureBuilder(
              future: Future.wait([
                memoizer.runOnce(() => getAsFile(index)),
                memList[index].runOnce(() => getThumbImage(index)),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          Image.memory(
                            snapshot.data[1],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3 - 22,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7, top: 7),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                              padding: EdgeInsets.only(top: 1, bottom: 1, right: 4, left: 4),
                              child: Text(
                                vidTime(assetList[index]),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Future<File> getAsFile(int index) async {
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
    Duration time = entity.videoDuration;
    String seconds = entity.videoDuration.inSeconds.toString();
    seconds = seconds.length == 1 ? "0" + seconds : seconds;
    seconds = seconds.length > 2 ? seconds.substring(0, 2) : seconds;
    return time.inMinutes.toString() + ":" + seconds;
  }

  Future<void> loadXboxClips(String gamertag) async {
    String getVids = await getXboxClips(gamertag);
    if (getVids != null) xboxData = jsonDecode(getVids);
    //print(servRet);
    for (var clip in xboxData) {
      print(clip["thumbnails"][0]["uri"]);
      print(clip["gameClipUris"]);
      xboxThumbs.add(clip["thumbnails"][0]["uri"].toString());
      xboxVids.add(clip["gameClipUris"][0]["uri"].toString());
      tappedXbox.add(false);
      // clip["thumbnails"][1]["uri"] for high quality
    }
  }

  Widget selectFromConsole() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 50,
          ),
          AnimatedContainer(
            width: selectedXbox ? MediaQuery.of(context).size.width * .95 : MediaQuery.of(context).size.width * .9,
            decoration: BoxDecoration(
              border: Border.all(color: Constants.backgroundWhite),
              boxShadow: kElevationToShadow[4],
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            duration: animationDuration,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedXbox = !selectedXbox;
                          if (xboxAnimation.value == 0) {
                            xboxExpandController.animateTo(1);
                          } else {
                            xboxExpandController.animateTo(0);
                          }
                        });
                      },
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
                            selectedXbox ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            color: Constants.backgroundWhite,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: selectedXbox ? 5 : 0, left: 5, right: 5),
                  child: SizeTransition(
                    sizeFactor: xboxAnimation,
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      children: List.generate(
                        xboxThumbs.length,
                        (int index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (tappedXbox[index]) {
                                numSelected--;
                                tappedXbox[index] = false;
                                currentlySelectedVideos.remove(xboxVids[index]);
                              } else {
                                numSelected++;
                                tappedXbox[index] = true;
                                currentlySelectedVideos.add(xboxVids[index]);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: tappedXbox[index] ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
                                  width: tappedXbox[index] ? 3 : 1),
                            ),
                            child: Image.network(
                              xboxThumbs[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 25,
          ),
          AnimatedContainer(
            //height: 80,
            duration: animationDuration,
            width: !selectedPs ? MediaQuery.of(context).size.width * .9 : MediaQuery.of(context).size.width * .95,
            decoration: BoxDecoration(
              border: Border.all(color: Constants.backgroundWhite),
              boxShadow: kElevationToShadow[4],
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPs = !selectedPs;
                      if (psAnimation.value == 0) {
                        psExpandController.animateTo(1);
                      } else {
                        psExpandController.animateTo(0);
                      }
                    });
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            selectedPs ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            color: Constants.backgroundWhite,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: selectedPs ? 5 : 0, left: 5, right: 5),
                  child: SizeTransition(
                    sizeFactor: psAnimation,
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: List.generate(
                        15,
                        (int index) => Container(
                          height: 10,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 25,
          ),
          GestureDetector(
            onTap: () {
              showSnackbar(context, 'Nintendo feature not yet implemented');
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
      ),
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
                      Navigator.push(
                        context,
                        SlideInRoute(page: ShowVidPreview(currentlySelectedVideos), direction: 3),
                      ).then((value) {
                        for (int i = 0; i < tappedGallery.length; i++) {
                          tappedGallery[i] = false;
                        }
                        for (int i = 0; i < tappedXbox.length; i++) {
                          tappedXbox[i] = false;
                        }
                        currentlySelectedVideos = [];
                        numSelected = 0;
                      });
                    } else {
                      showSnackbar(context, 'Multiple selection posting feature not yet implemented');
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
                pageController.animateToPage(0, duration: animationDuration, curve: Curves.linear);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 50,
                child: Center(
                  child: Icon(
                    Icons.photo_size_select_actual_outlined,
                    color: currentPage == 0 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
                    size: 25,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showSnackbar(context, 'Camera feature not yet implemented');
                //pageController.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.linear);
                //TODO implement camera feature
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Center(
                  child: Icon(
                    Icons.circle,
                    color: currentPage == 1 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
                    size: 25,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                pageController.animateToPage(1, duration: animationDuration, curve: Curves.linear);
                loadXboxClips(currentUser.gamertag);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Center(
                  child: SvgPicture.asset(
                    "lib/assets/iconsUI/consoleIcon.svg",
                    semanticsLabel: 'Console Icon',
                    width: 25,
                    height: 25,
                    color: currentPage == 2 ? Constants.purpleColor : Constants.backgroundWhite.withOpacity(.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
