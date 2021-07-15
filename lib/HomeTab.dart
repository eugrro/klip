import 'package:flutter/material.dart';
//import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:klip/HomeSideScrolling.dart';
import 'package:klip/Requests.dart';
import './Constants.dart' as Constants;
import 'package:async/async.dart';
import 'package:preload_page_view/preload_page_view.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
//import 'package:flutter_native_admob/native_admob_controller.dart';

import 'Navigation.dart';

// ignore: must_be_immutable
class HomeTab extends StatefulWidget {
  int homePageSideScrollPosition;
  Function(int) callback;
  HomeTab(this.homePageSideScrollPosition, this.callback);
  _HomeTabState createState() => _HomeTabState(homePageSideScrollPosition, callback);
}

class _HomeTabState extends State<HomeTab> {
  final AsyncMemoizer memoizer = AsyncMemoizer();

  int homePageSideScrollPosition;
  Function(int) callback;
  _HomeTabState(this.homePageSideScrollPosition, this.callback);

  //final adController = NativeAdmobController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: memoizer.runOnce(() => listContentMongo()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Build the widget with data.
                print("Home Page Displayed");
                return Center(
                  child: ValueListenableBuilder(
                    valueListenable: showBottomNavBar,
                    builder: (BuildContext context, bool showBottomNavBar, Widget child) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: showBottomNavBar ? Constants.bottomNavBarHeight : 0,
                        ),
                        child: buildContent(List.from(snapshot.data.reversed)),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildContent(dynamic jsonInput) {
    try {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: PreloadPageView.builder(
          preloadPagesCount: 3,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            if (position < jsonInput.length) {
              //if (position % 2 == 1) {
              return HomeSideScrolling(homePageSideScrollPosition, callback, jsonInput[position]);
              /*} else {
                return NativeAdmob(
                  adUnitID: "ca-app-pub-3940256099942544/2247696110",
                  loading: Center(child: CircularProgressIndicator()),
                  error: Text("Failed to load the ad"),
                  controller: adController,
                  type: NativeAdmobType.full,
                  options: NativeAdmobOptions(
                    ratingColor: Colors.red,
                    // Others ...
                  ),
                );
              }*/
            } else {
              return Center(
                child: Text(
                  "No More Content",
                  style: TextStyle(
                    color: Constants.backgroundWhite,
                    fontSize: 20 + Constants.textChange,
                  ),
                ),
              );
            }
          },
        ),
      );
    } catch (e) {
      throw "Error on parsing content data: " + e.toString();
    }
  }
}
