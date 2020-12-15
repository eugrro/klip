import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:klip/Requests.dart';
import 'package:klip/commentsPage.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:klip/widgets.dart';
import 'dart:convert' as convert;
import './Constants.dart' as Constants;
import 'package:async/async.dart';

//import 'Vid.dart';

class HomeTab extends StatefulWidget {
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final AsyncMemoizer memoizer = AsyncMemoizer();

  bool showComments = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: memoizer.runOnce(() => getListOfContent()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Build the widget with data.
                print("Home Page Displayed");
                return Center(
                  child: buildContent(snapshot.data),
                );
              } else {
                return SizedBox.shrink(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildContent(String jsonInput) {
    TextStyle ts = TextStyle(
        color: Constants.backgroundWhite, fontSize: 14 + Constants.textChange);
    try {
      var obj = json.decode(jsonInput);
      print(obj);
      return Container(
        width: MediaQuery.of(context).size.width,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            if (position < obj.length) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  NetworkImage(obj[position]["avatar"]),
                            ),
                          ),
                          Text(
                            obj[position]["uname"],
                            style: TextStyle(
                              color: Constants.backgroundWhite,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10,
                        ),
                        child: Container(
                          width: 65,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Constants.purpleColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              "Follow +",
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 10 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 5,
                  ),
                  /*Container(
                      height: 1,
                      color: Constants.purpleColor,
                    ),*/
                  Image.network(obj[position]["link"]),
                  /*Container(
                      height: 1,
                      color: Constants.purpleColor,
                    ),*/
                  Container(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "+1",
                        style: TextStyle(
                          fontSize: 22 + Constants.textChange,
                          color: Constants.backgroundWhite,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  SlideInRoute(
                                      page: CommentsPage(), direction: 2))
                              .then((value) {
                            print("RETURNED TO USER PAGE");
                            setState(() {});
                          });
                        },
                        child: Image.asset(
                          "lib/assets/images/commentsIcon.png",
                          color: Constants.backgroundWhite,
                          height: 35,
                          width: 35,
                        ),
                      ),
                      Image.asset(
                        "lib/assets/images/shareIcon.png",
                        color: Constants.backgroundWhite,
                        height: 25,
                        width: 25,
                      ),
                      Image.asset(
                        "lib/assets/images/downarrowIcon.png",
                        color: Constants.backgroundWhite,
                        height: 25,
                        width: 25,
                      ),
                    ],
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width * .9,
                    color: Constants.purpleColor,
                  ),
                  Container(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "1,171 Klout",
                        style: ts,
                      ),
                      Text(
                        "73 Comments",
                        style: ts,
                      ),
                      Text(
                        "1,200 K",
                        style: ts,
                      ),
                    ],
                  ),
                  showComments ? commentsWidget() : Container(),
                ],
              );
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

  Widget commentsWidget() {
    return Container(
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.1,
        maxChildSize: 0.8,
        builder: (BuildContext context, myscrollController) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.tealAccent[200],
            child: ListView.builder(
              controller: myscrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text(
                  'Dish $index',
                  style: TextStyle(color: Colors.black54),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
