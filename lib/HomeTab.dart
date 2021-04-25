
import 'package:flutter/material.dart';
import 'package:klip/HomeSideScrolling.dart';
import 'package:klip/Requests.dart';
import './Constants.dart' as Constants;
import 'package:async/async.dart';


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
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.bottomNavBarHeight,
                    ),
                    child: buildContent(snapshot.data),
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
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            if (position < jsonInput.length) {
              return HomeSideScrolling(homePageSideScrollPosition, callback, jsonInput[position]);
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
