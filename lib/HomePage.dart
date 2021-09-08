import 'package:flutter/material.dart';
import 'package:klip/HomeTab.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/Requests.dart';
import 'package:klip/UserPage.dart';
import 'package:klip/currentUser.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int homePageSideScrollPosition = 1;
  bool isSearching = false;
  FocusNode searchFocus = FocusNode();
  String searchText;
  dynamic searchResults = [];

  callback(newPagePosition) {
    setState(() {
      homePageSideScrollPosition = newPagePosition;
    });
  }

  TextEditingController searchController;
  @override
  void initState() {
    super.initState();
    searchController = new TextEditingController();
    searchController.addListener(() async {
      setState(() {
        searchText = searchController.text;
      });
      if (searchText != null && searchText != "" && searchText != " ") {
        //query backend
        print("Searching for " + searchText);
        await search(currentUser.uid, searchText).then((ret) {
          setState(() {
            searchResults = ret;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSearching) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      },
      child: Scaffold(
        backgroundColor: Constants.theme.background,
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Constants.statusBarHeight + 10,
                  bottom: 10,
                ),
                child: Stack(
                  children: [
                    isSearching
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSearching = false;
                                    });
                                    showBottomNavBar.value = true;
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10, left: 8),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Constants.theme.foreground,
                                      size: 21,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 7),
                                    child: TextFormField(
                                      controller: searchController,
                                      focusNode: searchFocus,
                                      decoration: InputDecoration(
                                        prefix: Container(
                                          width: 12,
                                        ),
                                        border: InputBorder.none,
                                        hintText: "Search...",
                                        hintStyle: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                searchController.text.length > 0
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            searchController.text = "";
                                          });
                                        },
                                        behavior: HitTestBehavior.translucent,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8, right: 10),
                                          child: Icon(
                                            Icons.close,
                                            size: 21,
                                            color: Constants.theme.foreground,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        : Container(),
                    !isSearching
                        ? Stack(
                            children: [
                              Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width * .15,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset(
                                      "lib/assets/iconsUI/backpackIcon.png",
                                      //width: 100,
                                      //height: 100,
                                      //fit: BoxFit.fill,
                                      color: Constants.theme.foreground,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSearching = true;
                                    if (isSearching) searchFocus.requestFocus();
                                    searchController.text = "";
                                    showBottomNavBar.value = false;
                                  });
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * .65,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Constants.theme.currentTheme == "Dark" ? Colors.black26 : Colors.transparent,
                                      border: Constants.theme.currentTheme == "Dark"
                                          ? Border.all(width: 0, color: Colors.transparent)
                                          : Border.all(color: Constants.theme.foreground, width: .8),
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Search (beep boop)",
                                      style:
                                          TextStyle(color: Constants.theme.currentTheme == "Dark" ? Constants.hintColor : Constants.theme.foreground),
                                    )),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width * .2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentUser.numKredits,
                                        style: TextStyle(color: Constants.theme.foreground, fontSize: 20),
                                      ),
                                      Container(
                                        width: 3,
                                      ),
                                      Image.asset(
                                        "lib/assets/iconsUI/coins.png",
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.fill,
                                        color: Constants.theme.foreground,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            isSearching
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      behavior: HitTestBehavior.translucent,
                      child: searchText == null || searchText == "" || searchText == " "
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_outlined,
                                      color: Constants.hintColor,
                                      size: 30,
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Text(
                                      "Your Seach Results\nWill Appear Here",
                                      style: TextStyle(fontSize: 15, color: Constants.hintColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : searchResults.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    return searchResultCard(context, searchResults[index]);
                                  },
                                )
                              : Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 30,
                                      left: MediaQuery.of(context).size.width / 6,
                                      right: MediaQuery.of(context).size.width / 6,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Cound not find \"" + searchController.text + "\"",
                                          style: TextStyle(
                                            fontSize: 20 + Constants.textChange,
                                            fontWeight: FontWeight.w600,
                                            color: Constants.theme.foreground,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Container(
                                          height: 30,
                                        ),
                                        Text(
                                          "Try searching again and check your spelling or use a different keyword",
                                          style: TextStyle(fontSize: 15, color: Constants.hintColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  )
                : Expanded(
                    child: HomeTab(homePageSideScrollPosition, callback),
                  ),
          ],
        ),
      ),
    );
  }

  Widget searchResultCard(BuildContext ctx, dynamic res) {
    int boldIndex = res["uName"].toLowerCase().indexOf(searchController.text.toLowerCase());
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPage(res["uid"], callback, false, true)),
        ).then((val) {
          setState(() {
            isSearching = false;
            showBottomNavBar.value = true;
          });
        });
        showBottomNavBar.value = true;
      },
      behavior: HitTestBehavior.translucent,
      child: Card(
        elevation: 5,
        color: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 25, right: MediaQuery.of(context).size.width / 25, top: 10),
        child: Container(
          height: 70,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 12),
                child: ClipOval(
                  child: FutureBuilder<Widget>(
                    future: getProfileImage(res["uid"] + "_avatar.jpg", res["avatar"], true),
                    // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      double sizeofImage = 35;
                      if (snapshot.hasData) {
                        return Container(
                          height: sizeofImage,
                          width: sizeofImage,
                          child: snapshot.data,
                        );
                      } else {
                        return Container(
                          height: sizeofImage,
                          width: sizeofImage,
                          child: Constants.tempAvatar,
                        );
                      }
                    },
                  ),
                ),
              ),
              boldIndex != -1
                  ? RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TextStyle(
                          fontSize: 16.0 + Constants.textChange,
                          color: Constants.theme.foreground.withOpacity(.8),
                        ),
                        children: <TextSpan>[
                          TextSpan(text: res["uName"].toString().substring(0, boldIndex)),
                          TextSpan(
                            text: res["uName"].toString().substring(
                                  boldIndex,
                                  searchController.text.length + boldIndex,
                                ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.5 + Constants.textChange,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(text: res["uName"].substring(searchController.text.length + boldIndex)),
                        ],
                      ),
                    )
                  : Text(""),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
