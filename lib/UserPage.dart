import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:klip/login/loginLogic.dart';
import 'package:klip/ProfileSettings.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
import './PaymentFunctions.dart';
import './ContentListItem.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:stripe_payment/stripe_payment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Navigation.dart';
import 'Requests.dart';
import 'currentUser.dart';

class UserPage extends StatefulWidget {
  final String uid;
  Function(int) callback;
  bool isHomeUserPage;
  bool addBackArrow;
  UserPage(this.uid, this.callback, this.isHomeUserPage, this.addBackArrow);

  @override
  _UserPageState createState() => _UserPageState(uid, callback, isHomeUserPage, addBackArrow);
}

class _UserPageState extends State<UserPage> {
  String uid;
  Function(int) callback;
  bool isHomeUserPage;
  bool addBackArrow;
  _UserPageState(this.uid, this.callback, this.isHomeUserPage, this.addBackArrow);

  bool isFollowing;
  String numKredits;
  String numViews;
  String uName;
  String bio;
  String bioLink;
  Image avatar;
  final AsyncMemoizer memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
      publishableKey: Constants.StripePKey,
      androidPayMode: 'test',
    ));
    currentUser.displayCurrentUser();

    setUserPageValues(uid);
  }

  void setUserPageValues(String uid) async {
    if (currentUser.currentUserFollowing.contains(uid)) {
      isFollowing = true;
    } else {
      isFollowing = false;
    }
    if (currentUser.uid == uid) {
      if (currentUser.uName == "FieldNotFound") {
        //For some reason user data has not been loaded properly
        //will try loading again
        await setUpCurrentUserFromMongo(uid);
      }
      Image avatarImage = await currentUser.userProfileImg;
      setState(() {
        avatar = avatarImage;
        numKredits = currentUser.numKredits;
        numViews = currentUser.numViews;
        uName = currentUser.uName;
        bio = currentUser.bio;
        bioLink = currentUser.bioLink;
      });
    } else {
      var user = await getUser(uid);
      Image avatarImage = await currentUser.getProfileImage(uid + "_avatar.jpg", getAWSLink(uid), false);
      setState(() {
        avatar = avatarImage;
        numKredits = user["numKredits"];
        numViews = user["numViews"];
        uName = user["uName"];
        bio = user["bio"];
        bioLink = user["bioLink"];
      });
    }
  }

  void _launchbioLink(BuildContext ctx, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showError(ctx, "Could not Launch Link");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Constants.backgroundBlack,
        body: Padding(
          padding: EdgeInsets.only(
            bottom: isHomeUserPage ? 0 : Constants.bottomNavBarHeight,
            top: isHomeUserPage ? 0 : MediaQuery.of(context).padding.top,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              Stack(
                children: [
                  addBackArrow
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back, color: Constants.backgroundWhite, size: 30),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              numViews.toString() ?? "",
                              style: TextStyle(
                                fontSize: 28 + Constants.textChange,
                                color: Constants.backgroundWhite,
                              ),
                            ),
                            Text(
                              "Views",
                              style: TextStyle(
                                fontSize: 14 + Constants.textChange,
                                color: Constants.backgroundWhite.withOpacity(.5),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 10,
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              numKredits.toString() ?? "",
                              style: TextStyle(
                                fontSize: 28 + Constants.textChange,
                                color: Constants.backgroundWhite,
                              ),
                            ),
                            Text(
                              "Kredits",
                              style: TextStyle(
                                fontSize: 14 + Constants.textChange,
                                color: Constants.backgroundWhite.withOpacity(.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .95,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Constants.purpleColor.withOpacity(0), Constants.purpleColor.withOpacity(.2)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 25, left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (currentUser.uid == uid) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettings())).then((value) {
                                          setUserPageValues(currentUser.uid);
                                          setState(() {});
                                        });
                                      } else {
                                        if (!isFollowing) {
                                          print("Following");
                                          currentUser.currentUserFollowing.add(uid);
                                          setState(() {
                                            isFollowing = true;
                                          });
                                          setFieldInSharedPreferences("currentUserFollowing", currentUser.currentUserFollowing);
                                          userFollowsUser(currentUser.uid, uid);
                                        } else {
                                          print("Unfollowing");
                                          currentUser.currentUserFollowing.remove(uid);
                                          setState(() {
                                            isFollowing = false;
                                          });
                                          setFieldInSharedPreferences("currentUserFollowing", currentUser.currentUserFollowing);
                                          userUnfollowsUser(currentUser.uid, uid);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width / 50 * 12,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: kElevationToShadow[4],
                                        color: Constants.purpleColor.withOpacity(.6),
                                      ),
                                      child: Center(
                                        child: Text(
                                          uid == currentUser.uid
                                              ? "Settings"
                                              : isFollowing
                                                  ? "Following"
                                                  : "Follow",
                                          style: TextStyle(
                                            color: Constants.backgroundWhite.withOpacity(.9),
                                            fontSize: 15 + Constants.textChange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      checkIfNativePayReady();
                                    },
                                    child: Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width / 50 * 12,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: kElevationToShadow[4],
                                        color: Constants.purpleColor.withOpacity(.6),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Subscribe",
                                          style: TextStyle(
                                            color: Constants.backgroundWhite.withOpacity(.9),
                                            fontSize: 15 + Constants.textChange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  uName ?? "",
                                  style: TextStyle(
                                    fontSize: 23 + Constants.textChange,
                                    color: Constants.backgroundWhite.withOpacity(.9),
                                  ),
                                ),
                              ),
                            ),
                            bio != null && bio != "" && bio != " "
                                ? Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text(
                                      bio,
                                      style: TextStyle(
                                        fontSize: 13 + Constants.textChange,
                                        color: Constants.backgroundWhite.withOpacity(.6),
                                      ),
                                    ),
                                  )
                                : Container(),
                            bioLink != null && bioLink != ""
                                ? GestureDetector(
                                    onTap: () {
                                      _launchbioLink(context, bioLink);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        bioLink.substring(0, 7) == "http://"
                                            ? bioLink.substring(7)
                                            : bioLink.substring(0, 8) == "https://"
                                                ? bioLink.substring(8)
                                                : bioLink,
                                        style: TextStyle(
                                          fontSize: 13 + Constants.textChange,
                                          decoration: TextDecoration.underline,
                                          letterSpacing: .75,
                                          color: Constants.purpleColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        width: 150,
                        child: CircleAvatar(
                          radius: 75,
                          child: ClipOval(child: avatar ?? Container()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: memoizer.runOnce(() => getUserContent(uid)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Build the widget with data.
                    dynamic objList = snapshot.data;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: objList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 0),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ContentListItem(objList[index], isHomeUserPage),
                            ///////////////////////////DELIMETER//////////////////////////
                            index != objList.length - 1
                                ? Center(
                                    child: Container(
                                      height: .5,
                                      width: MediaQuery.of(context).size.width * .95,
                                      color: Constants.hintColor,
                                    ),
                                  )
                                : Container(),
                            ///////////////////////////DELIMETER//////////////////////////
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (uid == currentUser.uid) {
      homePagePosition = 0;
      homePageController.animateToPage(homePagePosition, duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      Navigator.of(context).pop();
    }
    return false;
  }
}
