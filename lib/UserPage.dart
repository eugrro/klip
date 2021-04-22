import 'package:flutter/material.dart';
import 'package:klip/login/loginLogic.dart';
import 'package:klip/profileSettings.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
import './PaymentFunctions.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Navigation.dart';
import 'Requests.dart';
import 'currentUser.dart';

class UserPage extends StatefulWidget {
  final String uid;
  UserPage(this.uid);

  @override
  _UserPageState createState() => _UserPageState(uid);
}

class _UserPageState extends State<UserPage> {
  String uid;
  _UserPageState(this.uid);

  bool isFollowing;
  String numKredits;
  String numViews;
  String uName;
  String bio;
  String bioLink;
  Image avatar;

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
      Image avatarImage = await currentUser.getProfileImage(uid + "_avatar.jpg", getAWSLink(uid));
      setState(() {
        numKredits = user["numkredits"];
        numViews = user["numviews"];
        uName = user["uname"];
        bio = user["bio"];
        avatar = avatarImage;
      });
    }
  }

  void _launchbioLink(BuildContext ctx, String url) async {
    if (url.split('//')[0] != "https:" || url.split('//')[0] != "http:") {
      url = "https://" + url;
    }
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Constants.statusBarHeight + 10,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              numViews == null ? "" : numViews.toString(),
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
                              numKredits == null ? "" : numKredits.toString(),
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
                            colors: [Constants.purpleColor.withOpacity(.05), Constants.purpleColor.withOpacity(.2)],
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
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [Colors.purple, Constants.purpleColor.withOpacity(.4)],
                                        ),
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
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [Constants.purpleColor.withOpacity(.4), Colors.purple],
                                        ),
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
                                  uName == null ? "" : uName,
                                  style: TextStyle(
                                    fontSize: 26 + Constants.textChange,
                                    color: Constants.backgroundWhite.withOpacity(.9),
                                  ),
                                ),
                              ),
                            ),
                            bio != null
                                ? Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text(
                                      bio,
                                      style: TextStyle(
                                        fontSize: 14 + Constants.textChange,
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
                                        bioLink,
                                        style: TextStyle(
                                          fontSize: 14 + Constants.textChange,
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
                          child: ClipOval(child: avatar == null ? Container() : avatar),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 0),
              children: [
                //vidListItem(),
                vidListItem(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    homePagePosition = 0;
    homePageController.animateToPage(homePagePosition, duration: Duration(milliseconds: 500), curve: Curves.ease);
    return false;
  }

  Widget vidListItem() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 30,
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Container(
              height: 120,
              width: 220,
              color: Colors.indigo,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Container(
                  width: 125,
                  child: AutoSizeText(
                    'Woah what an epic video Title!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.backgroundWhite,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              Text(
                "104 Views",
                style: TextStyle(
                  fontSize: 13,
                  color: Constants.backgroundWhite,
                ),
              ),
              Text(
                "13 Comments",
                style: TextStyle(
                  fontSize: 13,
                  color: Constants.backgroundWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
