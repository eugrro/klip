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

import 'profileSettings.dart';

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
    double iconSizeSmall = 24;
    double iconSizeLarge = 28;
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
                UserPage(currentUser.uid, null, false, false),
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
                      decoration: BoxDecoration(
                        color: Constants.theme.background,
                        border: Border(
                          top: BorderSide(width: 1.0, color: Constants.theme.hintColor),
                        ),
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: Icon(
                                Icons.home_outlined,
                                size: currentlySelectedPage == 0 ? iconSizeLarge : iconSizeSmall,
                                color: currentlySelectedPage == 0 ? Constants.theme.foreground : Constants.theme.foreground.withOpacity(.7),
                              ),
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: Icon(
                                Icons.announcement_outlined,
                                size: currentlySelectedPage == 1 ? iconSizeLarge : iconSizeSmall,
                                color: currentlySelectedPage == 1 ? Constants.theme.foreground : Constants.theme.foreground.withOpacity(.7),
                              ),
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: Icon(
                                Icons.add_box_outlined,
                                size: currentlySelectedPage == 2 ? iconSizeLarge : iconSizeSmall,
                                color: currentlySelectedPage == 2 ? Constants.theme.foreground : Constants.theme.foreground.withOpacity(.7),
                              ),
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                size: currentlySelectedPage == 3 ? iconSizeLarge : iconSizeSmall,
                                color: currentlySelectedPage == 3 ? Constants.theme.foreground : Constants.theme.foreground.withOpacity(.7),
                              ),
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: Icon(
                                Icons.person_outline_outlined,
                                size: currentlySelectedPage == 4 ? iconSizeLarge : iconSizeSmall,
                                color: currentlySelectedPage == 4 ? Constants.theme.foreground : Constants.theme.foreground.withOpacity(.7),
                              ),
                            ),
                          ),
                        ],
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
      backgroundColor: Constants.theme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .25,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(-1, 0),
                  child: GestureDetector(
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
                                color: Constants.theme.foreground.withOpacity(.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-.5, -.5),
                  child: GestureDetector(
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
                            Icons.crop_original,
                            color: Constants.purpleColor,
                            size: largeIcon,
                          ),
                          Container(
                            child: Text(
                              "Image",
                              style: TextStyle(
                                fontSize: largeText,
                                color: Constants.theme.foreground.withOpacity(.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -.8),
                  child: GestureDetector(
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
                                color: Constants.theme.foreground.withOpacity(.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(.5, -.5),
                  child: GestureDetector(
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
                            Icons.subject,
                            color: Constants.purpleColor,
                            size: largeIcon,
                          ),
                          Container(
                            child: Text(
                              "Text",
                              style: TextStyle(
                                fontSize: largeText,
                                color: Constants.theme.foreground.withOpacity(.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(1, 0),
                  child: GestureDetector(
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
                                color: Constants.theme.foreground.withOpacity(.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                          width: MediaQuery.of(context).size.width / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Constants.purpleColor.withOpacity(.9),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: Constants.theme.foreground,
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
              color: Constants.theme.background,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15, right: 10),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            "Select a Location",
                            style: TextStyle(color: Constants.theme.foreground, fontSize: 18),
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
                              style: TextStyle(color: Constants.theme.foreground, fontSize: 23),
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
