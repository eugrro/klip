import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:path_provider/path_provider.dart';
import './Constants.dart' as Constants;
import 'package:klip/widgets.dart';

import 'Requests.dart';
import 'ShowContentPreview.dart';

// ignore: must_be_immutable
class SelectXboxContent extends StatefulWidget {
  String typeOfContent;
  SelectXboxContent(this.typeOfContent);
  @override
  _SelectXboxContentState createState() => _SelectXboxContentState(typeOfContent);
}

class _SelectXboxContentState extends State<SelectXboxContent> with SingleTickerProviderStateMixin {
  String typeOfContent;
  _SelectXboxContentState(this.typeOfContent);
  final AsyncMemoizer memoizer = AsyncMemoizer();
  var xboxData;
  List<String> xboxThumbs = [];
  List<String> xboxVids = [];
  List<bool> selectedContent = [];
  int downloadingContentPercent = -1;
  int indexSelected = -1;
  //Animation sizeAnimation;

  @override
  void initState() {
    super.initState();

    //AnimationController _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));

    //sizeAnimation = Tween<double>(begin: 140.0, end: 200.0).animate(_animationController);
    //_animationController.repeat(
    //  reverse: true,
    //);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<String>> loadXboxClips(String gamertag) async {
    if (gamertag == null || gamertag == "") return [""];
    List<dynamic> vidsList = await getXboxClips(gamertag);

    //print(servRet);
    for (var clip in vidsList) {
      print(clip["thumbnails"][0]["uri"]);
      print(clip["gameClipUris"]);
      xboxThumbs.add(clip["thumbnails"][0]["uri"].toString());
      xboxVids.add(clip["gameClipUris"][0]["uri"].toString());
      //tappedXbox.add(false);
      // clip["thumbnails"][1]["uri"] for high quality
    }
    selectedContent = List.filled(xboxVids.length, false);
    return xboxThumbs;
    //loadedKlips = true;
  }

  Future<dynamic> _saveVideo(String uri) async {
    print("Downloading Xbox Content");
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.mp4";
    await Dio().download(uri, savePath, onReceiveProgress: (rec, total) {
      setState(() {
        downloadingContentPercent = (rec / total * 100).round();
      });
    });
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
    return result;
  }

  Widget nothingFoundWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              "lib/assets/iconsUI/nothingFoundIcon.png",
              width: 180,
              height: 180,
              color: Colors.white,
              fit: BoxFit.fill,
            ),
            Text(
              "Nothing found for user:\n" + currentUser.xTag,
              style: TextStyle(color: Constants.hintColor, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).padding.top + 15, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Constants.backgroundWhite,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Select Xbox Content",
                      style: TextStyle(
                        color: Constants.backgroundWhite,
                        fontSize: 18 + Constants.textChange,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isOneSelected() && indexSelected != -1) {
                          await _saveVideo(xboxVids[indexSelected]).then((file) {
                            //{filePath: file:///******.mp4, errorMessage: null, isSuccess: true}
                            if (file["isSuccess"]) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowContentPreview(File(file["filePath"]), typeOfContent),
                                ),
                              ).then((value) {
                                Navigator.pop(context);
                                setState(() {});
                              });
                            } else {
                              Navigator.pop(context);
                              setState(() {});
                              showError(context, file["errorMessage"]);
                            }
                          });
                        } else {
                          showError(context, "No content selected");
                        }
                      },
                      child: downloadingContentPercent != -1
                          ? Text(
                              downloadingContentPercent.toString() + "%",
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                              ),
                            )
                          : Icon(
                              Icons.check,
                              color: Constants.backgroundWhite,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: memoizer.runOnce(() => loadXboxClips(currentUser.xTag)),
                builder: (context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.hasData) {
                    if (xboxThumbs.length > 1) {
                      return GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: List.generate(
                          xboxThumbs.length,
                          (int index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedContent[index]) {
                                  selectedContent[index] = false;
                                  indexSelected = -1;
                                } else {
                                  clearSelected(); //Remove when multiple uploads allowed
                                  selectedContent[index] = true;
                                  indexSelected = index;
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedContent[index] ? Colors.blue : Colors.transparent, width: selectedContent[index] ? 2 : 0),
                              ),
                              child: Image.network(
                                xboxThumbs[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return nothingFoundWidget();
                    }
                  } else {
                    return nothingFoundWidget();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearSelected() {
    for (int i = 0; i < selectedContent.length; i++) {
      selectedContent[i] = false;
    }
  }

  bool isOneSelected() {
    for (int i = 0; i < selectedContent.length; i++) {
      if (selectedContent[i] == true) return true;
    }
    return false;
  }
}
