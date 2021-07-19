import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:klip/AddNewPoll.dart';
import 'package:klip/AddNewText.dart';
import 'package:klip/HomePage.dart';
import 'package:klip/SelectXboxContent.dart';
import 'package:klip/ShopPage.dart';
import 'package:klip/ProfileSettings.dart';
import 'package:klip/widgets.dart';
import 'package:path_provider/path_provider.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'AddNewImage.dart';
import 'AddNewKlip.dart';
import 'NotificationPage.dart';
import 'ShowContentPreview.dart';
import 'UserPage.dart';
import 'package:image_picker/image_picker.dart';

int homePagePosition;

PageController homePageController;
ValueNotifier<bool> showBottomNavBar = ValueNotifier(true);

class Navigation extends StatefulWidget {
  Navigation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with SingleTickerProviderStateMixin {
  bool addingNewContent = false;
  bool showNavigationIcons = true;
  int currentlySelectedPage;
  @override
  void initState() {
    super.initState();
    homePagePosition = 0;
    homePageController = PageController(initialPage: homePagePosition);
    currentlySelectedPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    Constants.statusBarHeight = MediaQuery.of(context).padding.top;
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: homePageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomePage(),
                NotificationPage(),
                ShopPage(),
                UserPage(currentUser.uid, null, false),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: showBottomNavBar,
              builder: (BuildContext context, bool showBottomNavBar, Widget child) {
                if (showBottomNavBar) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: Constants.bottomNavBarHeight,
                      width: MediaQuery.of(context).size.width,
                      color: Constants.purpleColor.withOpacity(.2),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  homePagePosition = 0;
                                  currentlySelectedPage = 0;
                                });
                                homePageController.jumpToPage(homePagePosition);
                              },
                              child: Icon(
                                Icons.home_outlined,
                                color: currentlySelectedPage == 0 ? Colors.white : Constants.backgroundWhite.withOpacity(.5),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  homePagePosition = 1;
                                  currentlySelectedPage = 1;
                                });
                                homePageController.jumpToPage(homePagePosition);
                              },
                              child: Icon(
                                Icons.announcement_outlined,
                                color: currentlySelectedPage == 1 ? Colors.white : Constants.backgroundWhite.withOpacity(.5),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _showTypePicker(context).then((value) {
                                  setState(() {});
                                });
                                setState(() {
                                  addingNewContent = !addingNewContent;
                                  showNavigationIcons = !showNavigationIcons;
                                  //currentlySelectedPage = 2;
                                });
                              },
                              child: Icon(
                                Icons.add_box_outlined,
                                color: currentlySelectedPage == 2 ? Colors.white : Constants.backgroundWhite.withOpacity(.5),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  homePagePosition = 2;
                                  currentlySelectedPage = 3;
                                });
                                homePageController.jumpToPage(homePagePosition);
                                showError(context, "In Development");
                              },
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: currentlySelectedPage == 3 ? Colors.white : Constants.backgroundWhite.withOpacity(.5),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  homePagePosition = 3;
                                  currentlySelectedPage = 4;
                                });
                                homePageController.jumpToPage(homePagePosition);
                              },
                              child: Icon(
                                Icons.person_outline_outlined,
                                color: currentlySelectedPage == 4 ? Colors.white : Constants.backgroundWhite.withOpacity(.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTypePicker(context) {
    double contentTypeHeight = 90;

    double largeText = 16 + Constants.textChange;
    double largeIcon = 35;

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isDismissible: false,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          //height: MediaQuery.of(context).size.height / 3,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    //0000000000000000000000000000000000000000000000000000000000
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.graphic_eq_rounded,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Audio",
                                style: TextStyle(
                                  fontSize: largeText,
                                  color: Constants.backgroundWhite.withOpacity(.9),
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
                        selectUploadLocation(context, "img").then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wallpaper,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Image",
                                style: TextStyle(
                                  fontSize: largeText,
                                  color: Constants.backgroundWhite.withOpacity(.9),
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
                        selectUploadLocation(context, "vid").then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videogame_asset,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Klip",
                                style: TextStyle(
                                  fontSize: largeText,
                                  color: Constants.backgroundWhite.withOpacity(.9),
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
                        Navigator.push(context, SlideInRoute(page: AddNewText(), direction: 0));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.short_text,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Text",
                                style: TextStyle(
                                  fontSize: largeText,
                                  color: Constants.backgroundWhite.withOpacity(.9),
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
                        Navigator.push(context, SlideInRoute(page: AddNewPoll(), direction: 0));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.poll,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Poll",
                                style: TextStyle(
                                  fontSize: largeText,
                                  color: Constants.backgroundWhite.withOpacity(.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        addingNewContent = !addingNewContent;
                      });
                      Navigator.of(context).pop();
                      Future.delayed(Duration(milliseconds: 150), () {
                        setState(() {
                          showNavigationIcons = !showNavigationIcons;
                        });
                      });
                    },
                    child: Container(
                      height: Constants.bottomNavBarHeight,
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3.1), // changes position of shadow
                              ),
                            ],
                            color: Constants.purpleColor.withOpacity(.9),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Constants.backgroundWhite,
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
        );
      },
    );
  }

  Future<void> selectUploadLocation(BuildContext ctx, String typeOfContent) {
    return showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(ctx).size.width * .8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constants.backgroundBlack,
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15, right: 10),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            "Select a Location",
                            style: TextStyle(color: Constants.backgroundWhite, fontSize: 18),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 20,
                            height: 30,
                            child: Text(
                              "x",
                              style: TextStyle(color: Constants.backgroundWhite, fontSize: 23),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    PickedFile pickedFile;
                    if (typeOfContent == "img")
                      pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                    else if (typeOfContent == "vid")
                      pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
                    else
                      showError(context, "Unknown content type selected");
                    if (pickedFile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowContentPreview(File(pickedFile.path), typeOfContent),
                        ),
                      ).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        setState(() {});
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Constants.purpleColor,
                      ),
                      child: Center(child: Text("Upload from Gallery")),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (typeOfContent == "vid") {
                      if (currentUser.xTag == null || currentUser.xTag == "" || currentUser.xTag == '' || currentUser.xTag.length <= 2) {
                        //Xbox gamertag not set
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettings())).then((value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() {});
                        });
                      } else {
                        //gamertag set
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SelectXboxContent(typeOfContent))).then((value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() {});
                        });
                      }
                    } else {}
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 15),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Constants.purpleColor, width: 2),
                      ),
                      child: Center(
                          child: Text(currentUser.xTag != null && currentUser.xTag != "" && currentUser.xTag != '' && currentUser.xTag.length > 2
                              ? "Upload from Xbox"
                              : "Update Xbox gamertag")),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
